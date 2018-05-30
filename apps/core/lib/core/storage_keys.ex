defmodule Core.StorageKeys do
  @moduledoc false

  @spec vefirication_email(binary) :: binary
  def vefirication_email(token), do: "verification:email:#{token}"

  @spec vefirication_phone(binary) :: binary
  def vefirication_phone(token), do: "verification:phone:#{token}"
end
