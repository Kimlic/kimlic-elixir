defmodule Core.Verifications.TokenGenerator do
  @moduledoc false

  alias Core.Verifications.TokenGeneratorBehaviour
  alias Ecto.UUID

  @behaviour TokenGeneratorBehaviour

  @spec generate_email_token(binary, binary) :: binary
  def generate_email_token(email, account_address) do
    :sha256
    |> :crypto.hash(Enum.join([UUID.generate(), email, account_address]))
    |> Base.encode16()
  end
end
