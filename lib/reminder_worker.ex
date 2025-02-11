defmodule EjabberdRcp.ReminderWorker do
  use Oban.Worker, queue: :reminders

  alias EjabberdRcp.ReminderRepo
  # worker used to perform the tasks
  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{
          "archive_id" => archive_id,
          "schedule_date" => schedule_date,
          "user_id" => user_id,
          "reminder_id" => reminder_id
        }
      }) do
    with {:ok, reminder} <- ReminderRepo.fetch_reminder_by_user_id(user_id) do
      reminder
    end
  end
end
