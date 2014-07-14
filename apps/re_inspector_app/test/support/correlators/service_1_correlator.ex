defmodule ReInspector.Test.Service1Correlator do
  @behaviour ReInspector.Correlator

  def request_name(_message), do: "service 1 request"
  def support?(message), do: message.service_name == "service 1"
  def additional_information(_message), do: %{}
  def extract_correlation(_message), do: ["123", "24C43", nil]

end
