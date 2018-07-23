defmodule Core.Clients.Push do
  @moduledoc false

  alias Core.Clients.PushBehaviour
  alias Pigeon.APNS.Notification, as: IOSNotification
  alias Pigeon.FCM.Notification, as: AndroidNotification
  alias Pigeon.APNS, as: IOSPush
  alias Pigeon.FCM, as: AndroidPush

  @behaviour PushBehaviour

  @type notification_t :: %IOSNotification{} | %AndroidNotification{}

  @available_device_os ["ios", "android"]

  @spec send(binary, binary, binary) :: :ok
  def send(message, device_os, device_token) when device_os in @available_device_os do
    device_os = String.to_atom(device_os)
    notification = create_notification(device_os, device_token, message)

    do_send(device_os, notification)
  end

  @spec create_notification(atom, binary, binary) :: notification_t
  defp create_notification(:ios, device_token, message), do: IOSNotification.new(device_token, message)
  defp create_notification(:android, device_token, message), do: AndroidNotification.new(device_token, message)

  @spec do_send(atom, notification_t) :: :ok
  defp do_send(:ios, notification), do: IOSPush.push(notification, on_response: &on_response_ios(&1))
  defp do_send(:android, notification), do: AndroidPush.push(notification, on_response: &on_response_android(&1))

  @spec on_response_ios(notification_t) :: :ok | Log.logger_result_t()
  defp on_response_ios(%{response: :success}), do: :ok
  defp on_response_ios(err), do: Log.error("[#{__MODULE__}] Fail to send ios push: #{inspect(err)}")

  @spec on_response_android(notification_t) :: :ok | Log.logger_result_t()
  defp on_response_android(%{status: :success}), do: :ok
  defp on_response_android(err), do: Log.error("[#{__MODULE__}] Fail to send android push: #{inspect(err)}")
end
