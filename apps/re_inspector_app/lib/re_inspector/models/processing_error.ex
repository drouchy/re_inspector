defmodule ReInspector.ProcessingError do
  use Ecto.Model

  schema "processing_errors" do
    field :message, :string
    field :created_at, :datetime
    field :error, :string
    field :trace, {:array, :string}

    belongs_to :api_request, ReInspector.ApiRequest
  end
end
