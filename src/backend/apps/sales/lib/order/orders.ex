defmodule Sales.Orders do
  alias Sales.Orders.Order
  alias Sales.Repo
  import Ecto.Query

  @place_order_queue "order_placements"

  def place_order(%Order{} = order) do
    order =
      Order.changeset(order, %{supplier_status: "enqueued"})
      |> Repo.insert!()
      |> Repo.preload(basket: :basket_itens)

    @place_order_queue |> RabbitmqClient.post_message(order, persitent: true)
  end

  def list_orders(user_id: user_id) do
    from(o in Order, where: o.buyer_id == ^user_id)
    |> Repo.all()
    |> Repo.preload(basket: :basket_itens)
  end

  def get(id) do
    from(o in Order, where: o.id == ^id)
    |> Repo.one()
    |> Repo.preload(basket: :basket_itens)
  end

  def update_order_status(%Order{} = order, status) do
    Order.changeset(order, %{supplier_status: status})
    |> Repo.update!()
  end
end
