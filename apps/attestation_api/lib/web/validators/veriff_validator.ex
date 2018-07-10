defmodule AttestationApi.Validators.VeriffValidator do
  @moduledoc false

  import Ecto.Changeset

  alias AttestationApi.DigitalVerifications
  alias AttestationApi.VerificationVendors
  alias AttestationApi.VerificationVendors.VerificationVendorsStore

  @spec validate_timestamp(Ecto.Changeset.t(), atom) :: Ecto.Changeset.t()
  def validate_timestamp(changeset, field) do
    hour = 60 * 60
    now = DateTime.utc_now() |> DateTime.to_unix()

    validate_change(changeset, field, fn _, unix_timestamp ->
      case unix_timestamp > now - hour do
        true -> []
        false -> [timestamp: "Timestamp should not be older than hour"]
      end
    end)
  end

  @spec validate_vendor_id(Ecto.Changeset.t(), atom) :: Ecto.Changeset.t()
  def validate_vendor_id(changeset, field) do
    validate_change(changeset, field, fn _, vendor_id ->
      case VerificationVendorsStore.get_by_id(vendor_id) do
        nil -> [vendor_id: "Vendor_id is invalid"]
        _ -> []
      end
    end)
  end

  @spec validate_session_id_exists(Ecto.Changeset.t(), atom) :: Ecto.Changeset.t()
  def validate_session_id_exists(changeset, field) do
    validate_change(changeset, field, fn _, session_id ->
      case DigitalVerifications.get_by(%{session_id: session_id}) do
        nil -> [session_id: "Session_id is invalid"]
        _ -> []
      end
    end)
  end

  @spec validate_upload_media(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def validate_upload_media(changeset) do
    validate_change(changeset, :context, fn _, context ->
      context_data = %{
        "vendor_id" => get_field(changeset, :vendor_id),
        "document_type" => get_field(changeset, :document_type),
        "country" => get_field(changeset, :country),
        "context" => context
      }

      case VerificationVendors.check_context_items(context_data) do
        :ok -> []
        _ -> [context: "Context items are not valid"]
      end
    end)
  end
end
