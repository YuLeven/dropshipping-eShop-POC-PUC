defmodule SalesWeb.GraphQL.Schema.OrderTypes do
  use Absinthe.Schema.Notation
  alias SalesWeb.GraphQL.Resolvers

  object :order do
    field(:id, :integer)
    field(:buyer_id, :integer)
    field(:delivery_address_id, :integer)
    field(:invoice_total, :float)
    field(:supplier_status, :string)
    field(:basket, :basket)
  end

  object :basket do
    field(:id, :integer)
  end

  object :order_queries do
    field :orders, list_of(:order) do
      resolve(&Resolvers.Order.list_orders/3)
    end
  end
end
