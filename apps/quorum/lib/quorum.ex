defmodule Quorum do
  @moduledoc """
  Quorum client
  """

  import Quorum.Contract

  alias Quorum.Jobs.TransactionCreate

  @type callback :: nil | {module :: atom, function :: atom, args :: list}

  @gas "0x500000"
  @gas_price "0x0"

  @quorum_client Application.get_env(:quorum, :client)

  defguardp is_callback(mfa)
            when is_tuple(mfa) and tuple_size(mfa) == 3 and
                   (is_atom(elem(mfa, 0)) and is_atom(elem(mfa, 1)) and is_list(elem(mfa, 2)))

  @spec create_verification_contract(atom, binary, integer, callback) :: :ok
  def create_verification_contract(:email, account_address, index, callback),
    do: create_verification_transaction(account_address, index, "createEmailVerification", callback)

  @spec create_verification_contract(atom, binary, integer, callback) :: :ok
  def create_verification_contract(:phone, account_address, index, callback),
    do: create_verification_transaction(account_address, index, "createPhoneVerification", callback)

  @spec create_verification_transaction(binary, binary, binary, callback) :: :ok
  defp create_verification_transaction(account_address, index, contract_func, callback) when is_callback(callback) do
    return_key = UUID.uuid4()

    # ToDo: fetch Kimlic AP address from BC
    kimlic_ap_address = "0x6ad58c4fd879b94400eef71e40747ac743b6031f"
    kimlic_ap_password = "Kimlicp@ssw0rd"

    # ToDo: fetch VerificationContractFactory address from BC
    verification_contract_factory_address = "0x2d819f3832ec0fecc8eec4efe4e1a596878b2079"

    meta = %{
      callback: callback,
      verification_contract_return_key: return_key,
      verification_contract_factory_address: verification_contract_factory_address
    }

    data =
      hash_data(:verification_factory, contract_func, [
        {account_address, kimlic_ap_address, index, account_address, return_key}
      ])

    transaction_data = %{
      from: kimlic_ap_address,
      to: verification_contract_factory_address,
      data: data
    }

    @quorum_client.request("personal_unlockAccount", [kimlic_ap_address, kimlic_ap_password], [])

    create_transaction(transaction_data, meta)
  end

  @spec set_verification_result_transaction(binary) :: :ok
  def set_verification_result_transaction(contract_address) do
    data = hash_data(:base_verification, "setVerificationResult", [{true}])

    kimlic_ap_address = "0x6ad58c4fd879b94400eef71e40747ac743b6031f"
    kimlic_ap_password = "Kimlicp@ssw0rd"
    @quorum_client.request("personal_unlockAccount", [kimlic_ap_address, kimlic_ap_password], [])

    create_transaction(%{from: kimlic_ap_address, to: contract_address, data: data})
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
         Transaction status argument - @spec map
         Retrun value argument - @spec {:ok, binary} | {:error, binary}

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
  defp put_gas(message), do: Map.merge(%{gasPrice: @gas_price, gas: @gas}, message)

  defp prepare_callback(%{callback: {module, function, args}} = meta),
    do: Map.put(meta, :callback, %{m: module, f: function, a: args})

  defp prepare_callback(%{callback: callback}) do
    raise "Invalid callback format. Requires: {module, function, args} tuple, get: #{inspect(callback)}}"
  end

  defp prepare_callback(meta), do: meta
end
