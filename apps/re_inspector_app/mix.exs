defmodule ReInspector.App.Mixfile do
  use Mix.Project

  def project do
    [
      app: :re_inspector_app,
      version: "0.0.1",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.0.0",
      deps: deps,
      elixirc_paths: src_paths(Mix.env)
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [:postgrex, :ecto, :erlcloud, :logger],
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
      {:postgrex, "~> 0.6.0"},
      {:decimal, "~> 0.2.5"},
      {:ecto, "~> 0.2.5"},
      {:exredis, github: "artemeff/exredis"},
      {:jazz, "~> 0.2.1"},
      {:chronos, "~> 0.3.2"},
      {:poolboy, "~> 1.2.1", [hex_app: :poolboy]},
      {:amqp, "~> 0.0.5"},

      {:erlcloud, github: "gleber/erlcloud"},
      {:meck, github: "eproxus/meck", override: true},
      {:jsx, github: "talentdeficit/jsx", override: true},

      {:mock, github: "jjh42/mock", only: test_envs}
    ]
  end

  defp test_envs, do: [:test, :travis]
end
