defmodule EjabberdRcp.Repo.Migrations.CreateThread do
  use Ecto.Migration

  def change do
    create table(:threads) do

      add :uuid, :uuid, null: false
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
