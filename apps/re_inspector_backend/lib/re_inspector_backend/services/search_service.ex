defmodule ReInspector.Backend.Services.SearchService do
  import Lager

  def search(term, options) do
    Lager.info "searching #{inspect term} using options #{inspect options}"
    { search_results(term, options) , pagination(term, options) }
  end

  defp search_results(term, options), do: ReInspector.App.search(term, options)
  defp pagination(term, options) do
    total = ReInspector.App.count(term, options)
    limit = options["limit"]
    page  = options["page"]
    path  = options["path"]

    %{
      "total"         => total,
      "next_page"     => link_to_next_page(path, limit, page, total),
      "previous_page" => link_to_previous_page(path, limit, page)
    }
  end

  defp encode(limit, page) do
    URI.encode_query(%{"limit" => limit, "page" => page})
  end

  defp link_to_previous_page(path, limit, 0), do: nil
  defp link_to_previous_page(path, limit, page), do: "#{path}?#{encode(limit, page-1)}"

  defp link_to_next_page(path, limit, page, total) do
    case (page+2) * limit > total do
      false -> "#{path}?#{encode(limit, page+1)}"
      true  -> nil
    end
  end
end