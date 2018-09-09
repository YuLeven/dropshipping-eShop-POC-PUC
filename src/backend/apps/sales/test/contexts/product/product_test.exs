defmodule Sales.ProductTest do
  use Sales.DataCase

  alias Sales.Product
  alias Sales.ProductRepo
  alias Sales.Product.ProductEntity
  import Ecto.Query

  setup do
    Product.seed_fake_product_data(50)
    :ok
  end

  describe "list_all/0" do
    test "lists all products" do
      retrieved_products = Product.list_all()
      assert Enum.count(retrieved_products) == 50
    end
  end

  describe "find_by_id/1" do
    test "retrieves a product by its id" do
      product = ProductRepo.one(from(p in ProductEntity, limit: 1))
      assert Product.find_by_id(product.id) == product
    end

    test "retrieves nil if given nonexistent id" do
      assert Product.find_by_id(-1) == nil
    end
  end

  describe "find_by_name/1" do
    test "retrieves a product by its name" do
      product = ProductRepo.one(from(p in ProductEntity, limit: 1))
      assert Product.find_by_name(product.name) == [product]
    end

    test "retrieves an empty list if given nonexistent product name" do
      assert Product.find_by_name("foo") == []
    end
  end
end
