defmodule ReInspector.App.Connections.RabbitMQ do
  import Lager

  def create_connection(config) do
    Lager.info "create rabbitmq connection with #{inspect config}"
    {:ok, connection} = AMQP.Connection.open config
    connection
  end

  def create_channel(connection) do
    Lager.debug "create connection channel"
    {:ok, channel} = AMQP.Channel.open connection
    channel
  end

  def declare_exchange(channel, exchange_name, type \\ :direct, options \\ []) do
    Lager.debug "declare exchange #{exchange_name}  with type #{type} and options #{inspect options}"
    AMQP.Exchange.declare channel, exchange_name, type, options
  end

  def declare_queue(channel, queue_name) do
    Lager.debug "declare a new queue #{queue_name}"
    {:ok, queue} = AMQP.Queue.declare channel, queue_name
    queue
  end

  def declare_queue(channel) do
    Lager.debug "declare a new anonymous queue"
    {:ok, queue} = AMQP.Queue.declare channel
    queue
  end

  def bind_queue_and_exchange(channel, queue_name, exchange_name) do
    Lager.debug "binding exhange #{exchange_name} with queue #{queue_name}"
    AMQP.Queue.bind channel, queue_name, exchange_name
  end

  def publish(channel, exchange_name, routing_key, payload, options \\ []) do
    Lager.debug "publish on exhange #{exchange_name} with routing key #{routing_key} - payload #{inspect payload} - options #{inspect options}"
    AMQP.Basic.publish channel, exchange_name, routing_key, payload, options
  end

  def subscribe(channel, queue_name, callback) do
    Lager.debug "subscribing to queue #{queue_name}"
    {:ok, subscription_id} = AMQP.Queue.subscribe channel, queue_name, callback
    subscription_id
  end
end