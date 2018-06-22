defmodule MobileApi.RequestDataFactory do
  @moduledoc false

  @spec data_for(atom, binary) :: map
  def data_for(:create_email_verification, email) do
    %{
      "email" => email,
      "index" => :rand.uniform(1000)
    }
  end

  @spec data_for(atom, binary) :: map
  def data_for(:create_phone_verification, phone) do
    %{
      "phone" => phone,
      "index" => :rand.uniform(1000)
    }
  end
end
