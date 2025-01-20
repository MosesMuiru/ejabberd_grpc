defmodule EjabberdRcp.RoomsRepo do
  alias EjabberdRcp.RoomSchema
  alias EjabberdRcp.Repo
  import Ecto.Query

  # insert the when the room is created it is inserted and  rooms

  @spec insert_room(Ecto.RoomSchema.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def insert_room(room) do
    Repo.insert(room)
  end

  def get_rooms_by_user_jid(user_jid) do
    query =
      from(r in RoomSchema,
        where: r.user_jid == ^user_jid
      )

    Repo.all(query)
  end

  def get_room_by_id(room_id) do
    RoomSchema
    |> where([r], r.id == ^room_id)
    |> Repo.one()
  end
end
