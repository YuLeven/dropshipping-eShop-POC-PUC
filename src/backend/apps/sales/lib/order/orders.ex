defmodule Sales.Orders do
  alias Sales.Orders.Order
  alias Sales.Repo
  alias Sales.Rabbitmq

  @place_order_queue "order_placements"

  def place_order(%Order{} = order) do
    order =
      Order.changeset(order, %{supplier_status: "enqueued"})
      |> Repo.insert!()
      |> Repo.preload(basket: :basket_itens)

    @place_order_queue |> Rabbitmq.post_message(Poison.encode!(order))
  end
end
