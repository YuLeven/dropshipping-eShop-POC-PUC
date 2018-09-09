defmodule Sales.Basket.BasketTest do
  use Sales.DataCase

  alias Sales.Basket.BasketEntity

  @valid_attrs %{buyer_id: 1, payed: false}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = BasketEntity.changeset(%BasketEntity{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = BasketEntity.changeset(%BasketEntity{}, @invalid_attrs)
    refute changeset.valid?
  end
end
