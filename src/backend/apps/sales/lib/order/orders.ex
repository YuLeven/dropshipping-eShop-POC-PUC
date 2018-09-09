defmodule Sales.Orders do
  alias Sales.Orders.Order
  alias Sales.Repo

  def place_order(%Order{} = order) do
    Order.changeset(order, %{
      supplier_status: "enqueued"
    })
    |> Repo.insert()

    # TODO: Enqueue on rabbitMQ
  end
end
