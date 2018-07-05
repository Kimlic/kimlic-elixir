defmodule AttestationApi.Integration.DigitalVerificationsTest do
  @moduledoc """
  Test written for manual testing.
  Before running you should change in Quorum config/test.exs :quorum, :client
  from QuorumClientMock to Ethereumex.HttpClient:

  change
    :quorum, :client: QuorumClientMock,
  to
    :quorum, :client: Ethereumex.HttpClient,

  and enable RabbitMQ workers for TaskBunny by removing [worker: false]:

  change
    [name: "transaction", jobs: [TransactionCreate], worker: false],
    [name: "transaction-status", jobs: [TransactionStatus], worker: false]
  to
    [name: "transaction", jobs: [TransactionCreate]],
    [name: "transaction-status", jobs: [TransactionStatus]]
  """

  use AttestationApi.ConnCase, async: true

  import AttestationApi.RequestDataFactory
  import Mox

  alias AttestationApi.Clients.Veriffme
  alias AttestationApi.DigitalVerifications
  alias AttestationApi.DigitalVerifications.DigitalVerification
  alias AttestationApi.DigitalVerifications.Operations.UploadMedia
  alias Ecto.UUID
  alias Quorum.Contract
  alias Quorum.Contract.Context

  @kimlic_vendor_id "87177897-2441-43af-a6bf-4860afcdd067"
  @status_new DigitalVerification.status(:new)
  @status_pending DigitalVerification.status(:pending)

  @quorum_client Application.get_env(:quorum, :client)

  setup :set_mox_global

  @tag :pending
  test "digital verification proccess passes" do
    init_mocks()
    account_address = init_quorum_user()
    verification_address = create_document_contract(account_address)
    session_id = create_session_and_upload_documents(account_address, verification_address)
    run_veriff_webhook(session_id)
    assert_contract_verified(verification_address)
  end

  @spec init_mocks :: :ok
  defp init_mocks do
    expect(VeriffmeMock, :create_session, fn _, _, _, _ ->
      {:ok,
       %HTTPoison.Response{
         status_code: 201,
         body:
           %{
             "status" => "success",
             "verification" => %{
               "id" => UUID.generate(),
               "url" => "https://magic.veriff.me/v/",
               "host" => "https://magic.veriff.me",
               "status" => "created",
               "sessionToken" => "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
             }
           }
           |> Jason.encode!()
       }}
    end)

    expect(VeriffmeMock, :upload_media, 3, fn _session_id, context, _image_base64, _unix_timestamp ->
      {:ok,
       %HTTPoison.Response{
         status_code: 200,
         body:
           %{
             "status" => "success",
             "image" => %{
               "id" => UUID.generate(),
               "name" => context
             },
             "url" => "https://api.veriff.me/v1/media/#{UUID.generate()}"
           }
           |> Jason.encode!()
       }}
    end)

    expect(VeriffmeMock, :close_session, fn session_id ->
      {:ok,
       %HTTPoison.Response{
         status_code: 200,
         body:
           %{
             "status" => "success",
             "verification" => %{
               "id" => session_id,
               "url" => "https://magic.veriff.me/v/..",
               "host" => "https://magic.veriff.me",
               "status" => "submitted"
             },
             "url" => "https://api.veriff.me/v1/media/#{UUID.generate()}"
           }
           |> Jason.encode!()
       }}
    end)

    :ok
  end

  @spec init_quorum_user :: binary
  defp init_quorum_user do
    assert {:ok, account_address} = @quorum_client.request("personal_newAccount", ["p@ssW0rd"], [])
    assert {:ok, _} = @quorum_client.request("personal_unlockAccount", [account_address, "p@ssW0rd"], [])

    transaction_data = %{
      from: account_address,
      to: Context.get_account_storage_adapter_address(),
      data:
        Contract.hash_data(:account_storage_adapter, "setAccountFieldMainData", [
          {"#{:rand.uniform()}", "documents.id_card"}
        ]),
      gas: "0x500000",
      gasPrice: "0x0"
    }

    {:ok, transaction_hash} = @quorum_client.eth_send_transaction(transaction_data, [])
    :timer.sleep(100)

    {:ok, %{"status" => "0x1"}} = @quorum_client.eth_get_transaction_receipt(transaction_hash, [])
    :timer.sleep(100)

    account_address
  end

  @spec create_document_contract(binary) :: binary
  defp create_document_contract(account_address) do
    return_key = UUID.generate()
    veriff_ap_address = Confex.fetch_env!(:quorum, :veriff_ap_address)
    relaying_party_address = Confex.fetch_env!(:quorum, :relying_party_address)
    verification_contract_factory_address = Context.get_verification_contract_factory_address()

    {:ok, _} =
      @quorum_client.request("personal_unlockAccount", [relaying_party_address, "FirstRelyingPartyp@ssw0rd"], [])

    transaction_data = %{
      from: relaying_party_address,
      to: verification_contract_factory_address,
      data:
        Contract.hash_data(:verification_factory, "createDocumentVerification", [
          {account_address, veriff_ap_address, return_key}
        ]),
      gas: "0x500000",
      gasPrice: "0x0"
    }

    {:ok, transaction_hash} = @quorum_client.eth_send_transaction(transaction_data, [])
    :timer.sleep(100)

    {:ok, %{"status" => "0x1"}} = @quorum_client.eth_get_transaction_receipt(transaction_hash, [])
    :timer.sleep(100)

    params = %{
      data: Contract.hash_data(:verification_factory, "getVerificationContract", [{return_key}]),
      to: verification_contract_factory_address
    }

    {:ok, document_verification_address} = @quorum_client.eth_call(params, "latest", [])

    Context.address64_to_40(document_verification_address)
  end

  @spec create_session_and_upload_documents(binary, binary) :: binary
  defp create_session_and_upload_documents(account_address, verification_address) do
    assert {:ok, session_id} =
             DigitalVerifications.create_session(
               account_address,
               data_for(:verification_digital_create_session, %{"contract_address" => verification_address})
             )

    assert %DigitalVerification{
             account_address: ^account_address,
             contract_address: ^verification_address,
             status: @status_new
           } = DigitalVerifications.get_by(%{session_id: session_id})

    for context <- Veriffme.contexts() do
      verification_data =
        data_for(:digital_verification_upload_media, %{
          "session_id" => session_id,
          "vendor_id" => @kimlic_vendor_id,
          "context" => context
        })

      assert :ok = UploadMedia.handle(account_address, verification_data)
    end

    assert %DigitalVerification{status: @status_pending} = DigitalVerifications.get_by(%{session_id: session_id})

    session_id
  end

  @spec run_veriff_webhook(binary) :: :ok
  defp run_veriff_webhook(session_id) do
    veriffme_decision_data =
      data_for(:digital_verification_result_webhook, %{
        "verification" => %{
          "id" => session_id,
          "status" => "approved",
          "code" => 9001
        }
      })

    assert :ok = DigitalVerifications.handle_verification_result(veriffme_decision_data)
  end

  @spec assert_contract_verified(binary) :: {:ok, binary}
  defp assert_contract_verified(contract_address) do
    :timer.sleep(100)
    data = Contract.hash_data(:base_verification, "status", [{}])

    assert {:ok, "0x0000000000000000000000000000000000000000000000000000000000000001"} =
             @quorum_client.eth_call(%{to: contract_address, data: data}, "latest", [])
  end
end