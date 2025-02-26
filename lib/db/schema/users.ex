defmodule EjabberdRcp.Users do
  use Ecto.Schema

  # Specify username as the primary key
  #  @primary_key {:username, :string, autogenerate: false}
  schema "users" do
    field(:username, :string)
    field(:created_at, :utc_datetime)
    has_many(:user_reactions, EjabberdRcp.UserReaction, foreign_key: :id)
  end
end
