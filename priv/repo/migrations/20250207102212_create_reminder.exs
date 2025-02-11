defmodule EjabberdRcp.Repo.Migrations.CreateReminder do
  use Ecto.Migration

  def change do
    create table(:reminders) do
      add :archive_id, references(:archive)
      add :user_id, references(:users)
      add :schedule_date, :utc_datetime, null: false
    end

  end
end
