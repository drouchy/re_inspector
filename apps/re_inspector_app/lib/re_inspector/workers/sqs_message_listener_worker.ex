defmodule ReInspector.App.Workers.SQSMessageListenerWorker do
  use GenServer
  import Logger

  alias ReInspector.App.Connections.SQS

  @doc """
  """
  def start_link(name, args) do
    worker_name = "re_inspector_sqs_message_listener_#{name}"
    GenServer.start_link(__MODULE__, args, [name: String.to_atom(worker_name)])
  end

  def init(sqs_options) do
    Logger.info "starting the message listener #{sqs_options[:topic]}"
    config = SQS.generate_config(sqs_options)
    pid = spawn_link fn -> listen_sqs(sqs_options, config) end
    {:ok, pid }
  end

  defp listen_sqs(sqs_options, config) do
    SQS.read_message(sqs_options, config)
    |> Enum.each(fn(message) -> process(message, sqs_options, config) end)

    :timer.sleep 300
    listen_sqs(sqs_options, config)
  end

  defp process(message, sqs_options, config) do
    try do
      body = message[:body]
      json = ReInspector.App.JsonParser.decode("#{body}")
      ReInspector.App.process_message(json[:"Message"])
    after
      SQS.delete_message(message[:receipt_handle], sqs_options, config)
    end
  end
end
