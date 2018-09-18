defmodule Integration.AuthClient do
  @response_queue "auth_rpc_response"
  @queue "auth_rpc"

  def get_account(buyer_id), do: dispatch_message("get_account", buyer_id)

  def get_address(address_id), do: dispatch_message("get_address", address_id)

  defp dispatch_message(method, args) do
    RabbitmqClient.establish_connection!()
    |> RabbitmqClient.open_channel!()
    |> RabbitmqClient.declare_queue(@response_queue)
    |> RabbitmqClient.consume_messages(@response_queue, nil, no_ack: true)

    correlation_id = build_correlation_id()

    RabbitmqClient.post_message(
      @queue,
      %{method: method, args: args},
      correlation_id: correlation_id,
      reply_to: @response_queue
    )

    wait_for_messages(correlation_id)
  end

  defp wait_for_messages(correlation_id) do
    receive do
      {:basic_deliver, payload, %{correlation_id: ^correlation_id}} ->
        Poison.decode!(payload)
    end
  end

  defp build_correlation_id do
    :erlang.unique_integer()
    |> :erlang.integer_to_binary()
    |> Base.encode64()
  end
end
