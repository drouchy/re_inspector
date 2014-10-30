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
      {:lhttpc, github: "ferd/lhttpc", override: true}
    ]
  end
end
