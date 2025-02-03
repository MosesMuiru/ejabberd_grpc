defmodule EjabberdRcp.Archive do
  use Ecto.Schema
  # import Ecto.Changeset

  schema "archive" do
    field(:username, :string)
    field(:timestamp, :integer)
    field(:peer, :string)
    field(:bare_peer, :string)
    field(:xml, :string)
    field(:txt, :string)
    field(:origin_id, :string)
    field(:kind, :string)
    field(:nick, :string)
    field(:created_at, :naive_datetime)
    field(:pinned, :boolean)
    has_many(:reactions, EjabberdRcp.UserReactions)
  end

  # def changeset(archive, _params) do
  #   archive
  #   |> cast()
  # end
end
