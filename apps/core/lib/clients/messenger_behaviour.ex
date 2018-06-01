defmodule Core.Clients.MessengerBehaviour do
  @moduledoc false

  @callback send_message(binary, binary, binary) :: {:ok, %ExTwilio.Message{}} | {:error, binary, integer}
end
