defmodule EjabberdRcp.Repo.Migrations.AlterReminderTableToAddCompleteColumn do
  use Ecto.Migration

  def change do
    alter table(:reminders) do
      add :completed, :boolean
    end
  end
end
