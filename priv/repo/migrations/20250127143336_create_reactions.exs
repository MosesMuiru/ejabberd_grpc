defmodule EjabberdRcp.Repo.Migrations.CreateReactions do
  use Ecto.Migration

  def change do
    create table(:reactions) do
      add :reaction_name, :string
      add :reaction_code, :string

      timestamps()
    end

    # Add indexes for performance
    # create index(:reactions, [:archive_id])
    # create index(:reactions, [:username])
  end
end
