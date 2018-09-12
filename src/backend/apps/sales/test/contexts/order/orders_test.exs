defmodule Sales.OrdersTest do
  import Mock
  use Sales.DataCase
  alias Sales.Orders
  alias Sales.Orders.Order
  alias Sales.Baskets
  import Ecto.Query

  describe "place_order/1" do
    test "persists and enqueues order" do
      with_mock Sales.Rabbitmq, post_message: fn _queue, _payload -> "enqueued" end do
        basket = Baskets.cast_basket!(user_id: 1)

        valid_order = %Order{
          basket_id: basket.id,
          buyer_id: 1,
          delivery_address_id: 1,
          invoice_total: Decimal.new(12.98)
        }

        Orders.place_order(valid_order)

        first_order = Orders.list_orders(user_id: 1) |> Enum.at(0)

        assert %{supplier_status: "enqueued"} = first_order

        assert_called(
          Sales.Rabbitmq.post_message("order_placements", Poison.encode!(first_order))
        )
      end
    end
  end

  describe "list_orders/1" do
    test "returns all orders belonging to an user" do
      basket = Baskets.cast_basket!(user_id: 1)

      valid_order = %Order{
        basket_id: basket.id,
        buyer_id: 1,
        delivery_address_id: 1,
        invoice_total: Decimal.new(12.98)
      }

      first_order =
        Order.changeset(valid_order, %{supplier_status: "enqueued"})
        |> Repo.insert!()
        |> Repo.preload(basket: :basket_itens)

      second_order =
        Order.changeset(valid_order, %{supplier_status: "enqueued"})
        |> Repo.insert!()
        |> Repo.preload(basket: :basket_itens)

      assert Orders.list_orders(user_id: 1) == [first_order, second_order]
    end

    test "returns an empty list when there are no orders" do
    end
  end
end
