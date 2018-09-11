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

        first_order = from(o in Order, limit: 1) |> Sales.Repo.one!()
        assert %{supplier_status: "enqueued"} = first_order
        assert_called(Sales.Rabbitmq.post_message("order_placements", first_order))
      end
    end
  end
end
