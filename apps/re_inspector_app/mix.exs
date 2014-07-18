defmodule ReInspector.App.Mixfile do
  use Mix.Project

  def project do
    [
      app: :re_inspector_app,
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
      applications: [:postgrex, :ecto],
      mod: {ReInspector.App, [] }
    ]
  end

  def src_paths(:travis) do
    src_paths(:test)
  end

  def src_paths(:test) do
    src_paths(:dev) ++ ["test/support"]
  end

  def src_paths(_) do
    ["lib"]
  end

  defp deps(:travis) do
    deps(:test)
  end

  defp deps(:test) do
    [
      { :mock, github: "jjh42/mock" }
    ] ++ deps(:default)
  end

  defp deps(_) do
    [
      {:postgrex, "~> 0.5.3"},
      {:ecto, github: "elixir-lang/ecto"},
      {:exredis, github: "artemeff/exredis"},
      {:exlager, github: "khia/exlager"},
      {:jazz, "~> 0.1.2"},
      {:chronos, github: "nurugger07/chronos" }
    ]
  end
end
