defmodule ReInspector.App do
  use Application

  @lagger_formatter [:time, ' [', :severity, '] ', :message, '\n']
  @lager_level Application.get_env(:exlager, :level)

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

  # client methods
  def process_api_request(api_request_id) do
    GenServer.cast :re_inspector_message_correlator, {:process, api_request_id}
  end

  def process_error(error, stack_trace, api_request_id \\ nil) do
    GenServer.cast(:re_inspector_error_processor, {:error_raised, error, stack_trace, api_request_id})
  end

  def process_message(message) do
    :poolboy.transaction(:message_processor_worker_pool, fn(worker) ->
      GenServer.cast(worker, {:process, message})
    end)
  end

  def search(term, options \\ %{}) do
    :poolboy.transaction(:search_worker_pool, fn(worker) ->
      GenServer.call(worker, {:search, term, options})
    end)
  end

  def count(term, options \\ %{}) do
    :poolboy.transaction(:search_worker_pool, fn(worker) ->
      GenServer.call(worker, {:count, term, options})
    end)
  end

  def clean_old_data do
    GenServer.cast(:re_inspector_data_cleaner, :clean_old_data)
  end
end
