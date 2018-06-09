defmodule Log do
  @moduledoc false

  require Logger

  @type logger_result_t :: :ok | {:error, binary}

  @spec error(binary | map) :: logger_result_t
  def error(message) when is_binary(message), do: error(%{"message" => message})
  def error(%{"message" => _} = log_data), do: do_log(Map.merge(%{"log_level" => "error"}, log_data), &Logger.error/1)

  @spec warn(binary | map) :: logger_result_t
  def warn(message) when is_binary(message), do: error(%{"message" => message})
  def warn(%{"message" => _} = log_data), do: do_log(Map.merge(%{"log_level" => "warn"}, log_data), &Logger.warn/1)

  @spec info(binary | map) :: logger_result_t
  def info(message) when is_binary(message), do: info(%{"message" => message})
  def info(%{"message" => _} = log_data), do: do_log(Map.merge(%{"log_level" => "info"}, log_data), &Logger.info/1)

  @spec do_log(map, (... -> binary)) :: logger_result_t
  defp do_log(%{} = log_data, log_function) do
    log_function.(fn ->
      log_data
      |> Map.merge(%{"request_id" => Logger.metadata()[:request_id]})
      |> Jason.encode!()
    end)
  end
end
