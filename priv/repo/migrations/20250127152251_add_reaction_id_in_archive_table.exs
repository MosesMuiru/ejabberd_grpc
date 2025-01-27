defmodule EjabberdRcp.Repo.Migrations.AddReactionIdInArchiveTable do
  use Ecto.Migration

  def change do
    alter table(:archive) do
      add :reaction_id, references(:reactions, on_delete: :delete_all)
    end

    create index(:archive, :reaction_id)
  end
end
