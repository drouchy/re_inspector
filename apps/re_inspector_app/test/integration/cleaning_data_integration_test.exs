defmodule ReInspector.Integration.CleaningDataIntegrationTest do
  use ExUnit.Case
  use Webtest.Case

  import Ecto.Query

  import ReInspector.Support.Ecto

  alias ReInspector.Repo
  alias ReInspector.ApiRequest
  alias ReInspector.Correlation
  alias ReInspector.ProcessingError

  setup do
    clean_db
    on_exit fn -> clean_db end
    :ok
  end

  test "removes the old data from database" do
    correlation_1 = %Correlation{} |> Repo.insert
    correlation_2 = %Correlation{} |> Repo.insert
    correlation_3 = %Correlation{} |> Repo.insert

    request_1 = %ApiRequest{correlation_id: correlation_1.id, requested_at: Ecto.DateTime.from_erl({Chronos.weeks_ago(10), {12,0,0}})} |> Repo.insert
    %ApiRequest{correlation_id: correlation_1.id, requested_at: Ecto.DateTime.from_erl({Chronos.weeks_ago(8), {12,0,0}})}  |> Repo.insert
    %ApiRequest{correlation_id: correlation_2.id, requested_at: Ecto.DateTime.from_erl({Chronos.weeks_ago(7), {12,0,0}})}  |> Repo.insert
    request_4 = %ApiRequest{correlation_id: correlation_3.id, requested_at: Ecto.DateTime.from_erl({Chronos.weeks_ago(3), {12,0,0}})}  |> Repo.insert

    %ProcessingError{api_request_id: request_1.id, message: "one message"} |> Repo.insert
    error_1 = %ProcessingError{api_request_id: request_4.id, message: "second message"} |> Repo.insert

    ReInspector.App.clean_old_data

    with_retries 10, 200 do
      nb_correlations = from(c in Correlation, []) |> Repo.all |> Enum.count
      assert nb_correlations < 3
    end

    correlations = from(c in Correlation, []) |> Repo.all
    requests = from(q in ApiRequest, []) |> Repo.all
    errors = from(e in ProcessingError, []) |> Repo.all

    assert Enum.count(requests) == 1
    assert List.first(requests).id == request_4.id

    assert Enum.count(errors) == 1
    assert List.first(errors).id == error_1.id

    assert Enum.count(correlations) == 1
    assert List.first(correlations).id == correlation_3.id
  end
end
