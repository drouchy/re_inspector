defmodule ReInspector.Metrics.Instrumentation do
  defmacro instrument(transaction_name, code) do
    quote do
      ReInspector.Metrics.TransactionRegistry.current_transaction(unquote(transaction_name))
      start_time = :erlang.now
      result = unquote(code)
      elapsed_time = :timer.now_diff :erlang.now, start_time
      ReInspector.Metrics.report_transaction_execution(unquote(transaction_name), elapsed_time)
      ReInspector.Metrics.TransactionRegistry.current_transaction(nil)
      result
    end
  end
end
