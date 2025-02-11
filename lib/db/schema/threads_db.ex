defmodule EjabberdRcp.ThreadsDb do
  use Ecto.Schema

  alias EjabberdRcp.Archive
  import Ecto.Changeset

  schema "threads" do
    field(:uuid, Ecto.UUID, autogenerate: true)
    belongs_to(:users, EjabberdRcp.Users, foreign_key: :user_id)
  end

  def changeset(threads, attrs) do
    threads
    |> cast(attrs, [:archive_id])
  end
end
