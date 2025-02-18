defmodule EjabberdRcp.MentionsDb do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mentions" do
    field(:uuid, Ecto.UUID, autogenerate: true)
    belongs_to(:users, EjabberdRcp.Users, foreign_key: :user_id)
    belongs_to(:from, EjabberdRcp.Users, foreign_key: :mention_from)
    field(:message, :string)

    timestamps()
  end
end
