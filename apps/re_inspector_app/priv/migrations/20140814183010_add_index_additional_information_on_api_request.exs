defmodule ReInspector.Repo.Migrations.AddIndexAdditionalInformationOnApiRequest do
  use Ecto.Migration

  def up do
    """
    CREATE INDEX idx_additional_information_api_requests ON api_requests USING gin (additional_information) ;
    """
  end

  def down do
    """
    DROP INDEX idx_additional_information_api_requests ;
    """
  end
end
