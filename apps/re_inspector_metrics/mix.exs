defmodule ReInspector.Metrics.Mixfile do
  use Mix.Project

  def project do
    [
      app: :re_inspector_metrics,
      version: "0.0.1",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.0.1",
      deps: deps,
      elixirc_paths: src_paths(Mix.env)
    ]
  end

  def application do
    [
      applications: [:logger, :statman],
      mod: { ReInspector.Metrics, [] }
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
      {:statman, github: "knutin/statman", override: true},
      {:lhttpc, github: "ferd/lhttpc", override: true},

      {:cowboy, "~> 1.0.0", optional: true},
      {:plug, "~> 0.8.1", optional: true},

      {:newrelic, github: "wooga/newrelic-erlang", optional: true},

      {:meck, github: "eproxus/meck", override: true, only: test_envs},
      {:mock, github: "jjh42/mock", override: true, only: test_envs},
    ]
  end

  defp test_envs, do: [:test, :travis]
end
