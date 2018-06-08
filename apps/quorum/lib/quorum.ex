defmodule Quorum do
  @moduledoc """
  Quorum client
  """

  import Quorum.Contract
  alias Quorum.Jobs.TransactionCreate

  @behaviour Quorum.Behaviour

  @type callback :: nil | {module :: atom, function :: atom, args :: list}

  @spec create_verification_transaction(binary, atom, callback) :: :ok
  def create_verification_contract(account_address, :email, callback),
    do: create_verification_transaction(account_address, "createEmailVerification", callback)

  @spec create_verification_transaction(binary, atom, callback) :: :ok
  def create_verification_contract(account_address, :phone, callback),
    do: create_verification_transaction(account_address, "createPhoneVerification", callback)

  @spec create_verification_transaction(binary, binary, callback) :: :ok
  defp create_verification_transaction(account_address, contract_function, callback) do
    account_address_hex = parse_hex(account_address)

    data =
      :verification_factory
      |> contract()
      |> hash_data(contract_function, [account_address_hex])

    create_transaction(%{from: account_address_hex, data: data}, callback, true)
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
  @spec create_transaction(map, {atom, atom, list}, boolean) :: :ok
  def create_transaction(transaction_data, {module, function, args}, provide_return_value)
      when is_atom(module) and is_atom(function) and is_list(args) do
    %{
      transaction_data: transaction_data,
      callback: %{m: module, f: function, a: args}
    }
    |> put_provide_return_value(provide_return_value)
    |> TransactionCreate.enqueue!()
  end

  @spec put_provide_return_value(map, map) :: map
  defp put_provide_return_value(message, true), do: Map.put(message, :provide_return_value, true)
  defp put_provide_return_value(message, _), do: message

  @spec parse_hex(binary) :: integer
  defp parse_hex("0x" <> address) do
    {address_hex, _} = Integer.parse(address, 16)
    address_hex
  end
end
