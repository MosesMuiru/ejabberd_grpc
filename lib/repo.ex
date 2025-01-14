defmodule EjabberdRcp.Repo do
  use Ecto.Repo,
    otp_app: :ejabberd_rcp,
    adapter: Ecto.Adapters.Postgres
end
