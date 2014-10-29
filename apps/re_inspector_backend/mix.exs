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
      compilers: [:phoenix] ++ Mix.compilers,
      deps: deps
    ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { ReInspector.Backend, [] },
      applications: [:phoenix, :re_inspector_app, :httpoison, :logger, :newrelic, :re_inspector_metrics]
    ]
  end

  defp src_paths(:travis), do: src_paths(:test)
  defp src_paths(:test),   do: ["test/support"] ++ src_paths(:default)
  defp src_paths(_),       do: ["lib", "web"]

  defp deps do
    [
      {:re_inspector_app, in_umbrella: true},
      {:re_inspector_metrics, in_umbrella: true},

      {:statman, github: "knutin/statman", override: true},
      {:newrelic, github: "wooga/newrelic-erlang", override: true},

      {:cowboy, "~> 1.0.0"},
      {:phoenix, "~> 0.5.0"},
      {:plug, "~> 0.8.0"},
      {:httpoison, "~> 0.5.0"},
      {:hackney, "~> 0.14.1"},
      {:erlcloud, github: "gleber/erlcloud"},

      {:lhttpc, github: "ferd/lhttpc", override: true},
      {:exvcr, github: "parroty/exvcr", only: test_envs},
      {:meck, github: "eproxus/meck", override: true},
      {:jsx, "~> 2.1.1", override: true}
    ]
  end

  defp test_envs, do: [:test, :travis]
end
