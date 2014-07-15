defmodule ReInspector.Support.Fixtures do
  def fixture_file,    do: Path.expand("../../fixtures/service_1_default_request.json", __ENV__.file())

  def default_fixture do
    {:ok, content} = File.read fixture_file
    content
  end

  def default_message do
    default_fixture
    |> ReInspector.App.JsonParser.decode
    |> ReInspector.App.Converters.ApiRequestMessageConverter.to_postgres
  end
end
