defmodule Core.Verifications.TokenGeneratorBehaviour do
  @moduledoc false

  @callback generate(:email | :phone) :: binary
end
