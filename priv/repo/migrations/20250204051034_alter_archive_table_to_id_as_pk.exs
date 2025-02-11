defmodule EjabberdRcp.Repo.Migrations.AlterArchiveTableToIdAsPk do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE archive ADD PRIMARY KEY (id)")
  end
end
