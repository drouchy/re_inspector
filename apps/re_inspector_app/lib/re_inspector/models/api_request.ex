defmodule ReInspector.ApiRequest do
  use Ecto.Model

  schema "api_requests" do
    field :requested_at,  :datetime
    field :correlated_at, :datetime
    field :duration,      :integer

    field :path,             :string
    field :method,           :string
    field :request_headers,  :string
    field :request_body,     :string

    field :response_headers, :string
    field :response_body,    :string
    field :status,           :integer

    field :service_name,    :string
    field :service_version, :string
    field :service_env,     :string

    field :request_name,    :string
    field :correlator_name, :string

    field :additional_information,  {:array, :string}

    belongs_to :correlation, ReInspector.Correlation
  end

  def correlations(request) do
    case request.correlation do
      nil         -> []
      correlation -> correlation.correlations
    end
  end
end
