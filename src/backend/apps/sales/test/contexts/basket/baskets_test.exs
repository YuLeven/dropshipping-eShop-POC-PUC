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

      basket_item =
        Baskets.cast_basket!(user_id: 1).basket_itens
        |> Enum.at(0)
        |> Map.from_struct()

      assert Enum.all?(expected_basket_item, &(&1 in basket_item))
    end

    test "creates many products on existing basket" do
      [product_a, product_b | _] = Products.list_all()

      Baskets.cast_basket!(user_id: 1)
      |> Baskets.add_product(product_a)
      |> Baskets.add_product(product_b)

      basket_itens = Baskets.cast_basket!(user_id: 1).basket_itens
      [basket_item_a, basket_item_b | _] = basket_itens

      assert basket_itens
             |> Enum.all?(fn item ->
               [product_a, product_b]
               |> Enum.any?(fn product ->
                 product.id == item.product_id
               end)
             end)

      assert basket_itens |> Enum.count() == 2
    end

    test "increases product quantity when already in basket" do
      product = Products.list_all() |> Enum.at(0)

      Baskets.cast_basket!(user_id: 1)
      |> Baskets.add_product(product)
      |> Baskets.add_product(product)

      basket_item = Baskets.cast_basket!(user_id: 1).basket_itens |> Enum.at(0)
      assert basket_item.product_id == product.id
      assert basket_item.price == Decimal.mult(product.price, Decimal.new(2))
      assert basket_item.quantity == 2
      assert basket_item.product_name == product.name
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
      assert basket_item.price == Decimal.mult(product.price, Decimal.new(2))
      assert basket_item.quantity == 2

      basket = basket |> Baskets.remove_product(product)
      basket_item = basket.basket_itens |> Enum.at(0)

      assert basket.basket_itens |> Enum.count() == 1
      assert basket_item.price == Decimal.mult(product.price, Decimal.new(1))
      assert basket_item.quantity == 1
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

      assert %{buyer_id: 1, delivery_address_id: 1} = placed_order
      assert placed_order.basket_id == basket.id
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
