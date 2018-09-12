defmodule Sales.ProductAggregate.ProductTest do
  use Sales.DataCase

  alias Sales.Products.Product

  @valid_attrs %{
    description: "some description",
    name: "some name",
    picture_url: "some picture_url",
    price: 5.52,
    provider_id: 1
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
