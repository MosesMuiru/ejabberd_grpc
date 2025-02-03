defmodule EjabberdRcp.Reactions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reactions" do
    field(:reaction_name, :string)
    field(:reaction_code, :string)

    # belongs_to(:archive, EjabberdRcp.Archive, foreign_key: :archive_id)
    # belongs_to(:users, EjabberdRcp.Users, foreign_key: :username)

    timestamps()
  end

  def changeset(reactions, attrs) do
    reactions
    |> cast(attrs, [:reactions_name, :reactions_code])
  end
end
