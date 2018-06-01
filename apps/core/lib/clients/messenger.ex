defmodule Core.Clients.Messenger do
  @moduledoc false

  alias Core.Clients.MessengerBehaviour
  alias ExTwilio.Message

  @behaviour MessengerBehaviour

  @spec send(binary, binary, binary) :: {:ok, %ExTwilio.Message{}} | {:error, binary, integer}
  def send(to, message), do: send(message_from(), to, message)
  def send(from, to, message), do: Message.create(from: from, to: to, body: message)

  @spec message_from :: binary
  defp message_from, do: Confex.fetch_env!(:core, :messenger_message_from)
end
