defmodule EjabberdRcp.Spool do
  # offline messages

  use Ecto.Schema

  schema "spool" do
    field(:username, :string)
    field(:xml, :string)
    field(:seq, :integer)
    field(:created_at, :naive_datetime)
  end
end
