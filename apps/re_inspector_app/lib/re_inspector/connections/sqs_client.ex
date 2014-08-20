defmodule ReInspector.App.Connections.SQS do
  require AWS
  require Logger

  def generate_config(options) do
    AWS.aws_config(
      access_key_id: String.to_char_list(options[:access_client_id]),
      secret_access_key: String.to_char_list(options[:access_client_secret]),
      sqs_host: String.to_char_list(options[:sqs_host]),
      sns_host: String.to_char_list(options[:sns_host]),
    )
  end

  def subscribe(options, config) do
    Logger.info "suscribing to #{options[:topic]}"
    topic = :erlcloud_sns.create_topic(String.to_char_list(options[:topic]), config)
    [queue_url: queue] = :erlcloud_sqs.create_queue(queue_name(options), config)
    IO.inspect topic
    IO.inspect queue
    :erlcloud_sns.subscribe(queue, :https, topic, config)

    IO.inspect :erlcloud_sqs.list_queues('*',config)
  end

  def read_message(options, config) do
    [messages: messages] = :erlcloud_sqs.receive_message(queue_name(options), config)
    messages
  end

  def delete_message(message_id, options, config) do
    Logger.debug "deleting message #{message_id}"
    :erlcloud_sqs.delete_message(queue_name(options), message_id, config)
  end

  defp queue_name(options) do
    String.to_char_list "#{options[:topic]}-listener_#{options[:name]}"
  end
end
