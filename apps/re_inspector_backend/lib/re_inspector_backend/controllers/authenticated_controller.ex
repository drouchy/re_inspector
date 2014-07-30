defmodule ReInspector.Backend.Controllers.AuthenticatedController do

  defmacro __using__(_opts) do
    quote do
      use Phoenix.Controller
      plug ReInspector.Backend.Plugs.AuthenticationPlug, [enabled: Application.get_env(:authentication, :enabled)]
    end
  end
end