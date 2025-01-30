defmodule EjabberdRcp.ReactionRouter do
  use Plug.Router
  require Logger

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)
  plug(CORSPlug, origin: "*")

  get "/" do
    send_resp(conn, 200, "Hello from Cowboy")
  end

  # should a process be created when there is 
  get "/reactions/:message_id" do
    # each message will have same global 
    :global.register_name(:reaction_pid, self())

    # Set up the response for Server-Sent Events (SSE)
    conn =
      conn
      |> put_resp_header("access-control-allow-origin", "*")
      |> put_resp_header("access-control-allow-methods", "GET, POST, OPTIONS")
      |> put_resp_header("content-type", "text/event-stream")
      |> put_resp_header("cache-control", "no-cache")
      |> put_resp_header("connection", "keep-alive")
      # Ensure chunked transfer encoding
      |> send_chunked(200)

    sse_loop(conn)
  end

  defp send_event(conn, message) do
    case Plug.Conn.chunk(conn, "data: #{message}\n\n") do
      # Return the updated connection
      {:ok, conn} -> {:ok, conn}
      {:error, _} -> {:error, :disconnected}
    end
  end

  # This is the infinite loop that listens for incoming messages
  def sse_loop(conn) do
    receive do
      {:reaction_update, data} ->
        IO.inspect(data, label: "inside infinity loop")

        # Send a message to the client
        {:ok, conn} = send_event(conn, data)

        # Ensure the loop continues with the updated connection
        sse_loop(conn)
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
