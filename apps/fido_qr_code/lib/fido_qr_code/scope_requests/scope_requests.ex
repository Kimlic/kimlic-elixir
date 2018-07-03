defmodule FidoQrCode.ScopeRequests do
  alias FidoQrCode.ScopeRequest
  alias FidoQrCode.Repo

  def get!(id), do: Repo.get!(ScopeRequest, id)

  def create(attrs) do
    %ScopeRequest{}
    |> ScopeRequest.changeset(attrs)
    |> Repo.insert()
  end

  def update(%ScopeRequest{} = schema, attrs) do
    schema
    |> ScopeRequest.changeset(attrs)
    |> Repo.update()
  end

  def check_processed(%ScopeRequest{used: true}), do: {:error, :scope_request_already_processed}
  def check_processed(%ScopeRequest{used: false}), do: :ok

  def check_expired(%ScopeRequest{inserted_at: inserted_at}) do
    Confex.fetch_env!(:fido_qr_code, :scope_request_ttl)
    # ToDo: check expiration time by inserted_at

    :ok
  end

  def process(%ScopeRequest{} = scope_request, username) do
    update(scope_request, %{used: true, username: username})
  end
end
