defmodule Core.Clients.Redis do
  @moduledoc false

  import Ecto.Changeset
  alias Ecto.Changeset

  @spec get(binary) :: {:ok, term} | {:error, binary}
  def get(key) when is_binary(key) do
    with {:ok, encoded_value} <- Redix.command(:redix, ["GET", key]) do
      if encoded_value == nil do
        {:error, :not_found}
      else
        {:ok, decode(encoded_value)}
      end
    end
  end

  @spec upsert(Changeset.t(), pos_integer | nil) :: {:ok, term} | {:error, binary}
  def upsert(%Changeset{} = changeset, ttl_seconds \\ nil) do
    {_, key} = fetch_field(changeset, :redis_key)
    entity = Changeset.apply_changes(changeset)

    case set(key, entity, ttl_seconds) do
      :ok -> {:ok, entity}
      err -> err
    end
  end

  @spec set(binary, term, pos_integer | nil) :: :ok | {:error, atom}
  def set(key, value, ttl_seconds \\ nil)

  def set(key, value, nil) when is_binary(key) and value != nil,
    do: do_set(["SET", key, encode(value)])

  def set(key, value, ttl_seconds) when is_binary(key) and value != nil,
    do: do_set(["SET", key, encode(value), "EX", ttl_seconds])

  @spec do_set(list) :: :ok | {:error, binary}
  defp do_set(params) do
    case Redix.command(:redix, params) do
      {:ok, _} -> :ok
      err -> err
    end
  end

  @spec delete(map) :: {:ok, non_neg_integer} | {:error, binary}
  def delete(%{redis_key: key}), do: delete(key)

  @spec delete(binary) :: {:ok, non_neg_integer} | {:error, binary}
  def delete(key) when is_binary(key) do
    case Redix.command(:redix, ["DEL", key]) do
      {:ok, n} when n >= 1 -> {:ok, n}
      {:ok, 0} -> {:error, :not_found}
      err -> err
    end
  end

  @spec flush :: :ok | {:error, binary}
  def flush do
    case Redix.command(:redix, ["FLUSHDB"]) do
      {:ok, _} -> :ok
      err -> err
    end
  end

  @spec encode(term) :: term
  defp encode(value), do: :erlang.term_to_binary(value)

  @spec decode(term) :: term
  defp decode(value), do: :erlang.binary_to_term(value)
end
