defmodule Core.Factory do
  @moduledoc false

  alias Core.Clients.Redis
  alias Core.Verifications.{TokenGenerator, Verification}
  alias Ecto.Changeset

  @spec build(atom, map) :: %Verification{} | term
  def build(entity_atom, params \\ %{}), do: :erlang.apply(__MODULE__, entity_atom, [params])

  @spec insert(atom, map) :: {:ok, term} | {:error, binary}
  def insert(:verification, params \\ %{}) do
    params
    |> verification()
    |> redis_insert()
  end

  defp redis_insert(changeset) do
    with {:ok, entity} <- Redis.insert(changeset) do
      entity
    else
      _ -> raise "[Core.Factory]: Can't set data in redis"
    end
  end

  ### Factories

  @spec verification(map) :: %Verification{}
  def verification(params \\ %{}) do
    data = %{
      entity_type: Verification.entity_type(:email),
      account_address: generate(:account_address),
      token: "123456",
      status: Verification.status(:new)
    }

    data
    |> Map.merge(params)
    |> Verification.changeset()
    |> case do
      %{valid?: true} = changeset -> changeset
      _ -> raise "Changeset of Verification is not valid in `Core.Factory`"
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
end
