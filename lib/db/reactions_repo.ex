defmodule EjabberdRcp.ReactionsRepo do
  alias EjabberdRcp.Repo
  alias EjabberdRcp.Reactions
  alias EjabberdRcp.UserReaction
  alias EjabberdRcp.Users
  alias EjabberdRcp.Archive
  import Ecto.Query

  def insert_reactions(reaction) do
    Repo.insert(reaction)
  end

  def get_all_reactions() do
    Repo.all(Reactions)
  end

  def get_reaction_by_id(reaction_id) do
    Reactions
    |> where([r], r.id == ^reaction_id)
    |> Repo.all()
  end

  # a user has reacted with a smile face
  # create a join table between reactin id and reaction
  # then join the username
  def react_to_a_message(reaction) do
    reaction
    |> Repo.insert()
  end

  def get_user_reactions() do
    EjabberdRcp.UserReaction
    |> Repo.all()
  end

  def insert_user_reactions(user_reaction) do
    user_reaction
    |> Repo.insert()
    |> case do
      {:ok, reaction} ->
        # a list of reactions but  is hould broadcast the emoji, origin_id, inserted_at
        user_reactions =
          get_message_user_reaction(reaction.archive_origin_id)
          |> user_reactions_formatter()

        message_id = String.to_atom(reaction.archive_origin_id)
        pid = :global.whereis_name(String.to_atom(reaction.archive_origin_id))

        #  remember to handle when the pid is not registered || the client is offlinet
        send(pid, {message_id, user_reactions})
    end
  end

  def send do
    send(self(), {:"1", "waaah"})
  end

  def user_reactions_formatter(user_reaction) do
    user_reaction
    |> Enum.map(fn data ->
      %{
        id: data.id,
        message_id: data.archive_origin_id,
        username: data.username,
        reactions_id: data.reactions.id,
        reaction_name: data.reactions.reaction_name,
        reaction_code: data.reactions.reaction_code,
        reacted_at: data.inserted_at
      }
    end)
    |> Jason.encode!()
  end

  # create a process when a reacts to a message
  # the role of these process is to fetch data

  # get message reactions, message_id, this is the data i will send through the api
  def get_message_user_reaction(message_id) do
    UserReaction
    |> where([u], u.archive_origin_id == ^message_id)
    |> join(:left, [u], r in Reactions, on: u.reactions_id == r.id)
    |> Repo.all()
    |> Repo.preload(:reactions)
  end

  # get reaction of the message and who reacted to the message
  # get reaction by the message id, and username --->
  def get_message_reaction(message_id) do
    UserReaction
    |> join(:left, [u], r in Reactions, on: u.reactions_id == r.id)
    |> where([u, r], u.archive_origin_id == ^message_id)
    |> Repo.all()
  end
end
