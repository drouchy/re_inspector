defmodule ReInspector.Repo.Migrations.AddIndexOnRequestedAt do
  use Ecto.Migration

  def up do
    """
    CREATE INDEX idx_api_requests_requested_at ON api_requests (requested_at) ;
    """
  end

  def down do
    """
    DROP INDEX idx_api_requests_requested_at ;
    """
  end
end
