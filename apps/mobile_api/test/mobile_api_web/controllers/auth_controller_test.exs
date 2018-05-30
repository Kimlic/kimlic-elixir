defmodule MobileApi.AuthTest do
  @moduledoc false

  use MobileApi.ConnCase, async: true
  import Mox

  alias Core.Clients.Redis
  alias Core.Factory
  alias Core.StorageKeys
  alias Core.Verifications.Verification
  alias Ecto.UUID

  @entity_type_email Verification.entity_type(:email)

  describe "create profile test" do
    test "success", %{conn: conn} do
      token1 = UUID.generate()
      token2 = UUID.generate()

      expect(TokenGeneratorMock, :generate_email_token, fn "test@email.com", _address_account -> token1 end)
      expect(TokenGeneratorMock, :generate_email_token, fn "test2@email.com", _address_account -> token2 end)

      [
        {"0xd0a6e6c54dbc68db5db3a091b171a77407ff7ccf", "test@email.com", token1},
        {"0xf0a6e6c54dbc68db5db3a091b171a77407ff7ccd", "test2@email.com", token2}
      ]
      |> Enum.map(fn {account_address, email, token} ->
        assert %{status: 201} = post(conn, auth_path(conn, :create_profile), request_data(email, account_address))

        assert {:ok, %Verification{account_address: ^account_address, entity_type: @entity_type_email}} =
                 Redis.get(StorageKeys.vefirication_email(token))
      end)
    end
  end

  describe "check verification token test" do
    test "success", %{conn: conn} do
      token = UUID.generate()
      verification = Factory.verification!(%{token: token})
      Redis.set(StorageKeys.vefirication_email(token), verification)

      assert %{"status" => "ok"} =
               post(conn, auth_path(conn, :check_verification_token), %{"token" => token})
               |> json_response(200)
    end

    test "not found", %{conn: conn} do
      assert post(conn, auth_path(conn, :check_verification_token), %{"token" => UUID.generate()}) |> json_response(404)
    end
  end

  @spec request_data(binary, binary) :: map
  defp request_data(email, account_address) do
    %{
      "source_data" => %{
        "public_key" =>
          "AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSUGPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XAt3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/EnmZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbxNrRFi9wrf+M7Q==",
        "email" => email,
        "device_fingerprint" => %{
          "dhcp_fingerprint" => "1,33,3,6,12,15,28,51,58,59,119",
          "dhcp_vendor" => "dhcpcd-5.5.6",
          "user_agents" => ["Mozilla/5.0 (Linux; Android 5.0.2; SM-G920F Build/LRX22G; wv) AppleWebK"]
        }
      },
      "blockchain_data" => %{
        "account_address" => account_address,
        "user_account_transaction" => %{
          "data" => "transaction_data_generated_on_mobile"
        }
      }
    }
  end
end
