defmodule AttestationApi.Clients.Push do
  @moduledoc false

  @behaviour AttestationApi.Clients.PushBehaviour

  @available_device_os ["ios", "android"]

  @spec send(binary, binary, binary) :: :ok
  def send(_message, device_os, _device_token) when device_os in @available_device_os do
    # todo: send request to mobile_api
    :ok
  end
end
