defmodule AttestationApi.Factory do
  @moduledoc false

  alias AttestationApi.DigitalVerifications.DigitalVerification
  alias AttestationApi.DigitalVerifications.DigitalVerificationDocument
  alias AttestationApi.Repo
  alias Ecto.UUID

  @spec insert(atom, map) :: term | {:error, binary}
  def insert(factory, params) do
    entity = Kernel.apply(__MODULE__, factory, [params])

    changeset(entity, factory_module(factory))
    |> Repo.insert()
    |> case do
      {:ok, value} -> value
      err -> err
    end
  end

  @spec changeset(map, module) :: Ecto.Changeset.t()
  defp changeset(data, entity_module) do
    data
    |> entity_module.changeset()
    |> case do
      %{valid?: true} = changeset -> changeset
      _ -> raise "[AttestationApi.Factory] Changeset of #{entity_module} is not valid"
    end
  end

  @spec factory_module(atom) :: module
  defp factory_module(:digital_verification), do: DigitalVerification
  defp factory_module(:digital_verification_document), do: DigitalVerificationDocument

  ### Factories

  @spec digital_verification(map) :: %DigitalVerification{}
  def digital_verification(params \\ %{}) do
    %{
      account_address: generate(:account_address),
      session_id: UUID.generate(),
      contract_address: nil,
      status: DigitalVerification.status(:new),
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> Map.merge(params)
  end

  @spec digital_verification_document(map) :: %DigitalVerificationDocument{}
  def digital_verification_document(params \\ %{}) do
    %{
      verification_id: nil,
      context: Enum.random(["face", "document-front", "document-back"]),
      content: "data:image/gif;base64,R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=",
      timestamp: generate(:unix_timestamp)
    }
    |> Map.merge(params)
  end

  ### Generators

  @spec generate(atom) :: binary
  def generate(:phone), do: "+38097#{Enum.random(1_000_000..9_999_999)}"

  @spec generate(atom) :: binary
  def generate(:account_address) do
    account_address =
      :sha256
      |> :crypto.hash(to_string(:rand.uniform()))
      |> Base.encode16(case: :lower)
      |> String.slice(0..39)

    "0x" <> account_address
  end

  @spec generate(atom) :: integer
  def generate(:unix_timestamp), do: DateTime.utc_now() |> DateTime.to_unix()
end
