defmodule SalesWeb.GraphQL.Resolvers.Product do
  alias Sales.Products

  def list_products(_, %{name: name}, _) do
    {:ok, Products.find_by_name(name)}
  end

  def list_products(_, _, _) do
    {:ok, Products.list_all()}
  end
end
