defmodule ReInspector.Backend.Mixfile do
  use Mix.Project

  def project do
    [
      app: :re_inspector_backend,
      version: "0.0.1",
      elixir: "~> 1.0.0",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixirc_paths: src_paths(Mix.env),
      deps: deps
    ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { ReInspector.Backend, [] },
      applications: [:phoenix, :re_inspector_app, :httpoison, :logger]
    ]
  end

  defp src_paths(:travis), do: src_paths(:test)
  defp src_paths(:test),   do: ["test/support"] ++ src_paths(:default)
  defp src_paths(_),       do: ["lib", "web"]

  defp deps do
    [
      {:re_inspector_app, in_umbrella: true},
      {:cowboy, "~> 1.0.0"},
      {:phoenix, "~> 0.4.1"},
      {:plug, "~> 0.7.0"},
      {:httpoison, "~> 0.4.2"},
      {:hackney, "~> 0.13.0"},
      {:erlcloud, github: "gleber/erlcloud"},

      {:exvcr, github: "parroty/exvcr", only: test_envs},
      {:meck, github: "eproxus/meck", override: true, only: test_envs},
      {:jsx, github: "talentdeficit/jsx", override: true, only: test_envs}
    ]
  end

  defp test_envs, do: [:test, :travis]
end
