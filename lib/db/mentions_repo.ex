defmodule EjabberdRcp.MentionsRepo do

  alias EjabberdRcp.MentionsDb
  alias EjabberdRcp.Users
  alias EjabberdRcp.Repo
  import Ecto.Query

  def get_user_by_username(username) do
    Users
    |> where([u], u.username == ^username)
    |> Repo.all()
  end

  def insert_mention(mention) do
    mention
    |> Repo.insert()
  end

  def get_ids_from_username(mention_from, mention_to) do

    from = get_user_by_username(mention_from)
           |> List.first()
      
    to = get_user_by_username(mention_to)
           |> List.first()
    %{
      mention_from: from.id, 
      mention_to: to.id
    }
  end

end
