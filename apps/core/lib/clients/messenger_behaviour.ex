defmodule Core.Clients.MessengerBehaviour do
  @moduledoc false

  @callback send(binary, binary) :: {:ok, %ExTwilio.Message{}} | {:error, binary, integer}
  @callback send(binary, binary, binary) :: {:ok, %ExTwilio.Message{}} | {:error, binary, integer}
end
