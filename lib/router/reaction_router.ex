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

  get "/reactions/:message_id" do
    conn =
      conn
      |> put_resp_header("access-control-allow-origin", "*")
      |> put_resp_header("access-control-allow-methods", "GET, POST, OPTIONS")
      |> put_resp_header("content-type", "text/event-stream")
      |> put_resp_header("cache-control", "no-cache")
      |> put_resp_header("connection", "keep-alive")
      # Ensure chunked transfer encoding
      |> send_chunked(200)

    message_id = conn.params["message_id"] || "messege_id"
    message_id = String.to_atom(message_id)

    :global.register_name(message_id, self())

    data =
      EjabberdRcp.ReactionsRepo.get_message_user_reaction(conn.params["message_id"])
      |> EjabberdRcp.ReactionsRepo.user_reactions_formatter()

    {:ok, conn} = send_event(conn, data)

    sse_loop(conn, message_id)
  end

  defp send_event(conn, message) do
    case Plug.Conn.chunk(conn, "data: #{message}\n\n") do
      # Return the updated connection
      {:ok, conn} -> {:ok, conn}
      {:error, _} -> {:error, :disconnected}
    end
  end

  # This is the infinite loop that listens for incoming messages
  def sse_loop(conn, message_id) do
    receive do
      # PID<0.1354.0>
      {^message_id, data} ->
        # Send a message to the client
        {:ok, conn} = send_event(conn, data)

        sse_loop(conn, message_id)
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
