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
  defp src_paths(:test),   do: ["test/support", "../re_inspector_app/test/support"] ++ src_paths(:default)
  defp src_paths(_),       do: ["lib", "web", "../re_inspector_app/test/support"]

  defp deps do
    [
      {:re_inspector_app, in_umbrella: true},
      {:cowboy, "~> 1.0.0"},
      {:phoenix, "~> 0.4.1"},
      {:plug, "~> 0.7.0"},
      {:httpoison, "~> 0.4.2"},
      {:hackney, "~> 0.13.0"},

      {:exvcr, github: "parroty/exvcr", only: test_envs},
      {:jsex, "~> 2.0.0", only: test_envs},

      {:meck, github: "eproxus/meck", override: true},
      {:jsx, github: "talentdeficit/jsx", override: true}
    ]
  end

  defp test_envs, do: [:test, :travis]
end
