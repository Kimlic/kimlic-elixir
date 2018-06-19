defmodule Core.Verifications.VerificationVendors do
  @moduledoc """
  Manages video verification vendors
  """

  @spec all :: map
  def all do
    :core
    |> Application.app_dir("priv/verification_providers.json")
    |> File.read!()
    |> Jason.decode!()
  end

  @spec get_by_id(binary) :: {:ok, map} | {:error, :not_found}
  def get_by_id(vendor_id) do
    all()
    |> Map.get("vendors", [])
    |> Enum.find(&(&1["id"] == vendor_id))
    |> case do
      nil -> {:error, :not_found}
      vendor -> {:ok, vendor}
    end
  end

  @spec check_context_items(map) :: :ok | {:error, binary}
  def check_context_items(%{
        "vendor_id" => vendor_id,
        "document_type" => document_type,
        "document_payload" => document_payload,
        "country" => country
      }) do
    with {:ok, vendor} <- get_by_id(vendor_id),
         %{"countries" => countries, "context" => contexts} <- get_in(vendor, ["documents", document_type]),
         :ok <- validate_country(countries, country),
         :ok <- validate_contexts(document_payload, contexts) do
      :ok
    else
      {:error, _message} = err -> err
      _ -> {:error, "Contexts items are not valid"}
    end
  end

  @spec validate_country(list, binary) :: :ok | {:error, binary}
  defp validate_country(countries, country) do
    case country in countries do
      true -> :ok
      false -> {:error, "Country doesn't exists"}
    end
  end

  @spec validate_contexts(map, list) :: :ok | {:error, binary}
  defp validate_contexts(document_payload, contexts) do
    document_payload
    |> Map.keys()
    |> Enum.all?(&(&1 in contexts))
    |> case do
      true -> :ok
      false -> {:error, "Invalid document contexts"}
    end
  end
end
