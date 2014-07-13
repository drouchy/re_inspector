defmodule ReInspector.App.Processors.RedisListener do
  import Lager

  alias ReInspector.App.Connections.Redis
  alias ReInspector.App.JsonParser

  def listen(redis_client, list) do
    Lager.debug "listening '#{list}' in redis"
    Redis.pop(redis_client, list)
    |> JsonParser.decode
  end
end
