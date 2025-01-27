defmodule EjabberdRcp.ReactionsRepo do

  alias EjabberdRcp.Repo

  def insert_reactions(reaction) do
    Repo.insert(reaction)
  end
end
