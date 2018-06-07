defmodule Quorum.Proxy do
  @quorum_proxy_client Application.get_env(:quorum, :proxy_client)

  alias HTTPoison.Response

  @spec proxy(map) :: {:ok, map} | {:error, map}
  def proxy(%{"method" => method, "id" => id} = payload) do
    with :ok <- validate_rpc_method(method, id) do
      @quorum_proxy_client.call_rpc(payload)
    end
  end

  @spec validate_rpc_method(binary, integer) :: :ok | {:error, map}
  defp validate_rpc_method(method, id) do
    case method in Confex.fetch_env!(:quorum, :allowed_rpc_methods) do
      true ->
        :ok

      false ->
        body = %{
          id: id,
          jsonrpc: "2.0",
          error: %{code: -32_601, message: "Method not found", data: "Method not allowed for RPC"}
        }

        {:ok, %Response{status_code: 404, body: Jason.encode!(body)}}
    end
  end
end
