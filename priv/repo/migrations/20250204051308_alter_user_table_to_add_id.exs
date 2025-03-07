defmodule MyApp.Repo.Migrations.UpdateUsersPrimaryKey do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE user_reactions DROP CONSTRAINT user_reactions_username_fkey
"

    # Step 1: Drop existing primary key
    execute "ALTER TABLE users DROP CONSTRAINT users_pkey"

    # Step 2: Add new auto-increment column 'id'
    execute "ALTER TABLE users ADD COLUMN id SERIAL"

    execute "ALTER TABLE users ADD PRIMARY KEY (id)"


    execute "ALTER TABLE user_reactions ADD COLUMN user_id INTEGER"

    execute "UPDATE user_reactions ur
SET user_id = u.id
FROM users u
WHERE ur.username = u.username"

    execute "ALTER TABLE user_reactions
  ADD CONSTRAINT user_reactions_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id)"
    end
end
