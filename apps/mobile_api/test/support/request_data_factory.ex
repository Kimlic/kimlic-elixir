defmodule MobileApi.RequestDataFactory do
  @moduledoc false

  import Core.Factory

  @public_key "AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSUGPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XAt3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/EnmZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbxNrRFi9wrf+M7Q=="
  @device_fingerprint %{
    "dhcp_fingerprint" => "1,33,3,6,12,15,28,51,58,59,119",
    "dhcp_vendor" => "dhcpcd-5.5.6",
    "user_agents" => ["Mozilla/5.0 (Linux; Android 5.0.2; SM-G920F Build/LRX22G; wv) AppleWebK"]
  }

  @spec data_for(atom, binary, binary) :: map
  def data_for(:auth_create_email_verification, email, account_address) do
    %{
      "source_data" => %{
        "public_key" => @public_key,
        "email" => email,
        "device_fingerprint" => @device_fingerprint
      },
      "blockchain_data" => %{
        "account_address" => account_address,
        "user_account_transaction" => %{
          "data" => "transaction_data_generated_on_mobile"
        }
      }
    }
  end

  @spec data_for(atom, binary, binary) :: map
  def data_for(:auth_create_phone_verification, account_address, phone) do
    %{
      "source_data" => %{
        "public_key" => @public_key,
        "phone" => phone,
        "device_fingerprint" => @device_fingerprint
      },
      "blockchain_data" => %{
        "account_address" => account_address,
        "user_account_transaction" => %{
          "data" => "transaction_data_generated_on_mobile"
        }
      }
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
