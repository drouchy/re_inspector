defmodule ReInspector.RepoTest do
  use ExUnit.Case, async: false
  import Mock

  alias ReInspector.Repo
  alias ReInspector.ApiRequest

  defmodule MyQuery do
    import Ecto.Query, only: [from: 2]

    def query do
      from(q in ApiRequest, select: q) |> Repo.all
    end
  end

  setup do
    on_exit fn -> Process.put("metrics.transaction_id", nil) end
    :ok
  end

  # send execution stats
  test_with_mock "sends the execution stats in the db sub transaction", ReInspector.Metrics, [
    report_transaction_execution: fn({"/transaction", {:db, "_"}}, _) -> :ok end
  ] do
    MyQuery.query
  end

  test_with_mock "does not send any stats if there is no registered current transaction", ReInspector.Metrics, [
    report_transaction_execution: fn(nil, _) -> raise "should not have called that one" end
  ] do
    MyQuery.query
  end

end
