import Config
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

# OR use a URL to connect instead
# url: "postgres://postgres:postgres@localhost/ecto_simple"
