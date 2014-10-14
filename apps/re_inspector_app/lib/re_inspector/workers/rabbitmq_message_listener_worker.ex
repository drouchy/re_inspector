defmodule ReInspector.App.Workers.RabbitMQMessageListenerWorker do
  use GenServer
  require Logger

  alias ReInspector.App.Connections.RabbitMQ

  @exchange    "re_inspector.api_request"
  @queue       "re_inspector.queues.new_request"
  @queue_error "#{@queue}_error"

  def start_link(name, args) do
    worker_name = "re_inspector_rabbitmq_message_listener_#{name}"
    GenServer.start_link(__MODULE__, args, [name: String.to_atom(worker_name)])
  end

  def init(options) do
    Logger.debug fn -> "init rabbit mq listener with #{inspect options}" end
    connection = RabbitMQ.create_connection options
    channel    = RabbitMQ.create_channel connection

    RabbitMQ.declare_queue(channel, @queue)
    :ok = RabbitMQ.declare_exchange(channel, @exchange)
    :ok = RabbitMQ.bind_queue_and_exchange(channel, @queue, @exchange, routing_key: "re_inspector.new_request")

    AMQP.Basic.consume(channel, @queue)
    {:ok, channel}
  end

  def handle_info(info, channel) do
    { message, %{delivery_tag: tag}} = info

    message
    |> consume(channel, tag)
    |> launch_processing

    {:noreply, channel}
  end

  defp consume(message, channel, tag) do
    try do
      api_request = message
      |> ReInspector.App.JsonParser.decode
      |> ReInspector.App.Converters.ApiRequestMessageConverter.to_postgres
      |> ReInspector.App.Services.ApiRequestService.persist

      AMQP.Basic.ack channel, tag
      api_request
    rescue
      e -> IO.inspect e ; IO.inspect :erlang.get_stacktrace()
      raise e
    end
  end

  defp launch_processing(api_request), do: ReInspector.App.process_api_request(api_request.id)
end