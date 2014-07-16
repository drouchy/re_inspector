defmodule ReInspector.Repo.Migrations.CreateCorrelations do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE correlations(
      id bigserial primary key,
      correlations text[]
    )
    """
  end

  def down do
    """
    DROP TABLE correlations
    """
  end
end
