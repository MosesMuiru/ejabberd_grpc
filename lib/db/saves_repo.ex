defmodule EjabberdRcp.SavesRepo do
  alias EjabberdRcp.SavesDb
  alias EjabberdRcp.Repo
  import Ecto.Query

  def save_a_message(archive_id, user_id) do
    %SavesDb{
      archive_id: archive_id,
      user_id: user_id
    }
    |> Repo.insert()
  end

  def get_saved_message_by_user_id(user_id) do
    saves =
      SavesDb
      |> where([s], s.user_id == ^user_id)
      |> join(:left, [s], u in assoc(s, :users))
      |> join(:left, [s, a], a in assoc(s, :archive))
      |> preload([:archive, :users])
      |> Repo.all()

    Enum.map(saves, fn save ->
      List.first(EjabberdRcp.MessagesDb.extract_xml([save.archive]))
    end)
  end

  def unsave_message(save_id) do
    SavesDb
    |> where([s], s.id == ^save_id)
    |> Repo.delete_all()
  end
end
