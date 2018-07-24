defmodule AttestationApi.Clients.Push do
  @moduledoc false

  @behaviour AttestationApi.Clients.PushBehaviour

  @available_device_os ["ios", "android"]
  @request_options [ssl: [{:versions, [:"tlsv1.2"]}]]

  @spec send(binary, binary, binary) :: :ok
  def send(message, device_os, device_token) when device_os in @available_device_os do
    with {:ok, _response} <-
           HTTPoison.post(
             push_url(),
             Jason.encode!(%{"message" => message, "device_os" => device_os, "device_token" => device_token}),
             headers(),
             @request_options
           ) do
      :ok
    else
      err ->
        Log.error("[#{__MODULE__}] Fail to send request for push notification. Reason: #{inspect(err)}")
        :ok
    end
  end

  @spec push_url :: binary
  def push_url do
    Confex.fetch_env!(:attestation_api, __MODULE__)[:push_url]
  end

  @spec headers :: list
  defp headers, do: ["Content-Type": "application/json"]
end
