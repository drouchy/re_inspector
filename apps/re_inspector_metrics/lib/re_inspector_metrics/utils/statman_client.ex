defmodule ReInspector.Metrics.Statman do
  import Logger

  def histogram(key, value) do
    Logger.debug "statman histogram counter #{inspect key}: #{value}"
     :statman_histogram.record_value(key, value)
  end

end