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
      {:meck, github: "eproxus/meck", override: true},
      {:jsx, github: "talentdeficit/jsx", override: true}
    ]
  end
end
