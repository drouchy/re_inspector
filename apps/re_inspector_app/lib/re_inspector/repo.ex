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

  defp login,    do: Application.get_env(:database, :login)
  defp password, do: Application.get_env(:database, :password)
  defp host,     do: Application.get_env(:database, :host)
  defp database, do: Application.get_env(:database, :database)
end
