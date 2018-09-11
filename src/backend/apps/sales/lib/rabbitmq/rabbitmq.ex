defmodule Sales.Rabbitmq do
  @rabbit_conn_string "amqp://guest:guest@rabbitmq"

  def post_message(queue, %{} = payload) do
    post_message(queue, Poison.encode!(payload))
  end

  def post_message(queue, payload) do
    conn = establish_connection!()

    conn
    |> open_channel!
    |> declare_queue(queue)
    |> publish_message("", queue, payload, persistent: true)

    conn |> AMQP.Connection.close()
  end

  defp establish_connection! do
    {:ok, connection} = AMQP.Connection.open(@rabbit_conn_string)
    connection
  end

  defp open_channel!(connection) do
    {:ok, channel} = AMQP.Channel.open(connection)
    channel
  end

  defp declare_queue(channel, queue_name) do
    AMQP.Queue.declare(channel, queue_name, durable: true)
    channel
  end

  defp publish_message(channel, exchange, queue, message, opts \\ []) do
    AMQP.Basic.publish(channel, exchange, queue, message, opts)
    channel
  end
end
