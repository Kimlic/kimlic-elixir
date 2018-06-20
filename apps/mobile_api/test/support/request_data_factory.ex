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
