defmodule Core.Verifications.DigitalVerification do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset

  @required_fields ~w(account_address session_id)a
  @optional_fileds ~w(status contract_address veriffme_code veriffme_status veriffme_reason veriffme_comments)a

  @status_new "NEW"
  @status_passed "PASSED"
  @status_failed "FAILED"

  @spec status(atom) :: binary
  def status(:new), do: @status_new
  def status(:passed), do: @status_passed
  def status(:failed), do: @status_failed

  @primary_key false
  embedded_schema do
    field(:redis_key, :string, virtual: true)
    field(:account_address, :string)
    field(:session_id, :string)
    field(:contract_address, :string)
    field(:status, :string, default: @status_new)
    field(:veriffme_code, :integer)
    field(:veriffme_status, :string)
    field(:veriffme_reason, :string)
    field(:veriffme_comments, {:array, :map})
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
    {_, session_id} = fetch_field(changeset, :session_id)

    put_change(changeset, :redis_key, redis_key(session_id))
  end

  @spec redis_key(binary) :: binary
  def redis_key(session_id), do: "verification:digital:#{session_id}"
end
