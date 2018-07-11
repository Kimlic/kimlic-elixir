defmodule AttestationApi.Validators.CreateSessionValidator do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias AttestationApi.Validators.VeriffValidator

  @primary_key false
  embedded_schema do
    field(:vendor_id, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:lang, :string)
    field(:timestamp, :integer)
    field(:device_os, :string)
    field(:device_token, :string)
  end

  @spec changeset(map) :: Ecto.Changeset.t()
  def changeset(params) do
    fields = __MODULE__.__schema__(:fields)

    %__MODULE__{}
    |> cast(params, fields)
    |> validate_required(fields)
    |> validate_format(:lang, ~r/^\w{2}$/)
    |> validate_inclusion(:device_os, ["ios", "android"])
    |> VeriffValidator.validate_vendor_id(:vendor_id)
    |> VeriffValidator.validate_timestamp(:timestamp)
  end
end
