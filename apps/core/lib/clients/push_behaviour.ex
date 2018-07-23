defmodule Core.Clients.PushBehaviour do
  @moduledoc false

  @callback send(binary, binary, binary) :: :ok
end
