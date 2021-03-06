defmodule ReInspector.App.Workers.ErrorProcessorServiceTest do
  use ExUnit.Case
  import Mock

  import ReInspector.Support.Ecto

  alias ReInspector.Repo
  alias ReInspector.App.Services.ErrorProcessorService

  @now {{ 2013, 12, 21 }, {7, 23, 54}}

  setup do
    clean_db
    on_exit fn -> clean_db end
    :ok
  end


  #process_error/2
  test "persists an error" do
    process_error

    assert first_processing_error != nil
  end

  test "persists the message" do
    process_error

    assert first_processing_error.message == "only the nil atom is supported"
  end

  test "serializes the error" do
    process_error

    assert first_processing_error.error == "%Protocol.UndefinedError{description: \"only the nil atom is supported\", protocol: Access, value: :invalid}"
  end

  test "serializes the stack trace" do
    process_error

    assert Enum.count(first_processing_error.trace) == 2
    assert List.first(first_processing_error.trace) == "{IEx.Evaluator, :loop, 1, [file: 'lib/iex/evaluator.ex', line: 29]}"
  end

  test_with_mock "sets the error date", Chronos, [now: fn ()-> @now end] do
    process_error

    date = first_processing_error.created_at
    assert Ecto.DateTime.to_erl(date) == @now
  end

  test "supports an error without any description" do
    assert process_error != nil
  end

  #process_error/3
  test "links the error with the api_request" do
    api_request = %ReInspector.ApiRequest{} |> Repo.insert

    ErrorProcessorService.process_error(erlang_error, stacktrace, api_request.id)
    assert first_processing_error_with_api_request.api_request.get().id == api_request.id
  end

  defp process_error do
    ErrorProcessorService.process_error(erlang_error, stacktrace)
  end

  defp erlang_error, do:  %Protocol.UndefinedError{description: "only the nil atom is supported", protocol: Access, value: :invalid}
  defp stacktrace do
    [
     {IEx.Evaluator, :loop, 1, [file: 'lib/iex/evaluator.ex', line: 29]},
     {IEx.Evaluator, :start, 2, [file: 'lib/iex/evaluator.ex', line: 19]}
     ]
  end
end