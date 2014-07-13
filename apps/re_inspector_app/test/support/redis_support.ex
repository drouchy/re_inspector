defmodule ReInspector.Support.Redis do
  use Exredis

  def clear_redis do
    redis_connection |> query ["DEL", redis_list]
    redis_connection |> query ["DEL", failure_list]
    :ok
  end

  def redis_connection do
    Exredis.start(to_char_list(Application.get_env(:redis, :host)), Application.get_env(:redis, :port))
  end

  def query(args) do
    redis_connection |> query(args)
  end

  def redis_list,   do: Application.get_env(:redis, :list)
  def failure_list, do: "REDIS_FAILURE_LIST"

end
