defmodule EjabberdRcp.Archive do

  use Ecto.Schema

  schema "archive" do
    field :username, :string
    field :timestamp, :integer
    field :peer, :string
    field :bare_peer, :string
    field :xml, :string
    field :txt, :string
    field :origin_id, :string
    field :kind, :string
    field :nick, :string
    field :created_at, :naive_datetime
  end

end
