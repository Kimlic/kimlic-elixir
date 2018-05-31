defmodule Core.Verifications.TokenGenerator do
  @moduledoc false

  alias Core.Verifications.TokenGeneratorBehaviour

  @behaviour TokenGeneratorBehaviour

  @spec generate_code :: binary
  def generate_code, do: "#{Enum.random(1_000_000..9_999_999)}"
end
