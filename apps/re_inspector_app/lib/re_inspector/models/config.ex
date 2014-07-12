defmodule ReInspector.App.Config do
  def version do
    ReInspector.App.Mixfile.project[:version]
  end
end
