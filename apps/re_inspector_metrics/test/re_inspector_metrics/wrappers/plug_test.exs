defmodule ReInspector.Metrics.PlugTest do
  use ExUnit.Case, async: false
  use Plug.Test
  import Mock

  alias ReInspector.Metrics.Plug.Instrumentation

  @opts Instrumentation.init([])

  # init/1
  test "returns the opts given" do
    :options = Instrumentation.init(:options)
  end

  # call/2
  test_with_mock "capture the elapsed time and send it to statman", ReInspector.Metrics,
  [ register_web_transaction: fn(_path, total) -> assert_in_delta(total, 50000, 10000) ; :ok end] do
    conn = Instrumentation.call(conn(:get, "/path"), @opts)
    :timer.sleep 50
    conn = conn |> put_resp_content_type("text/plain")
                |> send_resp(200, "Hello world")

    assert conn.status == 200
  end
end
