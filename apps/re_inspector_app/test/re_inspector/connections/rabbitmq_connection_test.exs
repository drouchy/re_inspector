defmodule ReInspector.App.Connections.RabbitMQTest do
  use ExUnit.Case

  alias ReInspector.App.Connections.RabbitMQ

  # create_connection/1
  test "returns the pid of the created connection" do
    %{pid: pid} = RabbitMQ.create_connection(ReInspector.Support.RabbitMQ.config)

    assert pid != nil
  end

  #create_channel/1
  test "creates a channel on the connection" do
    %{pid: pid} = RabbitMQ.create_channel rabbit_connection

    assert pid != nil
  end

  # declare_exchange/4
  test "returns :ok when the exchange is declared" do
    :ok = RabbitMQ.declare_exchange(rabbit_channel, "exchange name", :direct, [durable: true])
  end

  #declare_queue/2
  test "with a queue name returns the name of the declared queue" do
    %{queue: "queue_name"} = RabbitMQ.declare_queue rabbit_channel, "queue_name"
  end

  #declare_queue/1
  test "without a queue name returns a generated name of the declared queue" do
    %{queue: queue_name} = RabbitMQ.declare_queue rabbit_channel, "", auto_delete: true
    assert queue_name != nil
  end

  #bind_queue_and_exchange/3
  test "returns :ok when the exchange and the channel are binded" do
    channel = rabbit_channel
    RabbitMQ.declare_exchange(channel, "exchange_name")
    RabbitMQ.declare_queue(channel, "queue_name")

    :ok = RabbitMQ.bind_queue_and_exchange channel, "queue_name", "exchange_name"
  end

  #publish/4..5
  test "returns :ok when the payload has been published" do
    channel = rabbit_channel
    RabbitMQ.declare_exchange(channel, "exchange_name")

    :ok = RabbitMQ.publish channel, "exchange_name", "routing.key", "payload"
  end

  #subscribe/3
  test "returns the subscription id when subscription is done" do
    channel = rabbit_channel
    RabbitMQ.declare_queue(channel, "queue_name")

    subscription_id = RabbitMQ.subscribe channel, "queue_name", fn (_,_) -> :result end

    assert subscription_id != nil
  end

  defp rabbit_connection, do: RabbitMQ.create_connection(ReInspector.Support.RabbitMQ.config)
  defp rabbit_channel,    do: RabbitMQ.create_channel(rabbit_connection)
end