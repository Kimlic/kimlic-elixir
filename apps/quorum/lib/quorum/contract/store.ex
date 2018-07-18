defmodule Quorum.Contract.Store do
  @moduledoc false

  use Agent

  @spec start_link :: :ok
  def start_link do
    Agent.start_link(&get_abis_content/0, name: __MODULE__)
  end

  @spec get(atom) :: map | nil
  def get(contract_atom) when is_atom(contract_atom) do
    Agent.get(__MODULE__, & &1[contract_atom])
  end

  @spec get_abis_content :: map
  def get_abis_content do
    :quorum
    |> Application.app_dir("priv/abi/*.json")
    |> Path.wildcard()
    |> Enum.reduce([], fn path, accumulator ->
      abi_content =
        path
        |> File.read!()
        |> Jason.decode!()

      abi_atom =
        path
        |> String.split("/")
        |> List.last()
        |> String.replace(".json", "")
        |> Macro.underscore()
        |> String.to_atom()

      [{abi_atom, abi_content}] ++ accumulator
    end)
  end
end
