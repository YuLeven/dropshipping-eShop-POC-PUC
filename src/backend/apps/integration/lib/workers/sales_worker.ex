defmodule Integration.SalesWorker do
  use GenServer
  require Logger
  alias Integration.Rabbitmq

  @queue "order_placements"

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_args) do
    IO.puts("Starting worker #{__MODULE__}")

    Rabbitmq.establish_connection!()
    |> Rabbitmq.open_channel!()
    |> Rabbitmq.declare_queue(@queue)
    |> Rabbitmq.consume_messages(@queue)
    |> wait_for_messages
  end

  defp wait_for_messages(channel) do
    receive do
      {:basic_deliver, payload, meta} ->
        Poison.decode(payload) |> dispatch_purchase_notification
        AMQP.Basic.ack(channel, meta.delivery_tag)
        wait_for_messages(channel)
    end
  end

  defp dispatch_purchase_notification({:ok, order}) do
    Logger.info("Will integrate new order")
  end

  defp dispatch_purchase_notification({:error, error}), do: IO.inspect(error)
end
