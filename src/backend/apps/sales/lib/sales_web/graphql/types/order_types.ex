defmodule SalesWeb.GraphQL.Schema.OrderTypes do
  use Absinthe.Schema.Notation
  alias SalesWeb.GraphQL.Resolvers
  alias SalesWeb.GraphQL.Middleware.Authentication

  object :order do
    field(:id, :integer)
    field(:buyer_id, :integer)
    field(:delivery_address_id, :integer)
    field(:invoice_total, :float)
    field(:supplier_status, :string)
    field(:basket, :basket)
    field(:inserted_at, :string)
  end

  object :order_queries do
    field :orders, list_of(:order) do
      middleware(Authentication)
      resolve(&Resolvers.Order.list_orders/3)
    end
  end
end
