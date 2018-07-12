defmodule AttestationApi.Validators.UploadMediaValidator do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias AttestationApi.Clients.Veriffme
  alias AttestationApi.Types.Base64
  alias AttestationApi.Validators.VeriffValidator

  @primary_key false
  embedded_schema do
    field(:vendor_id, :string)
    field(:session_id, :string)
    field(:country, :string)
    field(:document_type, :string)
    field(:context, :string)
    field(:content, Base64)
    field(:timestamp, :integer)
  end

  @spec changeset(map) :: Ecto.Changeset.t()
  def changeset(params) do
    fields = __MODULE__.__schema__(:fields)

    %__MODULE__{}
    |> cast(params, fields)
    |> validate_required(fields)
    |> validate_inclusion(:context, Veriffme.contexts())
    |> VeriffValidator.validate_vendor_id(:vendor_id)
    |> VeriffValidator.validate_image(:content)
    |> VeriffValidator.validate_timestamp(:timestamp)
    |> VeriffValidator.validate_upload_media()
    |> VeriffValidator.validate_session_id_exists(:session_id)
  end
end
