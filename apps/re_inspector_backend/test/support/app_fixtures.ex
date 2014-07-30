defmodule ReInspector.Backend.Fixtures do

  alias ReInspector.ApiRequest
  alias ReInspector.Correlation
  alias ReInspector.Repo

  def insert_fixtures do
    correlation_1 = %Correlation{correlations: ["1", "10", "3"]} |> Repo.insert
    correlation_2 = %Correlation{correlations: ["5", "2", "4"]} |> Repo.insert

    %ApiRequest{service_name: "service 1", correlation_id: correlation_1.id} |> Repo.insert
    %ApiRequest{service_name: "service 2", correlation_id: correlation_2.id} |> Repo.insert
    %ApiRequest{service_name: "service 3", correlation_id: correlation_1.id} |> Repo.insert
  end
end