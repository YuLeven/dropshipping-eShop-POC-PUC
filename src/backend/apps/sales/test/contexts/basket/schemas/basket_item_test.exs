defmodule Sales.Baskets.BasketItemTest do
  use Sales.DataCase

  alias Sales.Baskets.BasketItem

  @valid_attrs %{
    picture_url: "some picture_url",
    price: 120.5,
    product_id: 1,
    product_name: "some product_name",
    quantity: 42,
    basket_id: 1,
    product_provider_id: 1
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = BasketItem.changeset(%BasketItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = BasketItem.changeset(%BasketItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
