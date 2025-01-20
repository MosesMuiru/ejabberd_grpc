defmodule EjabberdRcp.InvitesRepo do
  alias EjabberdRcp.Invites
  alias EjabberdRcp.Repo
  import Ecto.Query

  # poc - you can have one invite with may receipient
  def insert_invite(invite) do
    invite
    |> Repo.insert()
  end

  def get_invite_by_uuid(invite_uuid) do
    query =
      from(i in Invites,
        where: i.uuid == ^invite_uuid
      )

    Repo.one(query)
  end
end
