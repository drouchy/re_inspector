defmodule ReInspector.Repo.Migrations.AddProcessingErrors do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE processing_errors(
      id bigserial primary key,
      created_at  timestamp,
      message text not null,
      trace text[],

      api_request_id bigint null references api_requests(id)
    )

    """
  end

  def down do
    """
    DROP TABLE processing_errors
    """
  end
end
