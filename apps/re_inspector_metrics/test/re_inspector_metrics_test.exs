defmodule ReInspector.MetricsTest do
  use ExUnit.Case
  import Mock

  setup do
    metrics_enabled = Application.get_env(:metrics, :enabled)
    metrics_backend = Application.get_env(:metrics, :backend)

    on_exit fn ->
      Application.put_env(:metrics, :enabled, metrics_enabled)
      Application.put_env(:metrics, :backend, metrics_backend)
    end

    :ok
  end

  # launching the app
end
