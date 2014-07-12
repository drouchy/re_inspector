defmodule ReInspector.Backend.Router do
  import Plug.Conn
  use Plug.Router
  use Jazz

  plug :match
  plug :dispatch

  get "/version" do
    {:ok, json} = JSON.encode version

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, json)
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
