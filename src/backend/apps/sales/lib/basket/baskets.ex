defmodule Sales.Baskets do
  alias Sales.Baskets.{Basket, BasketItem}
  alias Sales.Products.Product
  alias Sales.Payments
  alias Sales.Payments.CreditCard
  alias Sales.Repo
  alias Sales.Orders
  alias Sales.Orders.Order
  import Ecto.Query

  def add_product(%Basket{} = basket, %Product{} = product) do
    case basket |> find_basket_item(product) do
      nil ->
        BasketItem.changeset(%BasketItem{}, %{
          product_id: product.id,
          product_name: product.name,
          quantity: 1,
          price: product.price,
          picture_url: product.picture_url,
          basket_id: basket.id
        })
        |> Repo.insert()

      basket_item ->
        BasketItem.changeset(basket_item, basket |> increase_item_count(basket_item, product))
        |> Repo.update()
    end

    cast_basket!(user_id: basket.buyer_id)
  end

  def remove_product(%Basket{} = basket, %Product{} = product) do
    case basket |> find_basket_item(product) do
      nil ->
        nil

      basket_item ->
        if basket_item.quantity == 1 do
          Repo.delete(basket_item)
        else
          BasketItem.changeset(basket_item, basket |> decrease_item_count(basket_item, product))
          |> Repo.update()
        end
    end

    cast_basket!(user_id: basket.buyer_id)
  end

  def cast_basket!(user_id: user_id) do
    basket_query =
      from(
        b in Basket,
        where: b.buyer_id == ^user_id and b.payed == ^false,
        preload: [:basket_itens]
      )

    case Repo.one(basket_query) do
      nil ->
        %Basket{buyer_id: user_id, payed: false}
        |> Repo.insert!()
        |> Repo.preload(:basket_itens)

      basket ->
        basket
    end
  end

  def destroy_basket(%Basket{} = basket) do
    basket |> Repo.delete!()
  end

  def checkout!(%Basket{basket_itens: []} = basket, _, _),
    do: raise(ArgumentError, message: "A basket must contain itens before checking out.")

  def checkout!(%Basket{payed: true}, _, _),
    do: raise(ArgumentError, message: "This basket has already been payed for.")

  def checkout!(
        %Basket{} = basket,
        %CreditCard{} = credit_card_data,
        buyer_id: buyer_id,
        address_id: address_id
      ) do
    invoice_total =
      basket.basket_itens
      |> Enum.reduce(Decimal.new(0), &basket_total_price/2)

    case Payments.process_payment(credit_card_data,
           invoice_total: invoice_total |> Decimal.to_float()
         ) do
      {:ok, payment_info} ->
        %Order{
          buyer_id: buyer_id,
          delivery_address_id: address_id,
          invoice_total: invoice_total,
          basket_id: basket.id
        }
        |> Orders.place_order()

      {:error, error} ->
        {:error, error}
    end
  end

  defp basket_total_price(%BasketItem{} = basket_item, accumulator),
    do: basket_item.price |> Decimal.add(accumulator)

  defp find_basket_item(%Basket{} = basket, %{id: product_id}) do
    from(bi in BasketItem, where: bi.basket_id == ^basket.id and bi.product_id == ^product_id)
    |> Repo.one()
  end

  defp change_item_count(
         %Basket{} = basket,
         %BasketItem{} = basket_item,
         %Product{} = product,
         amount_to_change
       ) do
    %{
      quantity: basket_item.quantity + amount_to_change,
      price: Decimal.new(basket_item.quantity + amount_to_change) |> Decimal.mult(product.price)
    }
  end

  defp decrease_item_count(%Basket{} = basket, %BasketItem{} = item, %Product{} = product) do
    basket
    |> change_item_count(item, product, -1)
  end

  defp increase_item_count(%Basket{} = basket, %BasketItem{} = item, %Product{} = product) do
    basket
    |> change_item_count(item, product, 1)
  end
end
