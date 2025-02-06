import Config

config :ejabberd_rcp, EjabberdRcp.Rooms,
  database: "ejabberd_rcp_rooms",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :ejabberd_rcp, EjabberdRcp.Rooms,
  database: "ejabberd_rcp_rooms",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :ejabberd_rcp, EjabberdRcp.Rooms,
  database: "ejabberd_rcp_rooms",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :ejabberd_rcp, EjabberdRcp.Rooms,
  database: "ejabberd_rcp_rooms",
  username: "user",
  password: "pass",
  hostname: "localhost"

# Configures Elixir's Logger
config :logger, :console, format: "$time $metadata[$level] $message\n"

config :ejabberd,
  file: "config/ejabberd.yml"

config :mnesia,
  dir: "database/"

config :cors_plug,
  origin: ["*"],
  max_age: 86450,
  methods: ["GET", "POST"]

config :ejabberd_rcp, EjabberdRcp.Repo,
  database: "ejabberd",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :ejabberd_rcp,
  ecto_repos: [EjabberdRcp.Repo]

config :ejabberd_rcp, Oban, 
  repo: EjabberdRcp.Repo,
  queues: [reminders: 10],
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

# OR use a URL to connect instead
# url: "postgres://postgres:postgres@localhost/ecto_simple"
