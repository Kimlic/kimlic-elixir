defmodule Core.Verifications.DigitalVerifications do
  @moduledoc false

  alias Core.Clients.Redis
  alias Core.Verifications.DigitalVerification
  alias Core.Verifications.VerificationVendors

  @veriffme_client Application.get_env(:core, :dependencies)[:veriffme]

  @spec create_session(binary, map) :: {:ok, binary} | {:error, binary}
  def create_session(account_address, params) do
    with {:ok, session_id} <- create_session_on_veriffme(params),
         {:ok, _verification} <- save_verification(account_address, session_id),
         :ok <- create_contract(account_address) do
      {:ok, session_id}
    end
  end

  @spec create_session_on_veriffme(map) :: {:ok, binary} | {:error, {atom, binary}}
  defp create_session_on_veriffme(%{
         "first_name" => first_name,
         "last_name" => last_name,
         "lang" => lang,
         "timestamp" => timestamp
       }) do
    with {:ok, %{body: body, status_code: 201}} <-
           @veriffme_client.create_session(first_name, last_name, lang, timestamp),
         {:ok, %{"status" => "success", "verification" => %{"id" => session_id}}} <- Jason.decode(body) do
      {:ok, session_id}
    else
      err ->
        Log.error("[#{__MODULE__}] Veriffme session creation failed: #{inspect(err)}")
        {:error, {:getaway_timeout, "Fail to create verification session"}}
    end
  end

  @spec save_verification(binary, binary) :: {:ok, %DigitalVerification{}} | {:error, binary}
  defp save_verification(account_address, session_id) do
    changeset = DigitalVerification.changeset(%{account_address: account_address, session_id: session_id})
    ttl = Confex.fetch_env!(:core, :verifications_ttl)[:digital]

    Redis.upsert(changeset, ttl)
  end

  @spec create_contract(binary) :: :ok
  defp create_contract(_account_address) do
    # todo: call quorum
    :ok
  end

  @spec upload_media(binary, map) :: :ok | {:error, atom | binary}
  def upload_media(account_address, %{"vendor_id" => _vendor_id, "session_id" => session_id} = params) do
    with :ok <- VerificationVendors.check_context_items(params),
         :ok <- check_verification_session(account_address, session_id) do
      do_upload_media(params)
    else
      _ -> {:error, :not_found}
    end
  end

  @spec check_verification_session(binary, binary) :: :ok | {:error, atom}
  defp check_verification_session(account_address, request_session_id) do
    account_address
    |> DigitalVerification.redis_key()
    |> Redis.get()
    |> case do
      {:ok, %DigitalVerification{session_id: session_id}} when session_id == request_session_id -> :ok
      _ -> {:error, :not_found}
    end
  end

  @spec do_upload_media(map) :: :ok
  defp do_upload_media(%{"session_id" => session_id, "document_payload" => document_payload}) do
    document_payload
    |> Enum.to_list()
    |> Task.async_stream(fn {context, %{"content" => image_base64, "timestamp" => timestamp}} ->
      with {:ok, %HTTPoison.Response{body: body}} <-
             @veriffme_client.upload_media(session_id, context, image_base64, timestamp),
           {:ok, %{"status" => "success"}} <- Jason.decode(body) do
        :ok
      else
        _ -> Log.error("[#{__MODULE__}] Upload media on veriffme fail, session_id: #{session_id}, context: #{context}")
      end
    end)
    |> Stream.run()
  end

  ### Callbacks

  @spec update_contract_address(binary, term, term) :: :ok
  def update_contract_address(_account_address, _transaction_status, {:ok, _contract_address}) do
    # todo: update verification
  end
end
