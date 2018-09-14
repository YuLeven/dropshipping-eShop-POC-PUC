defmodule Sales.Products do
  alias Sales.ProductRepo
  alias Sales.Products.Product
  import Ecto.Query

  def seed_fake_product_data(total_to_seed) do
    Faker.start()

    ProductRepo.delete_all(Product)

    for i <- 0..total_to_seed, i > 0 do
      product = %Product{
        name: Faker.Commerce.product_name(),
        price: Faker.Commerce.price(),
        description: Faker.Lorem.Shakespeare.hamlet(),
        picture_url: Faker.Avatar.image_url(225, 100),
        provider_id: 1
      }

      ProductRepo.insert!(product)
    end
  end

  def list_all do
    Product
    |> ProductRepo.all()
  end

  def find_by_id(id) do
    ProductRepo.one(from(p in Product, where: p.id == ^id))
  end

  def find_by_name(name) do
    ProductRepo.all(from(p in Product, where: like(p.name, ^"%#{name}%")))
  end
end
