defmodule Core.Verifications.Verification do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @entity_type_phone "PHONE"
  @entity_type_email "EMAIL"

  def entity_type(:phone), do: @entity_type_phone
  def entity_type(:email), do: @entity_type_email

  @status_new "NEW"
  @status_passed "PASSED"
  @status_expired "EXPIRED"

  def status(:new), do: @status_new
  def status(:passed), do: @status_passed
  def status(:expired), do: @status_expired

  @primary_key false
  embedded_schema do
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
  end
end
