defmodule AttestationApi.VerificationVendors do
  @moduledoc """
  Manages digital verification vendors
  """

  alias AttestationApi.VerificationVendors.VerificationVendorsStore

  @spec all :: map
  def all, do: VerificationVendorsStore.all()

  @spec get_by_id(binary) :: {:ok, map} | {:error, :not_found}
  def get_by_id(vendor_id) do
    case VerificationVendorsStore.get_by_id(vendor_id) do
      nil -> {:error, :not_found}
      vendor -> {:ok, vendor}
    end
  end

  @spec get_kimlic_vendor_id :: binary
  def get_kimlic_vendor_id, do: "87177897-2441-43af-a6bf-4860afcdd067"

  @spec check_context_items(map) :: :ok | {:error, binary}
  def check_context_items(%{
        "vendor_id" => vendor_id,
        "document_type" => document_type,
        "country" => country,
        "context" => context
      }) do
    with {:ok, vendor} <- get_by_id(vendor_id),
         %{"countries" => countries, "context" => contexts} <- get_in(vendor, ["documents", document_type]),
         :ok <- validate_country(countries, country),
         :ok <- validate_context(contexts, context) do
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
      false -> {:error, "Country doesn't exist"}
    end
  end

  @spec validate_context(list, binary) :: :ok | {:error, binary}
  defp validate_context(contexts, context) do
    case context in contexts do
      true -> :ok
      false -> {:error, "Country doesn't exist"}
    end
  end

  @spec get_contexts(binary, binary) :: {:ok, list} | {:error, :not_found}
  def get_contexts(vendor_id, document_type) do
    vendor_id
    |> get_by_id()
    |> case do
      {:ok, vendor} -> {:ok, vendor["documents"][document_type]["context"]}
      err -> err
    end
  end
end
