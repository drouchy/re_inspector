defmodule ReInspector.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres
  require Logger

  def conf do
    parse_url "ecto://#{login}:#{password}@#{host}/#{database}"
  end

  def priv do
    app_dir(:re_inspector_app, "priv")
  end

  def log({:query, sql}, fun) do
    {time, result} = :timer.tc(fun)
    Logger.debug fn -> "#{sql} - #{time}us" end
    send_execution_stat(ReInspector.Metrics.TransactionRegistry.current_transaction, time)
    result
  end

  def log(_arg, fun), do: fun.()

  defp config,   do: Application.get_env(:re_inspector_app, :database)
  defp login,    do: config[:login]
  defp password, do: config[:password]
  defp host,     do: config[:host]
  defp database, do: config[:database]

  defp send_execution_stat(:none, _), do: :none
  defp send_execution_stat(transaction_name, total) do
    ReInspector.Metrics.report_transaction_execution {transaction_name, {"db", "db query"}}, total
  end
end
