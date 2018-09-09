defmodule Sales.BasketsTest do
  use Sales.DataCase, async: true

  alias Sales.Baskets
  alias Sales.Products
  alias Sales.Baskets.Basket
  alias Sales.Repo
  alias Sales.Payments.CreditCard
  alias Sales.Orders.Order

  @fake_credit_card %CreditCard{
    card_number: "45884547854874569",
    card_holder_name: "John Doe",
    card_expiration: "10/22",
    card_brand: "Visa"
  }

  setup do
    Products.seed_fake_product_data(50)
    :ok
  end

  describe "add_item/2" do
    test "creates a new item on an existing basket" do
      product = Products.list_all() |> Enum.at(0)
      Baskets.cast_basket!(user_id: 1) |> Baskets.add_product(product)

      expected_basket_item = %{
        product_id: product.id,
        price: product.price,
        quantity: 1,
        product_name: product.name
      }

      basket_item = Baskets.cast_basket!(user_id: 1).basket_itens |> Enum.at(0)
      assert expected_basket_item = basket_item
    end

    test "creates many products on existing basket" do
      products = Products.list_all() |> Enum.slice(0, 2)
      product_a = products |> Enum.at(0)
      product_b = products |> Enum.at(1)

      Baskets.cast_basket!(user_id: 1)
      |> Baskets.add_product(product_a)
      |> Baskets.add_product(product_b)

      expected_itens = [
        %{product_id: product_a.id, price: product_a.price, quantity: 1},
        %{product_id: product_b.id, price: product_b.price, quantity: 1}
      ]

      basket_itens = Baskets.cast_basket!(user_id: 1).basket_itens
      basket_item_a = basket_itens |> Enum.at(0)
      basket_item_b = basket_itens |> Enum.at(1)

      assert basket_itens |> Enum.count() == 2
      assert basket_item_a = product_a
      assert basket_item_b = product_b
    end

    test "increases product quantity when already in basket" do
      product = Products.list_all() |> Enum.at(0)

      Baskets.cast_basket!(user_id: 1)
      |> Baskets.add_product(product)
      |> Baskets.add_product(product)

      expected_basket_item = %{
        product_id: product.id,
        price: Decimal.mult(product.price, Decimal.new(2)),
        quantity: 2,
        product_name: product.name
      }

      basket_item = Baskets.cast_basket!(user_id: 1).basket_itens |> Enum.at(0)
      assert expected_basket_item = basket_item
    end
  end

  describe "remove_item/2" do
    test "it removes a single product" do
      product = Products.list_all() |> Enum.at(0)
      basket = Baskets.cast_basket!(user_id: 1) |> Baskets.add_product(product)

      assert basket.basket_itens |> Enum.count() == 1

      basket = basket |> Baskets.remove_product(product)

      assert basket.basket_itens |> Enum.count() == 0
    end

    test "it decreases when there are aggregate products" do
      product = Products.list_all() |> Enum.at(0)

      basket =
        Baskets.cast_basket!(user_id: 1)
        |> Baskets.add_product(product)
        |> Baskets.add_product(product)

      basket_item = basket.basket_itens |> Enum.at(0)
      assert basket.basket_itens |> Enum.count() == 1
      expected_basket_item = %{quantity: 2, price: Decimal.mult(product.price, Decimal.new(2))}
      assert expected_basket_item = basket_item

      basket = basket |> Baskets.remove_product(product)
      basket_item = basket.basket_itens |> Enum.at(0)

      assert basket.basket_itens |> Enum.count() == 1
      expected_basket_item = %{quantity: 2, price: Decimal.mult(product.price, Decimal.new(2))}
      assert expected_basket_item = basket_item
    end
  end

  describe "cast_basket!/1" do
    test "creates a new basket when none unpayed exists for the current user" do
      [%Basket{buyer_id: 1, payed: false}, %Basket{buyer_id: 2, payed: true}]
      |> Enum.each(&Repo.insert!/1)

      new_basket = Baskets.cast_basket!(user_id: 2)
      assert %Basket{buyer_id: 2, payed: false} = new_basket
    end

    test "retrieves the user current basket if there's an unpayed available" do
      [%Basket{buyer_id: 1, payed: false}, %Basket{buyer_id: 1, payed: true}]
      |> Enum.each(&Repo.insert!/1)

      retrieved_basket = Baskets.cast_basket!(user_id: 1)
      assert %Basket{buyer_id: 1, payed: false} = retrieved_basket
    end
  end

  describe "destroy_basket/1" do
    test "destroys existing basket" do
      basket = Baskets.cast_basket!(user_id: 1)
      basket |> Baskets.destroy_basket()

      deleted_basket = from(b in Basket, where: b.id == ^basket.id) |> Repo.one()

      assert deleted_basket == nil
    end
  end

  describe "checkout!/1" do
    test "places a new order" do
      product = Products.list_all() |> Enum.at(0)

      basket =
        Baskets.cast_basket!(user_id: 1)
        |> Baskets.add_product(product)

      basket |> Baskets.checkout!(@fake_credit_card, buyer_id: 1, address_id: 1)

      placed_order =
        from(o in Order, where: o.basket_id == ^basket.id)
        |> Repo.one()

      basket_id = basket.id

      assert %{
               basket_id: basket_id,
               buyer_id: 1,
               delivery_address_id: 1
             } = placed_order
    end

    test "raises if a basket with no itens is provided for checkout" do
      assert_raise ArgumentError, "A basket must contain itens before checking out.", fn ->
        Baskets.cast_basket!(user_id: 1) |> Baskets.checkout!(nil, nil)
      end
    end

    test "raises if a basket already payed for is provided for checkout" do
      assert_raise ArgumentError, "This basket has already been payed for.", fn ->
        product = Products.list_all() |> Enum.at(0)

        Baskets.cast_basket!(user_id: 1)
        |> Baskets.add_product(product)
        |> Basket.changeset(%{payed: true})
        |> Repo.update!()
        |> Baskets.checkout!(nil, nil)
      end
    end
  end
end
