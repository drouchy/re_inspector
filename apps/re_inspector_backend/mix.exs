defmodule ReInspector.Backend.Mixfile do
  use Mix.Project

  def project do
    [
      app: :re_inspector_backend,
      version: "0.0.1",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 0.14.2",
      deps: deps(Mix.env),
      elixirc_paths: src_paths(Mix.env)
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [:re_inspector_app, :cowboy, :plug],
      mod: { ReInspector.Backend, [] }
    ]
  end

  def src_paths(:test) do
    src_paths(:dev) ++ ["test/support", "../re_inspector_app/support"]
  end

  def src_paths(_) do
    ["lib"]
  end

  defp deps(:test) do
    [
      { :mock, github: "jjh42/mock" },
      { :httpoison, "~> 0.3.0"},
      { :hackney, github: "benoitc/hackney" }
    ] ++ deps(:default)
  end

  defp deps(_) do
    [
      { :re_inspector_app, in_umbrella: true },
      { :plug, "~> 0.5.1" },
      { :cowboy, github: "extend/cowboy" },
      { :jazz, "~> 0.1.2"}
    ]
  end
end
