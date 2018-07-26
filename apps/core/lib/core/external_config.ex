defmodule Core.ExternalConfig do
  @moduledoc false

  alias Quorum.Contract.Context

  @spec all :: map
  def all do
    %{
      "context_contract" => Context.get_context_address(),
      "attestation_parties" => attestation_parties()
    }
  end

  @spec attestation_parties :: list
  def attestation_parties do
    [
      %{"name" => "Veriff.me", "address" => Confex.fetch_env!(:quorum, :veriff_ap_address)}
    ]
  end
end
