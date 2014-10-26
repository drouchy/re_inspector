defmodule ReInspector.Metrics.Mixfile do
  use Mix.Project

  def project do
    [
      app: :re_inspector_metrics,
      version: "0.0.1",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.0.1",
      deps: deps
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [:logger],
      mod: { ReInspector.Metrics, [] }
    ]
  end

  defp deps do
    [
      {:statman, github: "knutin/statman", override: true},

      {:cowboy, "~> 1.0.0", optional: true},
      {:plug, "~> 0.8.1", optional: true},

      {:newrelic, github: "wooga/newrelic-erlang", optional: true}
    ]
  end
end
