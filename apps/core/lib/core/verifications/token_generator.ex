defmodule Core.Verifications.TokenGenerator do
  @moduledoc false

  @spec generate(:email | :phone) :: binary
  def generate(:phone), do: "#{Enum.random(100_000..999_999)}"
  def generate(:email), do: "#{Enum.random(100_000..999_999)}"
end
