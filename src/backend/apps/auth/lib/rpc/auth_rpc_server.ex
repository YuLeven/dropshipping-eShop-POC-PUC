defmodule Auth.RpcServer do
  use GenServer
  use AMQP
  alias Auth.Accounts
  require Logger

  @queue "auth_rpc"

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
    response = payload |> Poison.decode!() |> handle_method_call

    RabbitmqClient.post_message(
      meta.reply_to,
      response,
      correlation_id: meta.correlation_id
    )

    RabbitmqClient.ack(channel, meta.delivery_tag)
  end

  defp handle_method_call(%{"method" => "get_account", "args" => user_id}),
    do: Accounts.get(user_id)

  defp handle_method_call(%{"method" => "get_address", "args" => address_id}),
    do: Accounts.get_shipping_address(address_id)

  defp handle_method_call(payload), do: %{error: "No method #{payload["method"]} found."}
end
