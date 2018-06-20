defmodule MobileApi.RequestDataFactory do
  @moduledoc false

  import Core.Factory

  @public_key "AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSUGPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XAt3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/EnmZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbxNrRFi9wrf+M7Q=="
  @device_fingerprint %{
    "dhcp_fingerprint" => "1,33,3,6,12,15,28,51,58,59,119",
    "dhcp_vendor" => "dhcpcd-5.5.6",
    "user_agents" => ["Mozilla/5.0 (Linux; Android 5.0.2; SM-G920F Build/LRX22G; wv) AppleWebK"]
  }

  @spec data_for(atom, binary | map) :: map
  def data_for(factory, params \\ %{})

  def data_for(:create_email_verification, email) do
    %{
      "source_data" => %{
        "public_key" => @public_key,
        "email" => email,
        "device_fingerprint" => @device_fingerprint
      },
      "blockchain_data" => %{
        "user_account_transaction" => %{
          "data" => "transaction_data_generated_on_mobile"
        }
      }
    }
  end

  @spec data_for(atom, binary) :: map
  def data_for(:create_phone_verification, phone) do
    %{
      "source_data" => %{
        "public_key" => @public_key,
        "phone" => phone,
        "device_fingerprint" => @device_fingerprint
      },
      "blockchain_data" => %{
        "user_account_transaction" => %{
          "data" => "transaction_data_generated_on_mobile"
        }
      }
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

  def data_for(:digital_verification_result_webhook, params) do
    %{
      "status" => "success",
      "verification" => %{
        "id" => "f04bdb47-d3be-4b28-b028-a652feb060b5",
        "status" => "approved",
        "code" => 9001,
        "acceptanceTime" => "2017-01-18T12:22:50.239Z",
        "person" => %{
          "firstName" => "TestName",
          "lastName" => "TestName",
          "idNumber" => "1234567890"
        },
        "document" => %{
          "number" => "B01234567",
          "type" => "PASSPORT",
          "validFrom" => "2015-11-11",
          "validUntil" => "2021-12-09"
        },
        "additionalVerifiedData" => %{
          "citizenship" => "FI",
          "residency" => "Melbourne"
        },
        "comment" => [
          %{
            "type" => "video_call_comment",
            "comment" => "Person is from Bangladesh",
            "timestamp" => "2016-05-19T08:30:25.597Z"
          }
        ]
      },
      "technicalData" => %{
        "ip" => "186.153.67.122"
      }
    }
    |> Map.merge(params)
  end
end
