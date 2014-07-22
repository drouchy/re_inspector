defmodule ReInspector.Repo.Migrations.AddIndexesOnApiRequestsAndCorrelations do
  use Ecto.Migration

  def up do
    """
    CREATE INDEX idx_corellations_correlations ON correlations USING gin (correlations) ;
    """
  end

  def down do
    """
    DROP INDEX idx_corellations_correlations ;
    """
  end
end
