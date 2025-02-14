defmodule EjabberdRcp.Repo.Migrations.AlterMentionTableToAddMessage do
  use Ecto.Migration

  def change do
    alter table(:mentions) do

      add :message, :string
    end

  end
end
