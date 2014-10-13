defmodule ReInspector.App.Services.CleaningServiceTest do
  use ExUnit.Case

  import Ecto.Query
  import ReInspector.Support.Ecto

  alias ReInspector.App.Services.CleaningService

  setup do
    clean_db
    on_exit fn -> clean_db end
    :ok
  end

  alias ReInspector.Repo
  alias ReInspector.ApiRequest
  alias ReInspector.Correlation
  alias ReInspector.ProcessingError

  # clean_old_api_requests/1
  test "removes hte api_requests before the cut-off" do
    %ApiRequest{requested_at: %Ecto.DateTime{year: 2014, month: 8, day: 1, hour: 12, min: 38, sec: 4}} |> Repo.insert
    request_new = %ApiRequest{requested_at: %Ecto.DateTime{year: 2014, month: 8, day: 6, hour: 16, min: 58, sec: 6}} |> Repo.insert

    CleaningService.clean_old_api_requests(cut_off)

    requests = from(q in ApiRequest, []) |> Repo.all
    assert requests == [request_new]
  end

  test "deletes in cascades the processing errors" do
    request = %ApiRequest{requested_at: %Ecto.DateTime{year: 2014, month: 8, day: 1, hour: 12, min: 38, sec: 4}} |> Repo.insert
    %ProcessingError{api_request_id: request.id, message: "a message"} |> Repo.insert

    CleaningService.clean_old_api_requests(cut_off)

    nb_errors = from(e in ProcessingError, select: count(e.id)) |> Repo.one
    assert nb_errors == 0
  end

  test "deletes in cascade the correlation" do
    correlation = %Correlation{correlations: ["2","1"]} |> Repo.insert
    %ApiRequest{requested_at: %Ecto.DateTime{year: 2014, month: 8, day: 1, hour: 12, min: 38, sec: 4}, correlation_id: correlation.id} |> Repo.insert

    CleaningService.clean_old_api_requests(cut_off)

    nb_correlations = from(c in Correlation, select: count(c.id)) |> Repo.one
    assert nb_correlations == 0
  end

  test "keeps the correlations with at least one api request" do
    correlation_1 = %Correlation{correlations: ["2","1"]} |> Repo.insert
    correlation_2 = %Correlation{correlations: ["2","1"]} |> Repo.insert
    %ApiRequest{requested_at: %Ecto.DateTime{year: 2014, month: 8, day: 1, hour: 12, min: 38, sec: 4}, correlation_id: correlation_1.id} |> Repo.insert
    %ApiRequest{requested_at: %Ecto.DateTime{year: 2014, month: 8, day: 1, hour: 12, min: 38, sec: 4}, correlation_id: correlation_2.id} |> Repo.insert
    %ApiRequest{requested_at: %Ecto.DateTime{year: 2014, month: 8, day: 4, hour: 12, min: 38, sec: 4}, correlation_id: correlation_2.id} |> Repo.insert

    CleaningService.clean_old_api_requests(cut_off)

    correlations = from(c in Correlation, select: c) |> Repo.all
    assert correlations == [correlation_2]
  end

  defp cut_off, do: {2014, 8, 4}
end
