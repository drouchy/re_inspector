defmodule ReInspector.Metrics.Supervisors.NewRelicSupervisor do
  use Supervisor

  def start_link do
    configure_newrelic

    :supervisor.start_link(__MODULE__, [])
    :newrelic_poller.start_link(fn -> :newrelic_statman.poll end)
  end

  def init([]) do
    children = [
    ]

    supervise(children, strategy: :one_for_one)
  end

  defp configure_newrelic do
    config = Application.get_all_env(:metrics)
    Application.put_env(:newrelic, :application_name, config[:application_name])
    Application.put_env(:newrelic, :license_key, config[:license_key])
  end
end