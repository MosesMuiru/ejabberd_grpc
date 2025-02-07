defmodule EjabberdRcp.ReminderDb do
  use Ecto.Schema
  import Ecto.Changeset
  alias EjabberdRcp.Archive
  alias EjabberdRcp.Users

  schema "reminders" do
    belongs_to(:archive, Archive, foreign_key: :archive_id)
    belongs_to(:users, Users, foreign_key: :user_id)
    field(:completed, :boolean, default: false)
    field(:schedule_date, :utc_datetime)
  end

  def changeset(reminders, params) do
    reminders
    |> cast(params, [:archive_id, :user_id, :schedule_date])
  end
end
