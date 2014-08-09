defmodule ReInspector.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres
  import Lager

  def conf do
    parse_url "ecto://#{login}:#{password}@#{host}/#{database}"
  end

  def priv do
    app_dir(:re_inspector_app, "priv")
  end

  def log({:query, sql}, fun) do
    {time, result} = :timer.tc(fun)
    Lager.debug "#{sql} - #{time}ms"
    result
  end

  def log(_arg, fun), do: fun.()

  defp config,   do: Application.get_env(:re_inspector_app, :database)
  defp login,    do: config[:login]
  defp password, do: config[:password]
  defp host,     do: config[:host]
  defp database, do: config[:database]
end
