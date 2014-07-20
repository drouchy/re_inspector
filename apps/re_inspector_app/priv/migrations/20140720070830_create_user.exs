defmodule ReInspector.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE users(
      id bigserial primary key,

      login varchar(128) not null unique,
      email varchar(128),
      access_token text not null unique,
      state varchar(128),
      authenticated_by varchar(64),

      created_at      timestamp,
      updated_at      timestamp,

      last_checked_at timestamp,
      enabled         boolean default true
    )

    """
  end

  def down do
    """
    DROP TABLE users
    """
  end
end