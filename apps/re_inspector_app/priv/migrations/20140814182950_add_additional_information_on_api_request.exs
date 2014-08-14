defmodule ReInspector.Repo.Migrations.AddAdditionalInformationOnApiRequest do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE api_requests ADD COLUMN additional_information text[] default '{}';
    """
  end

  def down do
    """
    ALTER TABLE api_requests DROP COLUMN additional_information ;
    """
  end
end
