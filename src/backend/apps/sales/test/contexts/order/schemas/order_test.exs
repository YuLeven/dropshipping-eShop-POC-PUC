defmodule Sales.OrderTest do
  use Sales.DataCase

  alias Sales.Orders.Order

  @valid_attrs %{
    buyer_id: 42,
    delivery_address_id: 42,
    invoice_total: "120.5",
    supplier_status: "some supplier_status"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Order.changeset(%Order{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Order.changeset(%Order{}, @invalid_attrs)
    refute changeset.valid?
  end
end
