defmodule Quorum.Behaviour do
  @type callback :: nil | {atom, atom, list}
  @callback create_verification_contract(binary, atom, callback) :: :ok
end
