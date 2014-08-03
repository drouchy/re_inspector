defmodule ReInspector.Backend.Mixfile do
  use Mix.Project

  def project do
    [
      app: :re_inspector_backend,
      version: "0.0.1",
      elixir: "~> 0.14.3",
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
      applications: [:phoenix, :re_inspector_app, :httpoison]
    ]
  end

  defp src_paths(:travis), do: src_paths(:test)
  defp src_paths(:test),   do: ["test/support", "../re_inspector_app/test/support"] ++ src_paths(:default)
  defp src_paths(_),       do: ["lib", "web", "../re_inspector_app/test/support"]

  defp deps do
    [
      {:re_inspector_app, in_umbrella: true},
      {:phoenix, github: "phoenixframework/phoenix"},
      {:cowboy, "~> 0.10.0", github: "extend/cowboy", optional: true},
      {:httpoison, "~> 0.3.0"},
      {:hackney, github: "benoitc/hackney"},

      {:mock, github: "jjh42/mock", only: test_envs},
      {:exvcr, "~> 0.2.0", only: test_envs},
      {:jsex, "~> 2.0.0", only: test_envs},
      {:jsx, "~> 2.0", only: test_envs}
    ]
  end

  defp test_envs, do: [:test, :travis]
end
