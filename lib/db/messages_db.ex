defmodule EjabberdRcp.MessagesDb do
  alias EjabberdRcp.Repo
  alias EjabberdRcp.Archive
  alias EjabberdRcp.Spool
  import Ecto.Query, warn: false
  import SweetXml
  import Ecto.Query

  def get_all_messages() do
    Repo.all(Archive)
    |> extract_xml()
  end

  # @spec all_messages(String.t()) :: map(list)
  def get_messages_by_username(username) do
    Archive
    |> where(username: ^username)
    |> Repo.all()
    |> Repo.preload(:user_reactions)
    |> extract_xml()
  end

  # get offline messages

  def get_offline_messages_by_username(username) do
    Spool
    |> where([s], s.username == ^username)
    |> select([s], %{username: s.username, xml: s.xml, seq: s.seq, created_at: s.created_at})
    |> Repo.all()
    |> extra_xml()
  end

  def get_offline_messages() do
    Spool
    |> select([s], %{username: s.username, xml: s.xml, seq: s.seq, created_at: s.created_at})
    |> Repo.all()
    |> extract_xml()
  end

  def extra_xml(messages) do
    messages
    |> Enum.map(fn x ->
      parsed_data =
        x.xml
        |> SweetXml.parse()

      # IO.inspect(xpath(parsed_data, ~x"//messages/body"))
      IO.inspect(xpath(parsed_data, ~x"//message//body/text()"), label: "xml -->")

      %{
        to: to_string(xpath(parsed_data, ~x"//message/@to")),
        from: to_string(xpath(parsed_data, ~x"//message/@from")),
        txt: xpath(parsed_data, ~x"//message//body/text()"),
        created_at: x.created_at,
        seq: x.seq
      }
    end)
  end

  # extracting the data from xml to a vid
  def extract_xml(data) do
    data
    |> Enum.map(fn x ->
      parsed_data =
        x.xml
        |> SweetXml.parse()

      %{
        id: x.id,
        username: x.username,
        timestamp: x.timestamp,
        peer: x.peer,
        bare_peer: x.bare_peer,
        txt: x.txt,
        origin_id: x.origin_id,
        kind: x.kind,
        nick: x.nick,
        created_at: x.created_at,
        to: to_string(xpath(parsed_data, ~x"//message/@to")),
        from: to_string(xpath(parsed_data, ~x"//message/@from")),
        xml: x.xml
      }
    end)
  end

  # search the message by id and eddit the the
  def get_and_update_message_by_id_and_reaction_id(reaction_id, message_id) do
    Archive
    |> where([a], a.origin_id == ^message_id)
    |> update([a], set: [reaction_id: ^reaction_id])
    |> Repo.update_all([])
  end

  def get_message_id_by_origin_and_username(origin_id, username) do
    Archive
    |> where([a], a.origin_id == ^origin_id and a.username == ^username)
    |> Repo.all()
  end

  # a user can react to a message
  # who reacted to the message, and the message id of the message
  # get the details of the message that the user reacted to

  # what if i just get the reaction of the message, and who reacted to the
end
