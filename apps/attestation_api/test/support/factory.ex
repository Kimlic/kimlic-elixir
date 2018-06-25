defmodule AttestationApi.Factory do
  @moduledoc false

  alias AttestationApi.DigitalVerifications.DigitalVerification
  alias AttestationApi.Repo
  alias Core.Verifications.TokenGenerator
  alias Ecto.UUID

  def insert(:digital_verification, params) do
    params
    |> digital_verification()
    |> changeset(DigitalVerification)
    |> Repo.insert()
  end

  @spec changeset(map, module) :: Ecto.Changeset.t()
  defp changeset(data, entity_module) do
    data
    |> entity_module.changeset()
    |> case do
      %{valid?: true} = changeset -> changeset
      _ -> raise "Changeset of #{entity_module} is not valid in `Core.Factory`"
    end
  end

  ### Factories

  @spec digital_verification(map) :: %DigitalVerification{}
  def digital_verification(params \\ %{}) do
    %{
      account_address: generate(:account_address),
      session_id: UUID.generate(),
      contract_address: nil,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
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
      |> :crypto.hash(TokenGenerator.generate(:email))
      |> Base.encode16(case: :lower)
      |> String.slice(0..39)

    "0x" <> account_address
  end

  @spec generate(atom) :: integer
  def generate(:unix_timestamp), do: DateTime.utc_now() |> DateTime.to_unix()
end
