defmodule ReInspector.Backend.Services.SearchService do
  import Lager

  def search(term, options) do
    Lager.info "searching #{inspect term} using options #{inspect options}"
    ReInspector.App.search(term, options)
  end

end