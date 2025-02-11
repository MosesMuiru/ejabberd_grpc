defmodule EjabberdRcp.Repo.Migrations.AlterArchiveTableToAddParentIdAndThreadId do
  use Ecto.Migration

  def change do
    alter table(:archive) do
      add :thread_id, references(:threads, on_delete: :delete_all)
      add :parent_id, references(:archive, on_delete: :delete_all)
    end

  end
end
