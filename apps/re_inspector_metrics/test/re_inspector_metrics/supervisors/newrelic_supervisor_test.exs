defmodule ReInspector.Metrics.Supervisors.NewRelicSupervisorTest do
  use ExUnit.Case

  test "the supervisor configures the new relic application name" do
    assert Application.get_env(:newrelic, :application_name) == "re_inspector_metrics_app"
  end

  test "the supervisor configures the new relic license key" do
    assert Application.get_env(:newrelic, :license_key) == "newrelic-license-key"
  end
end