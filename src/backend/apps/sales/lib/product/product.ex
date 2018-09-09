defmodule Sales.Product do
  alias Sales.ProductRepo
  alias Sales.Product.Schemas
  import Ecto.Query

  def seed_fake_product_data(total_to_seed) do
    Faker.start()

    for i <- 0..total_to_seed, i > 0 do
      product = %Schemas.Product{
        name: Faker.Commerce.product_name(),
        price: Faker.Commerce.price(),
        description: Faker.Lorem.Shakespeare.hamlet(),
        picture_url: Faker.Avatar.image_url()
      }

      ProductRepo.insert!(product)
    end
  end

  def list_all do
    Schemas.Product
    |> ProductRepo.all()
  end

  def find_by_id(id) do
    ProductRepo.one(from p in Schemas.Product, where: p.id == ^id)
  end

  def find_by_name(name) do
    ProductRepo.all(from p in Schemas.Product, where: p.name == ^name)
  end
end
