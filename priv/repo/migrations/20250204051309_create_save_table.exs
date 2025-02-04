defmodule EjabberdRcp.Repo.Migrations.CreateSaveTable do
  use Ecto.Migration

  def change do
    create table(:saves) do
      add :archive_id, references(:archive)
      add :user_id, references(:users)
    end
  end
end
