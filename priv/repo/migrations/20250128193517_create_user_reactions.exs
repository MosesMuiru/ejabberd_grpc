defmodule EjabberdRcp.Repo.Migrations.CreateUserReactions do
  use Ecto.Migration

  def change do
    create table(:user_reactions) do
      add :archive_origin_id, :text, null: false
      add :username, references(:users, type: :text, column: :username, on_delete: :delete_all), null: false
      add :reactions_id, references(:reactions, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
