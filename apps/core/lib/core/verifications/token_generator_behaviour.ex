defmodule Core.Verifications.TokenGeneratorBehaviour do
  @moduledoc false

  @callback generate_email_token(binary, binary) :: binary
end
