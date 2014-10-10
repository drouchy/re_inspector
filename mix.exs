defmodule ReInspector.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      deps: deps
    ]
  end

  defp deps do
    [
      {:meck, github: "eproxus/meck", override: true, only: test_envs},
      {:jsx, github: "talentdeficit/jsx", override: true, only: test_envs}
    ]
  end

  defp test_envs, do: [:test, :travis]

end
