defmodule ReInspector.Backend.Controllers.AuthenticatedController do
  defmacro __using__(_opts) do
    quote do
      use Phoenix.Controller
      plug ReInspector.Metrics.Plug.Instrumentation, []
      plug ReInspector.Backend.Plugs.AuthenticationPlug, [enabled: Application.get_env(:re_inspector_backend, :authentication)[:enabled]]
    end
  end
end
