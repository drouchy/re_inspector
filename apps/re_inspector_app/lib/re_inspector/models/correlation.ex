defmodule ReInspector.App.Correlation do
  use Ecto.Model

  schema "correlations" do
    field :correlations,  {:array, :string}
    has_many :requests, ReInspector.App.ApiRequest
  end
end
