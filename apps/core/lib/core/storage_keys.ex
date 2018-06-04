defmodule Core.StorageKeys do
  @moduledoc false

  @spec vefirication_email(binary) :: binary
  def vefirication_email(account_address), do: "verification:email:#{account_address}"

  @spec vefirication_phone(binary) :: binary
  def vefirication_phone(account_address), do: "verification:phone:#{account_address}"
end
