defmodule ReInspector.Repo.Migrations.AddPkIndexOnCorrelationId do
  use Ecto.Migration

  def up do
    """
    CREATE INDEX idx_api_requests_correlation_id ON api_requests (correlation_id) ;
    """
  end

  def down do
    """
    DROP INDEX idx_api_requests_correlation_id ;
    """
  end
end
