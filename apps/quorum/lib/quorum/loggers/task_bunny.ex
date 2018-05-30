defmodule Quorum.Loggers.TaskBunny do
  @moduledoc """
  Default failure backend that reports job errors to Logger.
  """
  use TaskBunny.FailureBackend
  alias TaskBunny.JobError
  require Logger

  # Callback for FailureBackend
  def report_job_error(error = %JobError{}) do
    error
    |> JobError.get_job_error_message()
    |> do_report(error.reject)
  end

  defp do_report(message, rejected) do
    log =
      %{
        "log_type" => "application",
        "application" => "kimlic.core",
        "date_time" => iso8601(:calendar.now_to_datetime(:os.timestamp())),
        "request_id" => Logger.metadata()[:request_id],
        "message" => message
      }
      |> Jason.encode!()

    if rejected do
      Logger.error(log)
    else
      Logger.warn(log)
    end
  end

  defp iso8601({{year, month, day}, {hour, minute, second}}) do
    zero_pad(year, 4) <>
      "-" <>
      zero_pad(month, 2) <>
      "-" <>
      zero_pad(day, 2) <> "T" <> zero_pad(hour, 2) <> ":" <> zero_pad(minute, 2) <> ":" <> zero_pad(second, 2) <> "Z"
  end

  @spec zero_pad(1..3_000, non_neg_integer()) :: String.t()
  defp zero_pad(val, count) do
    num = Integer.to_string(val)
    :binary.copy("0", count - byte_size(num)) <> num
  end
end
