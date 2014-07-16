defmodule ReInspector.Repo.Migrations.CreateApiRequets do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE api_requests(
      id bigserial primary key,
      requested_at  timestamp,
      correlated_at timestamp,
      duration      integer,

      path             text,
      method           text,
      request_headers  text,
      request_body     text,

      response_headers text,
      response_body    text,
      status           integer,

      service_name    text,
      service_version text,
      service_env     text
    )

    """
  end

  def down do
    """
    DROP TABLE api_requests
    """
  end
end
