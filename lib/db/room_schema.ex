defmodule EjabberdRcp.RoomSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :user_jid, :string
    field :room_jid, :string
  end

  def changeset(rooms, attrs) do
    rooms
    |> cast(attrs, [:user_jid, :room_jid])
  end
end
