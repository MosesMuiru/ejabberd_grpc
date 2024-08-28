import Config
# Configures Elixir's Logger
config :logger, :console, format: "$time $metadata[$level] $message\n"

config :ejabberd,
  file: "config/ejabberd.yml"

config :mnesia,
  dir: "database/"
