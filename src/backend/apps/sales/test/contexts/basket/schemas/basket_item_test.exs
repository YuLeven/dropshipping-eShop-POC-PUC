defmodule Sales.Basket.Schemas.BasketItemTest do
  use Sales.DataCase

  alias Sales.Basket.Schemas.BasketItem

  @valid_attrs %{picture_url: "some picture_url", price: "120.5", product_id: "some product_id", product_name: "some product_name", quantity: 42}
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