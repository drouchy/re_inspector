defmodule ReInspector.App.Mixfile do
  use Mix.Project

  def project do
    [
      app: :re_inspector_app,
      version: "0.0.1",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 0.15.0",
      deps: deps,
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

  defp deps do
    [
      {:postgrex, "~> 0.5.3"},
      {:decimal, "~> 0.2.3"},
      {:ecto, github: "elixir-lang/ecto"},
      {:exredis, github: "artemeff/exredis"},
      {:jazz, "~> 0.2.0"},
      {:chronos, "~> 0.3.2"},
      {:poolboy, "~> 1.2.1", [hex_app: :poolboy]},
      {:amqp, github: "pma/amqp"},

      {:mock, github: "jjh42/mock", only: test_envs}
    ]
  end

  defp test_envs, do: [:test, :travis]
end
