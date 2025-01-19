defmodule EjabberdRcp.Repo.Migrations.CreateInvites do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :uuid, :uuid
      add :to, :string
      add :description, :string
      add :password, :string
      add :accepted, :boolean

      add :rooms_id, references(:rooms, on_delete: :delete_all)
    end

  end
end
