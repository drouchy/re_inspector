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
      deps: deps(Mix.env)
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
  defp src_paths(_),       do: ["lib", "web"]

  defp deps(:travis), do: deps(:test)
  defp deps(:test) do
    [
      { :mock, github: "jjh42/mock" },
      { :exvcr, "~> 0.2.0" }
    ] ++ deps(:default)
  end

  defp deps(_) do
    [
      {:re_inspector_app, in_umbrella: true},
      {:phoenix, github: "phoenixframework/phoenix"},
      {:cowboy, "~> 0.10.0", github: "extend/cowboy", optional: true},
      {:httpoison, "~> 0.3.0"},
      {:hackney, github: "benoitc/hackney"}
    ]
  end
end
