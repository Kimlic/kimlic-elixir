defmodule Mix.Tasks.Quorum.Contracts.Generate do
  @moduledoc false

  use Mix.Task

  alias Mix.Tasks.Format
  alias Quorum.Contract.Store, as: ContractStore

  require EEx

  @shortdoc "quorum.contracts.generate"

  EEx.function_from_file(:def, :generate_module, __DIR__ <> "/contract_stub.exs", [:module_name, :functions])

  @spec run(list) :: :ok
  def run(_params) do
    remove_previously_generated_files()
    generate_contracts()
    format_contracts()
  end

  @spec remove_previously_generated_files :: :ok
  defp remove_previously_generated_files do
    (__DIR__ <> "/generated/*.ex")
    |> Path.wildcard()
    |> Enum.each(&File.rm!/1)
  end

  @spec generate_contracts :: [term]
  defp generate_contracts do
    Enum.map(ContractStore.get_abis_content(), fn {module_atom, functions} ->
      module = to_string(module_atom)
      content = __MODULE__.generate_module(Macro.camelize(module), functions)
      File.write!(__DIR__ <> "/generated/#{module_atom}.ex", content)
    end)
  end

  @spec format_contracts :: :ok
  defp format_contracts, do: Format.run([])
end
