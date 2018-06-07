defmodule Quorum.Behaviour do
  @moduledoc false

  @type callback :: nil | {module :: atom, function :: atom, args :: list}
  @callback create_verification_contract(binary, atom, callback) :: :ok
end
