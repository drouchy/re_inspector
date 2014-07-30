defmodule ReInspector.Backend.Router do
  use Phoenix.Router

  get "/", ReInspector.Backend.Controllers.HomeController, :index, as: :root
  get "/api/version", ReInspector.Backend.Controllers.VersionController, :show
  get "/api/search", ReInspector.Backend.Controllers.SearchController, :index
end
