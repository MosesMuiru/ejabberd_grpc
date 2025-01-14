defmodule EjabberdRcp.MessagesDb do
  alias EjabberdRcp.Repo
  alias EjabberdRcp.Archive
  import Ecto.Query, warn: false
  import SweetXml

  def get_all_messages() do
    Repo.all(Archive)
    |> extract_xml()
  end
  # @spec all_messages(String.t()) :: map(list)
  def get_messages_by_username(username) do
    query =
      from a in Archive,
      where: a.username == ^username

    Repo.all(query)
    |> extract_xml
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
    |> IO.inspect(label: "data")
  end
end
