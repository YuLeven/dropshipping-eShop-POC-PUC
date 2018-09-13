defmodule SalesWeb.GraphQL.Schema.ProductTypes do
  use Absinthe.Schema.Notation
  alias SalesWeb.GraphQL.Resolvers

  object :product do
    field(:id, :integer)
    field(:name, :string)
    field(:price, :float)
    field(:description, :string)
    field(:picture_url, :string)
  end

  object :product_queries do
    field :products, list_of(:product) do
      arg(:name, :string)

      resolve(&Resolvers.Product.list_products/3)
    end
  end
end
