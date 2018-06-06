defmodule Core.Verifications.Verification do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset

  @entity_type_phone "PHONE"
  @entity_type_email "EMAIL"

  @status_new "NEW"
  @status_passed "PASSED"
  @status_expired "EXPIRED"

  def entity_type(:phone), do: @entity_type_phone
  def entity_type(:email), do: @entity_type_email

  def status(:new), do: @status_new
  def status(:passed), do: @status_passed
  def status(:expired), do: @status_expired

  @primary_key false
  embedded_schema do
    field(:redis_key, :string, virtual: true)
    field(:account_address, :string)
    field(:entity_type, :string)
    field(:token, :string)
    field(:status, :string)
  end

  @spec changeset(%{}) :: Ecto.Changeset.t()
  def changeset(params) do
    schema_fields = __MODULE__.__schema__(:fields)

    %__MODULE__{}
    |> cast(params, schema_fields)
    |> validate_required(schema_fields)
    |> validate_inclusion(:entity_type, ["PHONE", "EMAIL"])
    |> put_redis_key()
  end

  @spec put_redis_key(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def put_redis_key(%Changeset{valid?: true} = changeset) do
    {_, type} = fetch_field(changeset, :entity_type)
    {_, account_address} = fetch_field(changeset, :account_address)
    put_change(changeset, :redis_key, redis_key(type, account_address))
  end

  def put_redis_key(changeset), do: changeset

  def redis_key(type, account_address), do: "verification:#{String.downcase(type)}:#{account_address}"
end
