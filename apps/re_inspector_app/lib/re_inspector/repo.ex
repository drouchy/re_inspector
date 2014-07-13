defmodule ReInspector.App.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do
    parse_url "ecto://#{login}:#{password}@#{host}/#{database}"
  end

  def priv do
    app_dir(:re_inspector_app, "priv")
  end

  defp login,    do: Application.get_env(:database, :login)
  defp password, do: Application.get_env(:database, :password)
  defp host,     do: Application.get_env(:database, :host)
  defp database, do: Application.get_env(:database, :database)
end
