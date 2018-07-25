defmodule Core.Push do
  @moduledoc false

  alias Core.Push.Job, as: PushJob

  @available_device_os ["ios", "android"]

  @spec enqueue(binary, binary, binary) :: :ok
  def enqueue(message, device_os, device_token) when device_os in @available_device_os do
    PushJob.enqueue!(%{"message" => message, "device_os" => device_os, "device_token" => device_token})
  end
end