defmodule FidoQrCode.ScopeRequest do
  use Ecto.Schema

  @status_new "NEW"
  @status_inactive "INACTIVE"

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "scope_request" do
    field(:status, :string, null: false, default: @status_new)

    timestamps()
  end

  def status(:new), do: @status_new
end