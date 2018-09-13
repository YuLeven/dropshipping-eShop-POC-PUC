defmodule SalesWeb.GraphQL.Schema do
  alias SalesWeb.GraphQL.Schema
  use Absinthe.Schema

  import_types(Schema.ProductTypes)
  import_types(Schema.OrderTypes)
  import_types(Schema.BasketTypes)

  query do
    import_fields(:product_queries)
    import_fields(:order_queries)
    import_fields(:basket_queries)
  end

  mutation do
    import_fields(:basket_mutations)
  end
end
