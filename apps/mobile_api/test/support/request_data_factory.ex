defmodule MobileApi.RequestDataFactory do
  @moduledoc false

  import Core.Factory

  @spec data_for(atom, binary | map) :: map
  def data_for(factory, params \\ %{})

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

  def data_for(:verification_digital_create_session, params) do
    %{
      "first_name" => "John",
      "last_name" => "Doe",
      "lang" => "en",
      "timestamp" => generate(:unix_timestamp)
    }
    |> Map.merge(params)
  end

  def data_for(:digital_verification_upload_media, params) do
    %{
      "country" => "US",
      "document_type" => "ID_CARD",
      "document_payload" => %{
        "face" => %{
          "content" => "data:image/gif;base64,R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=",
          "timestamp" => generate(:unix_timestamp)
        },
        "document-front" => %{
          "content" => "data:image/gif;base64,R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=",
          "timestamp" => generate(:unix_timestamp)
        },
        "document-back" => %{
          "content" => "data:image/gif;base64,R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=",
          "timestamp" => generate(:unix_timestamp)
        }
      }
    }
    |> Map.merge(params)
  end
end
