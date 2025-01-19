defmodule EjabberdRcp.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :uuid, :uuid, null: false
      add :user_jid, :string
      add :room_jid, :string
    end

  end
end
