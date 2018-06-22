defmodule AttestationApi.Requests.CreateSessionRequest do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(vendor_id first_name last_name lang timestamp)a
  @fields @required

  @primary_key false
  embedded_schema do
    # todo: check vendor and langs from list
    field(:vendor_id, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:lang, :string)
    field(:timestamp, :integer)
  end

  @spec changeset(map) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@required)
    |> validate_timestamp(:timestamp)
  end

  @spec validate_timestamp(Ecto.Changeset.t(), atom, list) :: Ecto.Changeset.t()
  def validate_timestamp(changeset, field, _opts \\ []) do
    validate_change(changeset, field, fn _, unix_timestamp ->
      hour = :timer.hours(1)
      now = DateTime.utc_now() |> DateTime.to_unix()

      if unix_timestamp > now - hour do
        []
      else
        [timestamp: "Timestamp should not be older than hour"]
      end
    end)
  end
end
