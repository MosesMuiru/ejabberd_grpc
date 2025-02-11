defmodule EjabberdRcp.Repo.Migrations.AlterArchiveTableToIncludeUserIdAsTheForeignKey do
  use Ecto.Migration

  def change do
    # Add the new user_id column
    execute("""
      ALTER TABLE archive
      ADD COLUMN user_id INTEGER;
    """)

    # Update the user_id column based on username
    execute("""
      UPDATE archive a
      SET user_id = u.id
      FROM users u
      WHERE a.username = u.username;
    """)

    # Add foreign key constraint
    execute("""
      ALTER TABLE archive
      ADD CONSTRAINT archive_user_id_fkey
      FOREIGN KEY (user_id) REFERENCES users(id);
    """)
  end
end

