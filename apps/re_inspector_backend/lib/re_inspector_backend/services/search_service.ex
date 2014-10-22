defmodule ReInspector.Backend.Services.SearchService do
  require Logger

  def search(term, options) do
    Logger.info "searching #{inspect term} using options #{inspect options}"
    { search_results(term, options) , pagination(term, options) }
  end

  defp search_results(term, options), do: ReInspector.App.search(term, options)

  defp pagination(term, %{"limit" => "no_limit"}) do
    %{
      "total"         => ReInspector.App.count(term, %{})
    }
  end
  defp pagination(term, options) do
    total = ReInspector.App.count(term, options)
    limit = options["limit"]
    page  = options["page"]
    path  = options["path"]

    %{
      "total"         => total,
      "current_page"  => "#{path}?#{encode(term, limit, page)}",
      "next_page"     => link_to_next_page(term, path, limit, page, total),
      "previous_page" => link_to_previous_page(term, path, limit, page),
      "all_results"   => "#{path}?#{encode_no_limit(term)}"
    }
  end

  defp encode(term, limit, page) do
    URI.encode_query(%{"limit" => limit, "page" => page, "q" => term})
  end

  defp encode_no_limit(term) do
    URI.encode_query(%{"limit" => :no_limit, "q" => term})
  end

  defp link_to_previous_page(_term, _path, _limit, 0), do: nil
  defp link_to_previous_page(term, path, limit, page), do: "#{path}?#{encode(term, limit, page-1)}"

  defp link_to_next_page(term, path, limit, page, total) do
    case (page+1) * limit > total do
      false -> "#{path}?#{encode(term, limit, page+1)}"
      true  -> nil
    end
  end
end