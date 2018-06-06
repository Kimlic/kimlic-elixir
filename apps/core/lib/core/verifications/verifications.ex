defmodule Core.Verifications do
  @moduledoc false

  import Core.Verifications.Verification, only: [allowed_type_atom: 1]
  alias Core.Clients.Redis
  alias Core.Verifications.Verification
  alias Ecto.Changeset

  @typep create_verification_t :: {:ok, %Verification{}} | {:error, binary} | {:error, Ecto.Changeset.t()}

  @token_generator Application.get_env(:core, :dependencies)[:token_generator]
  @verification_status_new Verification.status(:new)

  @spec create_verification(binary, atom) :: create_verification_t
  def create_verification(account_address, type) when allowed_type_atom(type) do
    %{
      account_address: account_address,
      token: @token_generator.generate(type),
      entity_type: Verification.entity_type(type),
      status: @verification_status_new
    }
    |> insert_verification(Confex.fetch_env!(:core, :verification_email_ttl))
  end

  @spec insert_verification(map, binary) :: create_verification_t
  defp insert_verification(attrs, verification_ttl) do
    with %Ecto.Changeset{valid?: true} = verification <- Verification.changeset(attrs) do
      Redis.insert(verification, verification_ttl)
    end
  end

  ### Quering

  @spec get(binary, atom) :: {:ok, %Verification{}} | {:error, term}
  def get(account_address, type) do
    type
    |> Verification.entity_type()
    |> Verification.redis_key(account_address)
    |> Redis.get()
  end

  @spec delete(%Verification{} | term) :: {:ok, non_neg_integer} | {:error, term}
  def delete(%Verification{} = verification) do
    Redis.delete(verification)
  end
end
