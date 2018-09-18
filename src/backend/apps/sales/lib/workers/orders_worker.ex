defmodule Sales.OrdersWorker do
  use GenServer
  use AMQP
  require Logger
  alias Sales.Orders

  @queue "order_confirmations"

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_args) do
    IO.puts("Starting worker #{__MODULE__}")

    channel =
      RabbitmqClient.establish_connection!()
      |> RabbitmqClient.open_channel!()
      |> RabbitmqClient.declare_queue(@queue)
      |> RabbitmqClient.consume_messages(@queue)

    {:ok, channel}
  end

  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, channel) do
    {:noreply, channel}
  end

  def handle_info({:basic_deliver, payload, meta}, channel) do
    Poison.decode(payload, keys: :atoms) |> handle_processed_order
    RabbitmqClient.ack(channel, meta.delivery_tag)
  end

  defp handle_processed_order({:ok, args}) do
    Orders.get(args.order_id)
    |> Orders.update_order_status(args.status)
  end

  defp handle_processed_order({:error, error}), do: IO.inspect(error)
end
