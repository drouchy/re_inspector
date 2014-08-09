defmodule ReInspector.Support.RabbitMQ do
  import ReInspector.App.Connections.RabbitMQ

  def config do
    Application.get_env(:re_inspector_app, :listeners)[:rabbitmq]
    |> List.first
    |> Map.to_list
  end

  def channel do
    create_channel connection
  end

  def connection do
    create_connection(config)
  end

  def main_exchange do
    declare_exchange channel, "re_inspector", type: "direct"
  end

  def prepare_rabbit do
    declare_exchange(channel, "re_inspector.api_request")
    declare_queue(channel, "re_inspector.queues.new_request")
    declare_queue(channel, "re_inspector.queues.correlation")
  end

  def purge_queues do
    AMQP.Queue.purge(channel, "re_inspector.queues.new_request")
    AMQP.Queue.purge(channel, "re_inspector.queues.correlation")
  end

end