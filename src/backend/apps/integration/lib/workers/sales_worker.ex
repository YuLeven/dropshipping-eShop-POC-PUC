defmodule Integration.SalesWorker do
  use GenServer
  require Logger
  alias Integration.Rabbitmq

  @queue "order_placements"
  @mule_base_url "http://mule:8081/"

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
        Poison.decode(payload, keys: :atoms) |> dispatch_purchase_notification
        AMQP.Basic.ack(channel, meta.delivery_tag)
        wait_for_messages(channel)
    end
  end

  defp dispatch_purchase_notification({:ok, order}) do
    order.basket.basket_itens
    |> Enum.each(fn item ->
      Logger.info("Integrating order with provider")

      payload = %{
        product_code: item.product_id,
        quantity: item.quantity,
        street: "some street",
        residence_number: 12
      }

      item
      |> fetch_provider_endpoint
      |> HTTPoison.post(Poison.encode!(payload), [{"Content-Type", "application/json"}])
    end)
  end

  defp dispatch_purchase_notification({:error, error}), do: IO.inspect(error)

  defp fetch_provider_endpoint(%{product_provider_id: provider_id}) do
    # TODO: In an actual system, implement a model to store provider data
    endpoint =
      case provider_id do
        1 -> "integration"
        2 -> "provider_b"
      end

    @mule_base_url <> endpoint
  end
end
