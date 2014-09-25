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
      # {:postgrex, "~> 0.6.1"},
      {:decimal, "~> 0.2.5"},
      {:ecto, "~> 0.2.5"},
      {:exredis, github: "artemeff/exredis"},
      {:eredis, github: "wooga/eredis", override: true, ref: "a1cba24a8a901181044fbd1775e9cdbfa1c405d8"},
      {:jazz, "~> 0.2.1"},
      {:chronos, "~> 0.3.2"},
      {:poolboy, "~> 1.2.1", [hex_app: :poolboy]},
      {:amqp, "~> 0.0.5"},

      {:postgrex, github: "ericmj/postgrex", override: true},

      {:erlcloud, github: "gleber/erlcloud"},
      {:meck, github: "eproxus/meck", override: true},
      {:jsx, github: "talentdeficit/jsx", override: true},

      {:mock, github: "jjh42/mock", only: test_envs}
    ]
  end

  defp test_envs, do: [:test, :travis]
end
