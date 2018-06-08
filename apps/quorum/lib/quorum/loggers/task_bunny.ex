defmodule Quorum.Loggers.TaskBunny do
  @moduledoc """
  Default failure backend that reports job errors to Logger.
  """
  use TaskBunny.FailureBackend
  alias Log
  alias TaskBunny.JobError
  require Logger

  # Callback for FailureBackend
  def report_job_error(error = %JobError{}) do
    error
    |> get_job_error_message()
    |> do_report(error.reject)
  end

  @spec get_job_error_message(JobError.t()) :: String.t()
  def get_job_error_message(error = %JobError{error_type: :exception}) do
    """
    TaskBunny - #{error.job} failed for an exception.
    Exception:
    #{inspect(error.exception)}
    #{common_message(error)}
    Stacktrace:
    #{Exception.format_stacktrace(error.stacktrace)}
    """
  end

  def get_job_error_message(error = %JobError{error_type: :return_value}) do
    """
    TaskBunny - #{error.job} failed for an invalid return value.
    Return value:
    #{inspect(error.return_value)}
    #{common_message(error)}
    """
  end

  def get_job_error_message(error = %JobError{error_type: :exit}) do
    """
    TaskBunny - #{error.job} failed for EXIT signal.
    Reason:
    #{inspect(error.reason)}
    #{common_message(error)}
    """
  end

  def get_job_error_message(error = %JobError{error_type: :timeout}) do
    """
    TaskBunny - #{error.job} failed for timeout.
    #{common_message(error)}
    """
  end

  def get_job_error_message(error = %JobError{}) do
    """
    TaskBunny - Failed with the unknown error type.
    #{common_message(error)}
    """
  end

  defp common_message(error) do
    """
    Payload:
      #{inspect(error.payload)}
    History:
      - Failed count: #{error.failed_count}
      - Reject: #{error.reject}
    Worker:
      - Queue: #{error.queue}
      - Concurrency: #{error.concurrency}
      - PID: #{inspect(error.pid)}
    """
  end

  defp do_report(message, rejected) do
    log = %{
      "log_type" => "application",
      "application" => "kimlic.core",
      "request_id" => Logger.metadata()[:request_id],
      "message" => message
    }

    if rejected do
      Log.error(log)
    else
      Log.warn(log)
    end
  end
end
