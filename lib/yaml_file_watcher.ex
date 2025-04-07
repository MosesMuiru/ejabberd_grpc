defmodule EjabberdRcp.FileWatcher do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    {:ok, watcher_pid} = FileSystem.start_link(args)
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  # any changes that happen to the ejabberd config file 
  # Reload the config file

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid} = state) do
    :ejabberd_config.reload()
    |> case do
      :ok -> IO.inspect(label: "New org domain added, Reloaded")
      :error -> IO.inspect(label: "Could not reload")
    end
    # Your own logic for path and events
    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    # Your own logic when monitor stop
    {:noreply, state}
  end
end
