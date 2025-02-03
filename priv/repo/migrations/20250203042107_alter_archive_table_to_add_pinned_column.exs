defmodule EjabberdRcp.Repo.Migrations.AlterArchiveTableToAddPinnedColumn do
  use Ecto.Migration

  def change do
    alter table(:archive) do
      add :pinned, :boolean
    end
  end
end
