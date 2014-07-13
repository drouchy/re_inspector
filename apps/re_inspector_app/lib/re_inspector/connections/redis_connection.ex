defmodule ReInspector.App.Connections.Redis do
  import Exredis

  def client(opts) do
    start(to_char_list(opts[:host]), opts[:port])
  end

end
