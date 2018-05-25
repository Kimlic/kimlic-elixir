defmodule Core.Clients.Redis do
  @moduledoc false

  @spec get(binary) :: {:ok, term} | {:error, binary}
  def get(key) when is_binary(key) do
    with {:ok, encoded_value} <- Redix.command(:redix, ["GET", key]) do
      {:ok, decode(encoded_value)}
    end
  end

  @spec set(binary, term, pos_integer | nil) :: {:ok, term} | {:error, binary}
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

  @spec delete(binary) :: {:ok, term} | {:error, binary}
  def delete(key) when is_binary(key) do
    Redix.command(:redix, ["DEL", key])
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
  defp decode(nil), do: nil
  defp decode(value), do: :erlang.binary_to_term(value)
end
