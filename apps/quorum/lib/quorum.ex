defmodule Quorum do
  @moduledoc """
  Quorum client
  """

  import Quorum.Contract

  alias Quorum.Contract.Context
  alias Quorum.Jobs.TransactionCreate

  @type callback :: nil | {module :: module, function :: atom, args :: list}
  @type quorum_client_response_t :: {:ok, term} | {:error, map | binary | atom}

  @account_storage_adapter Application.get_env(:quorum, :contracts)[:account_storage_adapter]

  @gas "0x500000"
  @gas_price "0x0"

  @quorum_client Application.get_env(:quorum, :client)
  @hashed_false "0x0000000000000000000000000000000000000000000000000000000000000000"

  defguardp is_callback(mfa)
            when is_tuple(mfa) and tuple_size(mfa) == 3 and
                   (is_atom(elem(mfa, 0)) and is_atom(elem(mfa, 1)) and is_list(elem(mfa, 2)))

  @spec create_verification_contract(atom, binary, callback) :: :ok | {:error, map}
  def create_verification_contract(type, account_address, callback) do
    verification_field = Atom.to_string(type)

    with :ok <- validate_account_field(account_address, verification_field) do
      create_verification_transaction(account_address, verification_field, callback)
    end
  end

  @spec validate_account_field(binary, binary) :: :ok | {:error, atom}
  def validate_account_field(account_address, field) do
    res =
      @account_storage_adapter.get_field_history_length(
        account_address,
        field,
        to: Context.get_account_storage_adapter_address()
      )

    #    params = %{
    #      to: Context.get_account_storage_adapter_address(),
    #      data: hash_data(:account_storage_adapter, "getFieldHistoryLength", [{account_address, field}])
    #    }

    case res do
      {:ok, @hashed_false} ->
        {:error, :account_field_not_set}

      # byte_size 66 = hex prefix `0x` + 32 bytes
      {:ok, resp} when byte_size(resp) != 66 ->
        {:error, :account_field_not_set}

      {:ok, _} ->
        :ok

      err ->
        err
    end
  end

  @spec create_verification_transaction(binary, binary, callback) :: :ok
  defp create_verification_transaction(account_address, verification_field, callback) when is_callback(callback) do
    return_key = UUID.uuid4()
    kimlic_ap_address = Context.get_kimlic_attestation_party_address()
    kimlic_ap_password = Confex.fetch_env!(:quorum, :kimlic_ap_password)
    verification_contract_factory_address = Context.get_verification_contract_factory_address()

    meta = %{
      callback: callback,
      verification_contract_return_key: return_key,
      verification_contract_factory_address: verification_contract_factory_address
    }

    hashed_data =
      hash_data(:verification_contract_factory, "createBaseVerificationContract", [
        {account_address, kimlic_ap_address, return_key, verification_field}
      ])

    transaction_data = %{
      from: kimlic_ap_address,
      to: verification_contract_factory_address,
      data: hashed_data
    }

    @quorum_client.request("personal_unlockAccount", [kimlic_ap_address, kimlic_ap_password], [])

    create_transaction(transaction_data, meta)
  end

  @spec set_verification_result_transaction(binary) :: :ok
  def set_verification_result_transaction(contract_address) do
    data = hash_data(:base_verification, "finalizeVerification", [{true}])
    kimlic_ap_address = Context.get_kimlic_attestation_party_address()
    kimlic_ap_password = Confex.fetch_env!(:quorum, :kimlic_ap_password)

    @quorum_client.request("personal_unlockAccount", [kimlic_ap_address, kimlic_ap_password], [])

    create_transaction(%{from: kimlic_ap_address, to: contract_address, data: data})
  end

  @spec set_digital_verification_result_transaction(binary, boolean) :: :ok
  def set_digital_verification_result_transaction(contract_address, status) when is_boolean(status) do
    data = hash_data(:base_verification, "finalizeVerification", [{status}])
    veriff_ap_address = Confex.fetch_env!(:quorum, :veriff_ap_address)
    veriff_ap_password = Confex.fetch_env!(:quorum, :veriff_ap_password)

    @quorum_client.request("personal_unlockAccount", [veriff_ap_address, veriff_ap_password], [])

    create_transaction(%{from: veriff_ap_address, to: contract_address, data: data})
  end

  @doc """
    Create transaction in Quorum via TaskBunny.
    Uses two jobs `TransactionCreate` and `TransactionStatus` that applied to two queues respectively:
    `transaction` and `transaction_status`.

    `TransactionCreate`
    Steps:
      1. creates transaction in Quorum using `eth_sendTransaction` call
      2. on success response from Quorum - create second job `TransactionStatus` with transaction hash

    `TransactionStatus`
    Steps:
      1. Check transaction status in Quorum using `eth_get_transaction_receipt` call
      2. Try 5 times, until success responce. On failed response - mark job as failed
      3. If argument `provide_return_value` set as true: fetch `return_value` from Quorum using `debug_traceTransaction` call
      4. Call callback if it provided. Transaction status and return value will be added as last arguments.
         Transaction status argument - @type :: map
         Retrun value argument - @type :: {:ok, binary} | {:error, binary}

    ## Examples

      create_transaction(%{...}, {MyModule, :callback, ["my_callback_param"]})

      def MyModule do

        def callback("my_callback_param", transaction_status, {:ok, return_value}), do: ...

        def callback("my_callback_param", transaction_status, {:error, reason}), do: ...
      end

  """
  @spec create_transaction(map, map) :: :ok
  def create_transaction(transaction_data, meta \\ %{}) do
    TransactionCreate.enqueue!(%{
      meta: prepare_callback(meta),
      transaction_data: put_gas(transaction_data)
    })
  end

  @spec put_gas(map) :: map
  defp put_gas(transaction_data), do: Map.merge(%{gasPrice: @gas_price, gas: @gas}, transaction_data)

  defp prepare_callback(%{callback: {module, function, args}} = meta),
    do: Map.put(meta, :callback, %{m: module, f: function, a: args})

  defp prepare_callback(%{callback: callback}) do
    raise "Invalid callback format. Requires: {module, function, args} tuple, get: #{inspect(callback)}}"
  end

  defp prepare_callback(meta), do: meta
end
