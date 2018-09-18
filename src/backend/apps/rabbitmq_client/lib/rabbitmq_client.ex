defmodule RabbitmqClient do
  @rabbit_conn_string "amqp://guest:guest@rabbitmq"
  @maximum_attemps 10
  require Logger

  def establish_connection!(attempts) when attempts > @maximum_attemps,
    do: {:error, "Failed to establish connection after #{@maximum_attemps} tries."}

  def establish_connection!(attempts \\ 0) do
    AMQP.Connection.open(@rabbit_conn_string)
    |> case do
      {:ok, connection} ->
        connection

      {:error, _} ->
        Logger.info("Failed to establish rabbitMQ connection. Retrying...")
        Process.sleep(3000)
        establish_connection!(attempts + 1)
    end
  end

  def post_message(queue, payload, opts \\ []) do
    conn = establish_connection!()

    conn
    |> open_channel!
    |> declare_queue(queue)
    |> publish_message("", queue, Poison.encode!(payload), opts)

    conn |> AMQP.Connection.close()
  end

  def open_channel!(connection) do
    {:ok, channel} = AMQP.Channel.open(connection)
    channel
  end

  def declare_queue(channel, queue_name, opts \\ []) do
    AMQP.Queue.declare(channel, queue_name, opts)
    channel
  end

  def consume_messages(channel, queue, consumer_id \\ nil, opts \\ []) do
    AMQP.Basic.consume(channel, queue, consumer_id, opts)
    channel
  end

  def ack(channel, tag) do
    AMQP.Basic.ack(channel, tag)
  end

  defp publish_message(channel, exchange, queue, message, opts \\ []) do
    AMQP.Basic.publish(channel, exchange, queue, message, opts)
    channel
  end
end
