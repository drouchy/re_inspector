defmodule ReInspector.App.Connections.RabbitMQ do
  require Logger

  def create_connection(config) do
    Logger.info "create rabbitmq connection with #{inspect config}"
    {:ok, connection} = AMQP.Connection.open config
    connection
  end

  def create_channel(connection) do
    Logger.debug "create connection channel"
    {:ok, channel} = AMQP.Channel.open connection
    channel
  end

  def declare_exchange(channel, exchange_name, type \\ :direct, options \\ []) do
    Logger.debug "declare exchange #{exchange_name}  with type #{type} and options #{inspect options}"
    AMQP.Exchange.declare channel, exchange_name, type, options
  end

  def declare_queue(channel, queue_name \\ "", options \\ []) do
    Logger.debug "declare a new queue #{queue_name}"
    {:ok, queue} = AMQP.Queue.declare channel, queue_name, options
    queue
  end

  def bind_queue_and_exchange(channel, queue_name, exchange_name, options \\ []) do
    Logger.debug "binding exhange #{exchange_name} with queue #{queue_name}"
    AMQP.Queue.bind channel, queue_name, exchange_name, options
  end

  def publish(channel, exchange_name, routing_key, payload, options \\ []) do
    Logger.debug "publish on exhange #{exchange_name} with routing key #{routing_key} - payload #{inspect payload} - options #{inspect options}"
    AMQP.Basic.publish channel, exchange_name, routing_key, payload, options
  end

  def subscribe(channel, queue_name, callback) do
    Logger.debug "subscribing to queue #{queue_name}"
    {:ok, subscription_id} = AMQP.Queue.subscribe channel, queue_name, callback
    subscription_id
  end
end