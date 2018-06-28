defmodule AttestationApi.DigitalVerifications do
  @moduledoc false

  import Ecto.Query, except: [update: 2]

  alias __MODULE__
  alias AttestationApi.DigitalVerifications.DigitalVerification
  alias AttestationApi.DigitalVerifications.DigitalVerificationDocument
  alias AttestationApi.Repo

  @veriffme_client Application.get_env(:attestation_api, :dependencies)[:veriffme]

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

  @spec handle_verification_result(map) :: :ok | {:error, atom}
  def handle_verification_result(params) do
    with {:ok, verification} <- update_status(params),
         {_deleted_count, nil} <- remove_verification_documents(verification) do
      # todo: call quorum
      :ok
    end
  end

  @spec update_status(map) :: :ok | {:error, atom}
  defp update_status(%{"verification" => %{"id" => session_id} = verification_result}) do
    with %{status: @verification_status_new} = verification <- DigitalVerifications.get_by(%{session_id: session_id}),
         {:ok, verification} <- update(verification, get_verification_data_from_result(verification_result)) do
      {:ok, verification}
    else
      _ -> {:error, :not_found}
    end
  end

  @spec remove_verification_documents(%DigitalVerification{}) :: {integer, nil} | {:error, binary}
  defp remove_verification_documents(%DigitalVerification{id: verification_id}) do
    DigitalVerificationDocument
    |> where([dv_d], dv_d.verification_id == ^verification_id)
    |> Repo.delete_all()
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

  @spec get_by(map) :: %DigitalVerification{} | nil
  def get_by(params), do: Repo.get_by(DigitalVerification, params)

  @spec insert(map) :: {:ok, %DigitalVerification{}} | {:error, binary}
  def insert(params) when is_map(params) do
    params
    |> DigitalVerification.changeset()
    |> Repo.insert()
  end

  @spec update(%DigitalVerification{}, map) :: {:ok, %DigitalVerification{}} | {:error, binary}
  def update(%DigitalVerification{} = entity, params) do
    entity
    |> DigitalVerification.changeset(params)
    |> Repo.update()
  end
end
