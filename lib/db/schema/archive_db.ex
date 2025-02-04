defmodule EjabberdRcp.Archive do
  use Ecto.Schema
   import Ecto.Changeset

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
    has_many(:saves, EjabberdRcp.SavesDb)
  end

   def changeset(archive, params) do
     archive
     |> cast(params, [:username, :timestamp, :peer, :bare_peer, :xml, :txt, :origin_id, :kind, :nick, :created_at, :pinned])
   end
end
