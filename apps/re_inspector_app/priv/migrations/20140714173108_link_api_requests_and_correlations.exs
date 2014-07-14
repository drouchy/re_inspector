defmodule ReInspector.App.Repo.Migrations.LinkApiRequestsAndCorrelations do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE api_requests add column correlation_id bigint null references correlations(id)
    """
  end

  def down do
    """
    ALTER TABLE api_requests drop column correlation_id
    """
  end
end
