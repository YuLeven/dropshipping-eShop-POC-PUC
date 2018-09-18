defmodule Integration.SalesWorker do
  use GenServer
  use AMQP
  require Logger
  alias Integration.AuthClient

  @queue "order_placements"
  @response_queue "order_confirmations"
  @mule_base_url "http://mule:8081/"

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
    Poison.decode(payload, keys: :atoms) |> dispatch_purchase_notification
    RabbitmqClient.ack(channel, meta.delivery_tag)
  end

  defp dispatch_purchase_notification({:ok, order}) do
    address = AuthClient.get_address(order.delivery_address_id)

    order.basket.basket_itens
    |> Enum.each(fn item ->
      Logger.info("Integrating order with provider")

      payload = %{
        product_code: item.product_id,
        quantity: item.quantity,
        delivery_address: address
      }

      item
      |> fetch_provider_endpoint
      |> HTTPoison.post(Poison.encode!(payload), [{"Content-Type", "application/json"}])
    end)

    @response_queue
    |> RabbitmqClient.post_message(%{order_id: order.id, status: "processed"})
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
