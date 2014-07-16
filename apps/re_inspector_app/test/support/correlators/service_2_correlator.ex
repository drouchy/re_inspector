defmodule ReInspector.Test.Service2Correlator do
  @behaviour ReInspector.Correlator

  def request_name(_message), do: "service 2 request"
  def support?(message), do: message.service_name == "service 2"
  def additional_information(_message), do: %{}
  def extract_correlation(_message), do: ["123", nil, nil]
  def obfuscate(message), do: message

end
