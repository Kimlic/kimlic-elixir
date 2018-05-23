defmodule Core.Business.Auth.Schemas.Verification do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @entity_type_new "NEW"
  @entity_type_email "EMAIL"

  def entity_type(:new), do: @entity_type_new
  def entity_type(:email), do: @entity_type_email

  @primary_key false
  embedded_schema do
    field(:account_id, :string)
    field(:entity_type, :string)
    field(:entity_hash, :string)
    field(:token, :string)
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
