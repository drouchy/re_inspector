defmodule ReInspector.App.Services.MessageCorrelationService do
  import Lager

  def launch_correlation(message) do
    Lager.info "launching correlation for message #{inspect message}"
  end
end
