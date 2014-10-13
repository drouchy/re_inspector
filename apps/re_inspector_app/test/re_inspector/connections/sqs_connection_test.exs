defmodule ReInspector.App.Connections.SQSTest do
  use ExUnit.Case
  require Mock
  require AWS

  alias ReInspector.App.Connections.SQS

  #generate_config/1
  test "generates a aws config with the client id" do
    assert AWS.aws_config(config, :access_key_id) == 'AWS_CLIENT_ID'
  end

  test "generates a aws config with the client secret" do
    assert AWS.aws_config(config, :secret_access_key) == 'AWS_CLIENT_SECRET'
  end

  test "generates a aws config with the sqs_host" do
    assert AWS.aws_config(config, :sqs_host) == 'sqs.us-east-1.amazonaws.com'
  end

  test "generates a aws config with the sns_host" do
    assert AWS.aws_config(config, :sns_host) == 'sns.us-east-1.amazonaws.com'
  end

  #read_message/2
  # I don't know how to mock an erlang module

  defp config, do: SQS.generate_config(options)
  defp options do
    [
      name: "re_inspector_dev",
      access_client_id: "AWS_CLIENT_ID",
      access_client_secret: "AWS_CLIENT_SECRET",
      topic: "re_inspector-new_api_request-dev",
      sqs_host: "sqs.us-east-1.amazonaws.com",
      sns_host: "sns.us-east-1.amazonaws.com"
    ]
  end

end
