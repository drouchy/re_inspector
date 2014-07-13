defmodule ReInspector.App do
  use Application

  @lagger_formatter [:time, ' [', :severity, '] ', :message, '\n']
  @lager_level :debug

  def start(_type, _args) do
    configure_lager
    ReInspector.App.Supervisors.MainSupervisor.start_link
  end

  def version do
    GenServer.call(:re_inspector_config, :version)
  end

  defp configure_lager do
    :application.set_env(:lager, :handlers, [
      lager_console_backend: [@lager_level, { :lager_default_formatter, [:time, ' [', :severity, '] ', :message, '\n']}],
      lager_file_backend:    [{:file, "logs/application.log"}, {:level, :debug}]
      ], persistent: true)
    :application.set_env(:lager, :crash_log, "logs/crash.log", persistent: true)

    :application.ensure_all_started(:exlager)
  end
end
