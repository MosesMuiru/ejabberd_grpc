defmodule EjabberdRcp.Users do
  use Ecto.Schema
  import Ecto.Changeset

  # Specify username as the primary key
  #  @primary_key {:username, :string, autogenerate: false}
  schema "users" do
    field(:created_at, :utc_datetime)
    has_many(:user_reactions, EjabberdRcp.UserReaction, foreign_key: :id)
    has_many(:saves, EjabberdRcp.SavesDb)
  end
end
