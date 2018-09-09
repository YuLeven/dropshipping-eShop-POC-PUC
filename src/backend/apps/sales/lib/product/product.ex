defmodule Sales.Product do
  alias Sales.ProductRepo
  alias Sales.Product.Schemas

  def seed_fake_product_data do
    Faker.start()

    for i <- 0..50, i > 0 do
      product = %Schemas.Product{
        name: Faker.Commerce.product_name(),
        price: Faker.Commerce.price(),
        description: Faker.Lorem.Shakespeare.hamlet(),
        picture_url: Faker.Avatar.image_url()
      }

      ProductRepo.insert!(product)
    end
  end
end
