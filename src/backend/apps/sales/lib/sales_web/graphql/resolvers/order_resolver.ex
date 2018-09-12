defmodule SalesWeb.GraphQL.Resolvers.Order do
  alias Sales.Orders

  @auth_error {:error, "You must be logged to access this action"}

  def list_orders(_, _, %{context: %{current_user_id: current_user_id}}) do
    {:ok, Orders.list_orders(user_id: current_user_id)}
  end

  def list_orders(_, _, _), do: @auth_error

  def list_products(_, %{name: name}, _) do
    {:ok, Products.find_by_name(name)}
  end

  def list_products(_, _, _) do
    {:ok, Products.list_all()}
  end
end
