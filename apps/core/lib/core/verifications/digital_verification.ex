defmodule Core.Verifications.DigitalVerification do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset

  @required_fields ~w(account_address session_id)a
  @optional_fileds ~w(contract_address)a

  @primary_key false
  embedded_schema do
    field(:redis_key, :string, virtual: true)
    field(:account_address, :string)
    field(:session_id, :string)
    field(:contract_address, :string)
  end

  @spec changeset(map) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields ++ @optional_fileds)
    |> validate_required(@required_fields)
    |> put_redis_key()
  end

  @spec put_redis_key(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def put_redis_key(%Changeset{valid?: true} = changeset) do
    {_, account_address} = fetch_field(changeset, :account_address)

    put_change(changeset, :redis_key, redis_key(account_address))
  end

  @spec redis_key(binary) :: binary
  def redis_key(account_address), do: "verification:digital:#{account_address}"
end
