defmodule EjabberdRcp.Invites do

  use Ecto.Schema
  alias EjabberdRcp.Rooms
  import Ecto.Changeset

  schema "invites" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :to, :string
    field :description, :string
    field :password, :string
    field :accepted, :boolean

    # invites belong to a room

    belongs_to :rooms, Rooms
  end

  def changeset(invites, attrs) do
    invites
    |> cast(attrs, [:to, :description, :password, :accepted])
  end
end
