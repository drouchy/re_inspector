defmodule ReInspector.Metrics.InstrumentationTest do
  use ExUnit.Case, async: false
  import Mock

  import ReInspector.Metrics.Instrumentation

  defmodule MyModule do
    def the_method do
      "result"
    end
  end

  test "returns the result of the instrumented code" do
    "result" = instrument {:foo, :bar}, MyModule.the_method
  end

  test_with_mock "sends the execution time to the stats worker", ReInspector.Metrics,
  [
    report_transaction_execution: fn({:foo,:bar}, total) -> assert_in_delta(total, 10000, 10000) ; :ok end
  ] do
    instrument {:foo, :bar}, MyModule.the_method
  end
end
