defmodule ReInspector.Test.Service2Correlator do
  @behaviour ReInspector.Correlator

  def request_name(_message), do: "service 1 request"
  def support?(_message), do: false
  def additional_information(_message), do: %{}
  def extract_correlation(_message), do: [nil, "2", "3"]

end
