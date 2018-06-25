defmodule AttestationApi.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :attestation_api, adapter: Ecto.Adapters.Postgres
  alias __MODULE__

  @spec first_or_fail(Ecto.Query.t()) :: {:ok, term} | {:error, atom}
  def first_or_fail(query) do
    case Repo.one(query) do
      nil -> {:error, :not_found}
      entity -> {:ok, entity}
    end
  end
end
