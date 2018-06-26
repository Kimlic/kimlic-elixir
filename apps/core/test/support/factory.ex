defmodule Core.Factory do
  @moduledoc false

  alias Core.Clients.Redis
  alias Core.Verifications.TokenGenerator
  alias Core.Verifications.Verification

  @spec build(atom, map) :: %Verification{} | term
  def build(entity_atom, params \\ %{}), do: :erlang.apply(__MODULE__, entity_atom, [params])

  @spec insert(atom, map) :: {:ok, term} | {:error, binary}
  def insert(atom, params \\ %{})

  def insert(:verification, params) do
    params
    |> verification()
    |> changeset(Verification)
    |> redis_insert()
  end

  @spec redis_insert(Ecto.Changeset.t()) :: term
  defp redis_insert(changeset) do
    with {:ok, entity} <- Redis.upsert(changeset) do
      entity
    else
      _ -> raise "[Core.Factory]: Can't set data in redis"
    end
  end

  ### Factories

  @spec verification(map) :: %Verification{}
  def verification(params \\ %{}) do
    %{
      entity_type: Verification.entity_type(:email),
      account_address: generate(:account_address),
      token: "123456",
      contract_address: generate(:account_address),
      status: Verification.status(:new)
    }
    |> Map.merge(params)
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

  @spec generate(atom) :: binary
  def generate(:unix_timestamp), do: DateTime.utc_now() |> DateTime.to_unix()
end
