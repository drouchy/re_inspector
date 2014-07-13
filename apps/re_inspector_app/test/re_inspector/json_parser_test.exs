defmodule JsonParsingTest do
  use ExUnit.Case

  alias ReInspector.App.JsonParser

  # decode
  test "it decodes the message into a hash" do
    dict = JsonParser.decode regular_json

    [result] = dict[:result]

    assert dict[:a]      == 1
    assert result[:test] == "b"
  end

  test "it returns :invalid when it can not decode the json" do
    result = JsonParser.decode invalid_json

    assert result == :invalid
  end

  # encode
  test "it returns a string from a dict" do
    json = JsonParser.encode %{ a: 1, b: 2 }

    assert json == "{\"a\":1,\"b\":2}"
  end

  test "parsing & generating cancel each other" do
    result = JsonParser.decode(regular_json) |> JsonParser.encode

    assert result == regular_json
  end

  def regular_json do
    "{\"a\":1,\"result\":[{\"test\":\"b\"}]}"
  end

  def invalid_json do
    "{\"a\":1,\"result\":[\"test\":\"b\"]}"
  end
end
