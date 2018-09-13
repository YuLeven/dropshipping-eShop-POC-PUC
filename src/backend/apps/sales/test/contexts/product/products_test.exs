defmodule Sales.ProductsTests do
  use Sales.DataCase, async: true

  alias Sales.ProductRepo
  alias Sales.Products
  import Ecto.Query

  describe "list_all/0" do
    test "lists all products" do
      retrieved_products = Products.list_all()
      assert Enum.count(retrieved_products) == 50
    end
  end

  describe "find_by_id/1" do
    test "retrieves a product by its id" do
      product = ProductRepo.one(from(p in Products.Product, limit: 1))
      assert Products.find_by_id(product.id) == product
    end

    test "retrieves nil if given nonexistent id" do
      assert Products.find_by_id(-1) == nil
    end
  end

  describe "find_by_name/1" do
    test "retrieves a product by its name" do
      product = ProductRepo.one(from(p in Products.Product, limit: 1))
      assert Products.find_by_name(product.name) |> Enum.member?(product)
    end

    test "retrieves an empty list if given nonexistent product name" do
      assert Products.find_by_name("foo") == []
    end
  end
end
