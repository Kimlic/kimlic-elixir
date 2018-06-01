defmodule Core.Clients.Messenger do
  @moduledoc false

  alias Core.Clients.MessengerBehaviour
  alias ExTwilio.Message

  @behaviour MessengerBehaviour

  @spec send_message(binary, binary, binary) :: {:ok, %ExTwilio.Message{}} | {:error, binary, integer}
  def send_message(from, to, message) do
    Message.create(from: from, to: to, body: message)
  end
end
