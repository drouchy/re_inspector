defmodule ReInspector.Metrics.Instrumentation do
  defmacro instrument(transaction_name, code) do
    quote do
      start_time = :erlang.now
      result = unquote(code)
      elapsed_time = :timer.now_diff :erlang.now, start_time
      ReInspector.Metrics.report_transaction_execution(unquote(transaction_name), elapsed_time)
      result
    end
  end
end
