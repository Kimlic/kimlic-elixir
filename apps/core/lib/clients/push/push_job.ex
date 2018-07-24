defmodule Core.Clients.PushJob do
  @moduledoc false

  use TaskBunny.Job

  alias Pigeon.APNS.Notification, as: IOSNotification
  alias Pigeon.FCM.Notification, as: AndroidNotification
  alias Pigeon.APNS, as: IOSPush
  alias Pigeon.FCM, as: AndroidPush

  @type notification_t :: %IOSNotification{} | %AndroidNotification{}

  @spec perform(map) :: :ok
  def perform(%{"message" => message, "device_os" => device_os, "device_token" => device_token}) do
    device_os
    |> create_notification(device_token, message)
    |> do_send(device_os)
    |> case do
      %Pigeon.APNS.Notification{response: :success} -> :ok
      %Pigeon.FCM.Notification{status: :success} -> :ok
      _ -> :retry
    end
  end

  @spec create_notification(atom, binary, binary) :: notification_t
  defp create_notification("ios", device_token, message), do: IOSNotification.new(message, device_token)
  defp create_notification("android", device_token, message), do: AndroidNotification.new(device_token, message)

  @spec do_send(atom, notification_t) :: notification_t
  defp do_send(notification, "ios"), do: IOSPush.push(notification)
  defp do_send(notification, "android"), do: AndroidPush.push(notification)

  @spec on_reject(binary) :: :ok
  def on_reject(body) do
    Log.error(%{
      "message" => "[#{__MODULE__}] Fail to send push notification. Report #{inspect(body)}",
      "push_notification" => true
    })

    :ok
  end

  @spec max_retry :: integer
  def max_retry, do: 5

  @spec retry_interval(integer) :: integer
  def retry_interval(failed_count) do
    retry_interval_minutes = [1, 2, 5, 10, 15]

    retry_interval_minutes
    |> Enum.map(&(&1 * 1000 * 60))
    |> Enum.at(failed_count - 1)
  end
end
