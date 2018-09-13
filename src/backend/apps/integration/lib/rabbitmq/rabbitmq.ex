defmodule Integration.Rabbitmq do
  @rabbit_conn_string "amqp://guest:guest@rabbitmq"
  require Logger

  def establish_connection!(attempts \\ 0) do
    AMQP.Connection.open(@rabbit_conn_string)
    |> case do
      {:ok, connection} ->
        connection

      {:error, _} ->
        Logger.info("Failed to establish rabbitMQ connection. Retrying...")
        Process.sleep(1000)
        establish_connection!(attempts + 1)
    end
  end

  def open_channel!(connection) do
    {:ok, channel} = AMQP.Channel.open(connection)
    channel
  end

  def declare_queue(channel, queue_name) do
    AMQP.Queue.declare(channel, queue_name, durable: true)
    AMQP.Basic.qos(channel, prefetch_count: 1)
    channel
  end

  def consume_messages(channel, queue) do
    AMQP.Basic.consume(channel, queue)
    channel
  end
end
