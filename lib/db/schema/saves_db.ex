defmodule EjabberdRcp.SavesDb do
  use Ecto.Schema
  import Ecto.Changeset
  alias EjabberdRcp.Archive
  alias EjabberdRcp.Users

  schema "saves" do
    belongs_to(:archive, Archive, foreign_key: :archive_id)
    belongs_to(:users, Users, foreign_key: :user_id)
  end

  def changeset(saves, params) do
    saves
    |> cast(params, [:archive_id, :user_id])
  end
end
