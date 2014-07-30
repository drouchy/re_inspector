defmodule ReInspector.Backend.Router do
  use Phoenix.Router

  get "/", ReInspector.Backend.Controllers.HomeController, :index, as: :root
  get "/api/version", ReInspector.Backend.Controllers.VersionController, :show
end
