defmodule EjabberdRcp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: EjabberdRcp.Worker.start_link(arg)
      # {EjabberdRcp.Worker, arg}
      {GRPC.Server.Supervisor, endpoint: EjabberdRcp.Endpoint, port: 5051, start_server: true},
      GrpcReflection,
      {Plug.Cowboy, scheme: :http, plug: EjabberdRcp.ReactionRouter, options: [port: 4041]},
      {Phoenix.PubSub, name: EjabberdRcp.PubSub},
      EjabberdRcp.SocketHandler,
      EjabberdRcp.Repo,
      {Oban, Application.fetch_env!(:ejabberd_rcp, Oban)},
      {EjabberdRcp.FileWatcher, dirs: ["ejabberd.yml"]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EjabberdRcp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def application do
    [extra_applications: [:logger], mod: {EjabberdRcp.Application, []}]
  end
end
