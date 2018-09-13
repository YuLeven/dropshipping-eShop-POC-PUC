defmodule SalesWeb.GraphQL.Resolvers.Basket do
  alias Sales.Baskets
  alias Sales.Products
  alias Sales.Payments.CreditCard

  def get_basket(_, _, %{context: %{current_user_id: id}}) do
    {:ok, Baskets.cast_basket!(user_id: id)}
  end

  def add_product(_, %{product_id: product_id}, %{context: %{current_user_id: user_id}}) do
    product = Products.find_by_id(product_id)

    Baskets.cast_basket!(user_id: user_id)
    |> Baskets.add_product(product)

    {:ok, Baskets.cast_basket!(user_id: user_id)}
  end

  def remove_product(_, %{product_id: product_id}, %{context: %{current_user_id: user_id}}) do
    product = Products.find_by_id(product_id)

    Baskets.cast_basket!(user_id: user_id)
    |> Baskets.remove_product(product)

    {:ok, Baskets.cast_basket!(user_id: user_id)}
  end

  def checkout(_, %{credit_card_data: credit_card_data, address_id: address_id}, %{
        context: %{current_user_id: user_id}
      }) do
    try do
      basket =
        Baskets.cast_basket!(user_id: user_id)
        |> Baskets.checkout!(
          struct(CreditCard, credit_card_data),
          buyer_id: user_id,
          address_id: address_id
        )

      {:ok, basket}
    rescue
      error -> {:error, error.message}
    end
  end
end
