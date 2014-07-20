defmodule ReInspector.User do
  use Ecto.Model

  schema "users" do
    field :login,            :string
    field :email,            :string
    field :access_token,     :string
    field :state,            :string
    field :authenticated_by, :string

    field :created_at,      :datetime
    field :updated_at,      :datetime

    field :enabled,         :boolean
    field :last_checked_at, :datetime
  end

  def obfuscate(nil), do: nil
  def obfuscate(token) do
    captured = Regex.named_captures ~r/(?<head>\w\w\w\w)(?<middle>.*)(?<tail>\w\w\w)/, token
    head   = captured["head"]
    middle = String.rjust("", String.length(captured["middle"]), ?.)
    tail   = captured["tail"]

    "#{head}#{middle}#{tail}"
  end
end