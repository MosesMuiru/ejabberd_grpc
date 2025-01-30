defmodule EjabberdRcp.UserReaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_reactions" do
    field(:archive_origin_id, :string)
    # belongs_to :archive, EjabberdRcp.ArchiveDb, foreign_key: :archive_origin_id,
    field(:username, :string)
    belongs_to(:reactions, EjabberdRcp.Reactions, foreign_key: :reactions_id)

    timestamps()
  end

  def changeset(user_reactions, params) do
    user_reactions
    |> cast(params, [:reactions_id, :archive_origin_id, :username])
    |> validate_required([:reactions_id, :archive_origin_id, :username])
  end
end
