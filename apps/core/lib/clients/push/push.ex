defmodule Core.Clients.Push do
  @moduledoc false

  alias Core.Clients.PushBehaviour
  alias Core.Clients.PushJob

  @behaviour PushBehaviour

  @available_device_os ["ios", "android"]

  @spec send(binary, binary, binary) :: :ok
  def send(message, device_os, device_token) when device_os in @available_device_os do
    PushJob.enqueue!(%{"message" => message, "device_os" => device_os, "device_token" => device_token})
  end
end
