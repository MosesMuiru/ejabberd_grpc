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

  # message action 
  def pin_message(message_id, username, pin) do
    Archive
    |> where([a], a.username == ^username and a.origin_id == ^message_id)
    |> update(set: [pinned: ^pin])
    |> Repo.update_all([])
  end

  def delete_message_by_id(message_id) do
    Archive
    |> where([a], a.id == ^message_id)
    |> Repo.delete_all()
  end

  def search_in_messages(user_id, sender_id, search_for) do
    search_for = "%#{search_for}%"
                 |> IO.inspect(label: "search for")
    Archive
    |> where([a], a.user_id == ^user_id or a.user_id == ^sender_id)
    |> where([a], ilike(a.txt, ^search_for))
    |> Repo.all()
    |> extract_xml()
  end

  def convert_to_stanza do
    stanza = "<message from='moses@localhost' to='kamau@localhost' type='chat' id='28gs'>
  <body> this title of the forwarded message</body>
  <forwarded xmlns='urn:xmpp:forward:0'>
    <delay xmlns='urn:xmpp:delay' stamp='2010-07-10T23:08:25Z'/>
    <message from='kamau@localhost'
             id='0202197'
             to='moses@localhost'
             type='chat'
             xmlns='jabber:client'>
      <body>this is the message being forward</body>
      <mood xmlns='http://jabber.org/protocol/mood'>
        <amorous/>
      </mood>
    </message>
  </forwarded>
           </message>"

    h = :fxml_stream.parse_element(stanza)

    :mod_admin_extra.send_stanza("moses@localhost", "kamau@localhost", stanza)
    |> IO.inspect(label: "we----")
  end
end
