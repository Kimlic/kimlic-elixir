defmodule AttestationApi.DigitalVerifications.DigitalVerification do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias AttestationApi.DigitalVerifications.DigitalVerificationDocument

  @required_fields ~w(account_address session_id)a
  @optional_fileds ~w(contract_address status veriffme_code veriffme_status veriffme_reason veriffme_comments)a

  @status_new "NEW"
  @status_pending "PENDING"
  @status_passed "PASSED"
  @status_failed "FAILED"

  @spec status(atom) :: binary
  def status(:new), do: @status_new
  def status(:pending), do: @status_pending
  def status(:passed), do: @status_passed
  def status(:failed), do: @status_failed

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "digital_verifications" do
    field(:account_address, :string)
    field(:session_id, :string)
    field(:contract_address, :string)
    field(:status, :string, default: @status_new)
    field(:veriffme_code, :integer)
    field(:veriffme_status, :string)
    field(:veriffme_reason, :string)
    field(:veriffme_comments, {:array, :map})
    timestamps()

    has_many(:documents, DigitalVerificationDocument, foreign_key: :verification_id)
  end

  @spec changeset(map) :: Ecto.Changeset.t()
  def changeset(params) when is_map(params), do: changeset(%__MODULE__{}, params)

  @spec changeset(__MODULE__, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = entity, params) do
    entity
    |> cast(params, @required_fields ++ @optional_fileds)
    |> validate_required(@required_fields)
  end
end
