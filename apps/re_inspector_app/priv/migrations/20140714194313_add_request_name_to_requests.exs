defmodule ReInspector.App.Repo.Migrations.AddRequestNameToRequests do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE api_requests add column request_name varchar(256)
    """
  end

  def down do
    """
    ALTER TABLE api_requests drop column request_name
    """
  end
end
