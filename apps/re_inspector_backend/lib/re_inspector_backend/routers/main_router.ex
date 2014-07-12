defmodule ReInspector.Backend.Routers.MainRouter do
  import Plug.Conn
  use Plug.Router

  plug :match
  plug :dispatch

  forward "/version", to: ReInspector.Backend.Routers.VersionRouter

  match _ do
    IO.puts "catch all from main router"
    raise NotFound
  end

end
