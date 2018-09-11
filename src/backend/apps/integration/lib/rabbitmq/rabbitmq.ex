defmodule Integration.Rabbitmq do
  @rabbit_conn_string "amqp://guest:guest@rabbitmq"

  def establish_connection! do
    {:ok, connection} = AMQP.Connection.open(@rabbit_conn_string)
    connection
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
