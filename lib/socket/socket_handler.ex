defmodule EjabberdRcp.SocketHandler do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, socket} =
      :gen_tcp.listen(5050, [:binary, packet: :line, active: false, reuseaddr: true])

    IO.puts("Messaging port at 5050")

    # Accept incoming connections asynchronously
    Task.start(fn -> accept_connection(socket) end)

    {:ok, %{socket: socket}}
  end

  defp accept_connection(socket) do
    case :gen_tcp.accept(socket) do
      {:ok, client} ->
        IO.puts("Client connected")
        Task.start(fn -> handle_client(client) end)
        # Continue accepting more connections
        accept_connection(socket)

      {:error, reason} ->
        IO.inspect(reason, label: "Failed to accept connection")
    end
  end

  defp handle_client(client) do
    IO.puts("this is working")

    case :gen_tcp.recv(client, 0) do
      {:ok, data} ->
        IO.inspect(data, label: "Received data")
        # Echo the data back to the client
        :gen_tcp.send(client, "ECHO ---<> #{data}")
        handle_client(client)

      {:error, :closed} ->
        IO.puts("Client disconnected")
        :ok

      {:error, reason} ->
        IO.inspect(reason, label: "Error receiving data")
        :ok
    end
  end
end
