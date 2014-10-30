defmodule ReInspector.Metrics.PlugTest do
  use ExUnit.Case, async: false
  use Plug.Test
  use Webtest.Case
  import Mock

  alias ReInspector.Metrics.Plug.Instrumentation

  @opts Instrumentation.init([])

  # init/1
  test "returns the opts given" do
    :options = Instrumentation.init(:options)
  end

  # call/2
  test_with_mock "captures the elapsed time and send it to statman", ReInspector.Metrics,
  [ report_transaction_execution: fn(_name, total) -> assert_in_delta(total, 50000, 10000) ; :ok end] do
    with_retries 2, 100 do
      conn = Instrumentation.call(conn(:get, "/path"), @opts)
      :timer.sleep 50
      conn = send_response(conn)

      assert conn.status == 200
    end
  end

  test_with_mock "sets the requested path as the current transaction", ReInspector.Metrics,
  [ report_transaction_execution: fn(_name, _total) -> :ok end] do
    conn = Instrumentation.call(conn(:get, "/path"), @opts)
    conn = send_response(conn)

    assert ReInspector.Metrics.TransactionRegistry.current_transaction == "/path"
  end

  defp send_response(conn) do
    conn |> put_resp_content_type("text/plain")
         |> send_resp(200, "Hello world")
  end
end
