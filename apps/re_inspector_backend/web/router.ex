defmodule ReInspector.Backend.Router do
  use Phoenix.Router
  alias ReInspector.Backend.Controllers

  scope "/" do
    pipe_through :browser

    get "/",            Controllers.HomeController,    :index, as: :root
    get "/api/version", Controllers.VersionController, :show
    get "/api/search",  Controllers.SearchController,  :index

    get "/auth/:provider/authenticate", Controllers.AuthenticationController, :authenticate
    get "/auth/:provider/call_back",    Controllers.AuthenticationController, :call_back

    get "/api/api_request/:id", Controllers.ApiRequestController, :show
  end

  use Phoenix.Router.Socket, mount: "/ws"
  channel "re_inspector", ReInspector.Backend.Channels.ReInspectorChannel
end
