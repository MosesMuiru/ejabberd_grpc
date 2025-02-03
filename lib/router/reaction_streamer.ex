defmodule EjabberdRcp.ReactionStreamer do
  use GenServer

  def start_link({message_id, conn}) do
    user_reactions = EjabberdRcp.ReactionsRepo.get_message_user_reaction(message_id)
    GenServer.start_link(__MODULE__, {user_reactions, conn}, name: __MODULE__)
  end

  # for sending messages to db
  def reactions_to_db(pid, reaction) do
    GenServer.cast(pid, {:reactions_to_db, reaction})
  end

  # this is for accessing message from db
  def reactions_from_db(pid, message_id) do
    GenServer.call(pid, {:reactions_from_db, message_id})
  end

  def init({reactions, conn}) do
    {:ok, %{reactions: reactions, conn: conn}}
  end

  # this will send messages to db
  def handle_cast({:reactions_to_db, user_reactions}, state) do
    {:ok, message} = EjabberdRcp.ReactionsRepo.insert_user_reactions(user_reactions)

    Phoenix.PubSub.broadcast(
      EjabberdRcp.PubSub,
      "User reacted to a message",
      {:message_created, message}
    )

    {:noreply, state}
  end

  # search messages from db
  def handle_call({:reactions_from_db, message_id}, _from, state) do
    reactions_from_db = EjabberdRcp.ReactionsRepo.get_message_user_reaction(message_id)
    {:reply, reactions_from_db, state}
  end

  def handle_info({:message_created, message}, state) do
    # Optionally, update the state with the new message11611690235489677832
    updated_state =
      Map.update!(state, :reactions, fn reactions ->
        [message | reactions]
      end)

    {:noreply, updated_state}
  end

  def handle_info(some, state) do
    IO.inspect(some, label: "Received message created event")
    {:noreply, state}
  end
end
