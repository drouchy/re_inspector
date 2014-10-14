defmodule ReInspector.App.Connections.RabbitMQ do
  require Logger

  def create_connection(config) do
    Logger.info "create rabbitmq connection with #{inspect config}"
    {:ok, connection} = AMQP.Connection.open config
    connection
  end

  def create_channel(connection) do
    Logger.debug fn -> "create connection channel" end
    {:ok, channel} = AMQP.Channel.open connection
    channel
  end

  def declare_exchange(channel, exchange_name, type \\ :direct, options \\ []) do
    Logger.debug fn -> "declare exchange #{exchange_name}  with type #{type} and options #{inspect options}" end
    AMQP.Exchange.declare channel, exchange_name, type, options
  end

  def declare_queue(channel, queue_name \\ "", options \\ []) do
    Logger.debug fn -> "declare a new queue #{queue_name}" end
    {:ok, queue} = AMQP.Queue.declare channel, queue_name, options
    queue
  end

  def bind_queue_and_exchange(channel, queue_name, exchange_name, options \\ []) do
    Logger.debug fn -> "binding exhange #{exchange_name} with queue #{queue_name}" end
    AMQP.Queue.bind channel, queue_name, exchange_name, options
  end

  def publish(channel, exchange_name, routing_key, payload, options \\ []) do
    Logger.debug fn -> "publish on exhange #{exchange_name} with routing key #{routing_key} - payload #{inspect payload} - options #{inspect options}" end
    AMQP.Basic.publish channel, exchange_name, routing_key, payload, options
  end

  def subscribe(channel, queue_name, callback) do
    Logger.debug fn -> "subscribing to queue #{queue_name}" end
    {:ok, subscription_id} = AMQP.Queue.subscribe channel, queue_name, callback
    subscription_id
  end
end