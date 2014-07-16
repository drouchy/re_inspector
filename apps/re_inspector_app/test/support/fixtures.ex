defmodule ReInspector.Support.Fixtures do
  def fixture_file,         do: Path.expand("../../fixtures/service_1_default_request.json", __ENV__.file())
  def second_fixture_file,  do: Path.expand("../../fixtures/service_2_default_request.json", __ENV__.file())

  def default_fixture do
    {:ok, content} = File.read fixture_file
    content
  end

  def default_message do
    default_fixture
    |> ReInspector.App.JsonParser.decode
    |> ReInspector.App.Converters.ApiRequestMessageConverter.to_postgres
  end

  def all_fixtures do
    [fixture_file, second_fixture_file]
    |> Enum.map(fn(file) -> {:ok, file} = File.read fixture_file ; file end)
    |> Enum.map(fn(content) -> ReInspector.App.JsonParser.decode content end)
    |> Enum.map(fn(json) -> ReInspector.App.Converters.ApiRequestMessageConverter.to_postgres json end)
  end
end
