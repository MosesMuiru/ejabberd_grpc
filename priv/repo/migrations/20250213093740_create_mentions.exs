defmodule EjabberdRcp.Repo.Migrations.CreateMentions do
  use Ecto.Migration

  def change do
    create table(:mentions) do

      add :uuid, :uuid, null: false
      add :user_id, references(:users, on_delete: :delete_all)
      add :mention_from, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
