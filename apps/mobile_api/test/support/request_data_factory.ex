defmodule MobileApi.RequestDataFactory do
  @moduledoc false

  import Core.Factory

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

  @spec data_for(atom, map) :: map
  def data_for(:verification_digital_create_session, params \\ %{}) do
    %{
      "first_name" => "John",
      "last_name" => "Doe",
      "lang" => "en",
      "timestamp" => generate(:unix_timestamp)
    }
    |> Map.merge(params)
  end
end
