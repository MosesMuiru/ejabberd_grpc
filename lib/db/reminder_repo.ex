defmodule EjabberdRcp.ReminderRepo do
  alias EjabberdRcp.ReminderDb
  import Ecto.Query
  alias EjabberdRcp.Repo
  alias EjabberdRcp.Users
  alias EjabberdRcp.Archive

  # create a reminder
  #
  def create_reminder(reminder) do
    reminder
    |> Repo.insert()
    |> case do
      {:ok, reminder} ->
        reminder
        |> create_oban_worker()
    end
  end

  def create_oban_worker(
        %{user_id: user_id, archive_id: archive_id, schedule_date: schedule_date} = reminder
      ) do
    %{
      user_id: user_id,
      archive_id: archive_id,
      schedule_date: schedule_date,
      reminder_id: reminder.id
    }
    |> EjabberdRcp.ReminderWorker.new(scheduled_at: schedule_date)
    |> Oban.insert()
  end

  def fetch_reminder_by_user_id(user_id) do
    ReminderDb
    |> where([r], r.user_id == ^user_id)
    |> join(:left, [r], u in Users, on: r.user_id == u.id)
    |> join(:left, [r, u], a in Archive, on: r.archive_id == a.id)
    |> Repo.all()
    |> Repo.preload(:archive)
    |> Enum.map(fn reminder ->
      %{
        id: reminder.id,
        completed: reminder.completed,
        schedule_date: reminder.schedule_date,
        message: List.first(EjabberdRcp.MessagesDb.extract_xml([reminder.archive]))
      }
    end)
  end
end
