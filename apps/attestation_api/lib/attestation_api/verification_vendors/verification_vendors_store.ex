defmodule AttestationApi.VerificationVendors.VerificationVendorsStore do
  @moduledoc false

  use Agent

  @spec start_link :: :ok
  def start_link do
    verification_providers_data =
      :attestation_api
      |> Application.app_dir("priv/verification_providers.json")
      |> File.read!()
      |> Jason.decode!()

    Agent.start_link(fn -> verification_providers_data end, name: __MODULE__)
  end

  @spec all :: map
  def all, do: Agent.get(__MODULE__, & &1)

  @spec get_by_id(binary) :: map | nil
  def get_by_id(vendor_id) when is_binary(vendor_id) do
    all()
    |> Map.get("vendors", [])
    |> Enum.find(&(&1["id"] == vendor_id))
  end
end
