defmodule ReInspector.Backend.Routers.VersionRouter do
  import Plug.Conn
  use Plug.Router
  use Jazz

  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response_body)
  end

  defp response_body do
    {:ok, json} = JSON.encode version
    json
  end

  defp version do
    %{
      "version" => %{
        "app" => "0.0.1",
        "backend" => "0.0.1"
      }
    }
  end

  match _ do
    raise NotFound
  end
end
