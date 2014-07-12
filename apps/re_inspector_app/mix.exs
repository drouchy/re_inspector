defmodule ReInspector.App.Mixfile do
  use Mix.Project

  def project do
    [
      app: :re_inspector_app,
      version: "0.0.1",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 0.14.2",
      deps: deps(Mix.env)
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [],
     mod: {ReInspector.App, []}]
  end

  defp deps(:test) do
    [
      { :mock, github: "jjh42/mock" }
    ] ++ deps(:default)
  end

  defp deps(_) do
    []
  end
end
