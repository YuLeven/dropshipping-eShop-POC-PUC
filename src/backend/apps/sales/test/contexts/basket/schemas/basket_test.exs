defmodule Sales.Basket.BasketTest do
  use Sales.DataCase

  alias Sales.Baskets.Basket

  @valid_attrs %{buyer_id: 1, status: "active"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Basket.changeset(%Basket{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Basket.changeset(%Basket{}, @invalid_attrs)
    refute changeset.valid?
  end
end
