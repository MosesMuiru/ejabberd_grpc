-- 1. Drop the foreign key constraint in user_reactions that references users(username)
ALTER TABLE user_reactions
  DROP CONSTRAINT user_reactions_username_fkey;

-- 2. Drop the primary key constraint on users (which is currently on username)
ALTER TABLE users
  DROP CONSTRAINT users_pkey;

-- 3. Add a new auto-increment column 'id' to users.
ALTER TABLE users
  ADD COLUMN id SERIAL;

-- 4. Set the new id column as the primary key.
ALTER TABLE users
  ADD PRIMARY KEY (id);


-- 6. (Optional) If you want to update user_reactions to reference users(id) instead of username:

-- a. Add a new column to hold the foreign key (user_id) in user_reactions.
ALTER TABLE user_reactions
  ADD COLUMN user_id INTEGER;

-- b. Populate user_id using the existing username value.
UPDATE user_reactions ur
SET user_id = u.id
FROM users u
WHERE ur.username = u.username;

-- c. Create a new foreign key constraint on user_reactions to reference users(id).
ALTER TABLE user_reactions
  ADD CONSTRAINT user_reactions_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id);


