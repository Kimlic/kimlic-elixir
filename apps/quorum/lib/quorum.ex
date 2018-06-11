defmodule Quorum do
  @moduledoc """
  Quorum client
  """

  import Quorum.Contract
  alias Quorum.Jobs.TransactionCreate

  @type callback :: nil | {module :: atom, function :: atom, args :: list}

  defguardp is_callback(mfa)
            when is_tuple(mfa) and tuple_size(mfa) == 3 and
                   (is_atom(elem(mfa, 0)) and is_atom(elem(mfa, 1)) and is_list(elem(mfa, 2)))

  @spec create_verification_transaction(binary, atom, callback) :: :ok
  def create_verification_contract(account_address, :email, callback),
    do: create_verification_transaction(account_address, "createEmailVerification", callback)

  @spec create_verification_transaction(binary, atom, callback) :: :ok
  def create_verification_contract(account_address, :phone, callback),
    do: create_verification_transaction(account_address, "createPhoneVerification", callback)

  @spec create_verification_transaction(binary, binary, callback) :: :ok
  defp create_verification_transaction(account_address, contract_function, callback) do
    data =
      :verification_factory
      |> contract()
      |> hash_data(contract_function, [account_address])

    create_transaction(%{from: account_address, data: data}, callback, true)
  end

  @spec set_verification_result_transaction(binary, binary) :: :ok
  def set_verification_result_transaction(account_address, contract_address) do
    data =
      :base_verification
      |> contract()
      |> hash_data("setVerificationResult", [true])

    create_transaction(%{from: account_address, to: contract_address, data: data})
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
  @spec create_transaction(map, callback, boolean) :: :ok
  def create_transaction(transaction_data, callback \\ nil, provide_return_value \\ false)
      when is_nil(callback) or is_tuple(callback) do
    %{transaction_data: transaction_data}
    |> put_callback(callback)
    |> put_provide_return_value(provide_return_value)
    |> TransactionCreate.enqueue!()
  end

  @spec put_provide_return_value(map, boolean) :: map
  defp put_provide_return_value(message, true), do: Map.put(message, :provide_return_value, true)
  defp put_provide_return_value(message, _), do: message

  @spec put_provide_return_value(map, callback) :: map
  defp put_callback(message, {module, function, args} = callback) when is_callback(callback),
    do: Map.put(message, :callback, %{m: module, f: function, a: args})

  @spec put_provide_return_value(map, nil) :: map
  defp put_callback(message, nil), do: Map.put(message, :callback, nil)
end
