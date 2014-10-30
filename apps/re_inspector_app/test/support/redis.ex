defmodule ReInspector.Support.Redis do
  use Exredis

  def clear_redis(additional_list \\ nil) do
    redis_connection |> query ["DEL", redis_list]
    redis_connection |> query ["DEL", failure_list]
    redis_connection |> query ["DEL", additional_list]
    :ok
  end

  def redis_connection do
    Exredis.start(redis_options[:host], redis_options[:port])
  end

  def query(args) do
    redis_connection |> query(args)
  end

  def redis_list,   do: redis_options[:list]
  def failure_list, do: "REDIS_FAILURE_LIST"

  def redis_options do
    Application.get_env(:re_inspector_app, :listeners)[:redis] |> List.first
  end
end
