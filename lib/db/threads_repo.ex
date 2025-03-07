defmodule EjabberdRcp.ThreadsRepo do
  alias EjabberdRcp.Repo
  # alias EjabberdRcp.ThreadsDb

  # add the thread get message threads
  def create_thread(thread) do
    thread
    |> Repo.insert()
  end
end
