defmodule SalesWeb.GraphQL.Schema do
  alias SalesWeb.GraphQL.Schema
  use Absinthe.Schema

  import_types(Schema.ProductTypes)
  import_types(Schema.OrderTypes)

  query do
    import_fields(:product_queries)
    import_fields(:order_queries)
  end
end
