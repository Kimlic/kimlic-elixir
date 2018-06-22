defmodule AttestationApi.DigitalVerifications do
  @moduledoc false

  alias __MODULE__
  alias AttestationApi.DigitalVerifications.DigitalVerification
  alias AttestationApi.DigitalVerifications.VerificationVendors
  alias Core.Clients.Redis

  @veriffme_client Application.get_env(:core, :dependencies)[:veriffme]

  @verification_status_new DigitalVerification.status(:new)

  @verification_code_success 9001

  @spec create_session(binary, map) :: {:ok, binary} | {:error, binary}
  def create_session(account_address, params) do
    with {:ok, session_id} <- create_session_on_veriffme(params),
         {:ok, _verification} <- insert(%{account_address: account_address, session_id: session_id}),
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

  @spec create_contract(binary) :: :ok
  defp create_contract(_account_address) do
    # todo: call quorum
    :ok
  end

  @spec upload_media(binary, map) :: :ok | {:error, atom | binary}
  def upload_media(_account_address, %{"session_id" => session_id, "document_payload" => document_payload} = params) do
    with :ok <- VerificationVendors.check_context_items(params),
         {:ok, _verification} <- DigitalVerifications.get(session_id),
         :ok <- veriffme_upload_media(session_id, document_payload),
         :ok <- veriffme_close_session(session_id) do
      :ok
    else
      {:error, _} = err -> err
      _ -> {:error, :not_found}
    end
  end

  @spec veriffme_upload_media(binary, map) :: :ok | {:error, {:internal_error, binary}}
  defp veriffme_upload_media(session_id, document_payload) do
    document_payload
    |> Enum.to_list()
    |> Task.async_stream(fn {context, %{"content" => image_base64, "timestamp" => timestamp}} ->
      with {:ok, %{body: body}} <- @veriffme_client.upload_media(session_id, context, image_base64, timestamp),
           {:ok, %{"status" => "success"}} <- Jason.decode(body) do
        :ok
      end
    end)
    |> Enum.reduce_while(:ok, fn
      {:ok, :ok}, acc -> {:cont, acc}
      item, _ -> {:halt, item}
    end)
    |> case do
      :ok ->
        :ok

      err ->
        Log.error("[#{__MODULE__}] Fail to upload media on veriffme. Error: #{inspect(err)}")
        {:error, {:internal_error, "Fail to upload media on verification"}}
    end
  end

  @spec veriffme_close_session(binary) :: :ok | {:error, {:internal_error, binary}}
  defp veriffme_close_session(session_id) do
    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <- @veriffme_client.close_session(session_id),
         {:ok, %{"status" => "success", "verification" => %{"status" => "submitted"}}} <- Jason.decode(body) do
      :ok
    else
      err ->
        Log.error("[#{__MODULE__}] Fail to sumbit veriffme session. Error: #{inspect(err)}")
        {:error, {:internal_error, "Fail to close session"}}
    end
  end

  @spec update_status(map) :: :ok | {:error, atom}
  def update_status(params) do
    with {:ok, _verification} <- do_update_status(params) do
      # todo: call quorum
      :ok
    end
  end

  @spec do_update_status(map) :: :ok | {:error, atom}
  defp do_update_status(%{"verification" => %{"id" => session_id} = verification_result}) do
    with {:ok, %{status: @verification_status_new} = verification} <- DigitalVerifications.get(session_id),
         {:ok, _verification} <- Redis.update(verification, get_verification_data_from_result(verification_result)) do
      :ok
    else
      _ -> {:error, :not_found}
    end
  end

  @spec get_verification_data_from_result(map) :: map
  def get_verification_data_from_result(%{"code" => code, "status" => veriffme_status})
      when code == @verification_code_success do
    %{
      status: DigitalVerification.status(:passed),
      veriffme_code: code,
      veriffme_status: veriffme_status
    }
  end

  @spec get_verification_data_from_result(map) :: map
  def get_verification_data_from_result(verification_result) do
    %{
      status: DigitalVerification.status(:failed),
      veriffme_code: verification_result["code"],
      veriffme_status: verification_result["status"],
      veriffme_reason: verification_result["reason"],
      veriffme_comments: verification_result["comments"]
    }
  end

  ### Callbacks

  @spec update_contract_address(binary, term, term) :: :ok
  def update_contract_address(_account_address, _transaction_status, {:ok, _contract_address}) do
    # todo: update verification
  end

  ### Quering

  @spec get(binary) :: {:ok, %DigitalVerification{}} | {:error, :not_found}
  def get(session_id) when is_binary(session_id) do
    session_id
    |> DigitalVerification.redis_key()
    |> Redis.get()
  end

  @spec insert(map) :: {:ok, %DigitalVerification{}} | {:error, binary}
  defp insert(params) when is_map(params) do
    params
    |> DigitalVerification.changeset()
    |> Redis.upsert()
  end
end
