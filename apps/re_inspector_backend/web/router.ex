defmodule ReInspector.Backend.Router do
  use Phoenix.Router

  get "/",            ReInspector.Backend.Controllers.HomeController,    :index, as: :root
  get "/api/version", ReInspector.Backend.Controllers.VersionController, :show
  get "/api/search",  ReInspector.Backend.Controllers.SearchController,  :index

  get "/auth/:provider/authenticate", ReInspector.Backend.Controllers.AuthenticationController, :authenticate
  get "/auth/:provider/call_back",    ReInspector.Backend.Controllers.AuthenticationController, :call_back

  use Phoenix.Router.Socket, mount: "/ws"

  channel "re_inspector", ReInspector.Backend.Channels.ReInspectorChannel
end
