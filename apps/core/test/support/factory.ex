defmodule Core.Factory do
  @moduledoc false

  alias Core.Clients.Redis
  alias Core.Verifications.Verification
  alias Ecto.Changeset

  @spec build(atom, map) :: %Verification{} | term
  def build(entity_atom, params \\ %{}), do: :erlang.apply(__MODULE__, entity_atom, [params])

  @spec insert(atom, binary, map) :: {:ok, term} | {:error, binary}
  def insert(entity_atom, key, params \\ %{}) do
    entity = build(entity_atom, params)

    with :ok <- Redis.set(key, entity) do
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
      account_address: "0x123456789#{Enum.random(10_000..99_999)}",
      token: "123456",
      status: Verification.status(:new)
    }

    data
    |> Map.merge(params)
    |> Verification.changeset()
    |> case do
      %{valid?: true} = changeset -> Changeset.apply_changes(changeset)
      _ -> raise "Changeset of Verification is not valid in `Core.Factory`"
    end
  end
end
