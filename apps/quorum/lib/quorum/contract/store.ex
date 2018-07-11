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
  defp get_abis_content do
    abis_path =
      :quorum
      |> Application.app_dir("priv/abi/*.json")
      |> Path.wildcard()

    abis_content =
      Enum.map(abis_path, fn path ->
        path
        |> File.read!()
        |> Jason.decode!()
      end)

    abis_atoms =
      Enum.map(abis_path, fn path ->
        path
        |> String.split("/")
        |> List.last()
        |> String.replace(".json", "")
        |> Macro.underscore()
        |> String.to_atom()
      end)

    Enum.zip(abis_atoms, abis_content)
  end
end
