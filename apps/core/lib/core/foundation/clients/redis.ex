defmodule Core.Foundation.Clients.Redis do
  @moduledoc false

  @behaviour Core.Foundation.Clients.Redis.Behaviour

  @spec get(binary) :: {:ok, term} | {:error, binary}
  def get(key) do
    with {:ok, encoded_value} <- Redix.command(:redix, ["GET", key]) do
      decode(encoded_value)
    end
  end

  @spec set(binary, term, pos_integer | nil) :: {:ok, term} | {:error, binary}
  def set(key, value, ttl \\ nil)
  def set(key, value, nil) when value != nil, do: do_set(["SET", key, encode(value)])
  def set(key, value, ttl) when value != nil, do: do_set(["SET", key, encode(value), "EX", ttl])

  @spec do_set(list) :: :ok | {:error, binary}
  defp do_set(params) do
    case Redix.command(:redix, params) do
      {:ok, _} -> :ok
      error -> error
    end
  end

  @spec del(binary) :: {:ok, term} | {:error, binary}
  def del(key) do
    Redix.command(:redix, ["DEL", key])
  end

  @spec encode(term) :: term
  defp encode(value), do: :erlang.term_to_binary(value)

  @spec decode(term) :: term
  defp decode(nil), do: nil
  defp decode(value), do: :erlang.binary_to_term(value)
end
