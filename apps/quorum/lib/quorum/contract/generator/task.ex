defmodule Mix.Tasks.Quorum.Contracts.Generate do
  @moduledoc false

  use Mix.Task

  alias Mix.Tasks.Format
  alias Quorum.Contract.Store, as: ContractStore

  require EEx

  @shortdoc "quorum.contracts.generate"

  EEx.function_from_file(:def, :generate_contract, __DIR__ <> "/contract_stub.eex", [:module_name, :functions])

  EEx.function_from_file(:def, :generate_contract_behaviour, __DIR__ <> "/contract_behaviour_stub.eex", [
    :module_name,
    :functions
  ])

  @spec run(list) :: :ok
  def run(_params) do
    remove_previously_generated_files()
    generate_contracts()
    format_contracts()
  end

  @spec remove_previously_generated_files :: :ok
  defp remove_previously_generated_files do
    generated_path("*")
    |> Path.wildcard()
    |> Enum.each(&File.rm!/1)
  end

  @spec generate_contracts :: [term]
  defp generate_contracts do
    Enum.map(ContractStore.get_abis_content(), fn {module_atom, functions} ->
      module_name = module_atom |> to_string() |> Macro.camelize()
      content = __MODULE__.generate_contract(module_name, functions)
      File.write!(generated_path(module_atom), content)

      content = __MODULE__.generate_contract_behaviour(module_name, functions)
      File.write!(generated_path("#{module_atom}_behaviour"), content)
    end)
  end

  @spec format_contracts :: :ok
  defp format_contracts, do: Format.run([])

  @spec generated_path(binary) :: binary
  defp generated_path(path), do: __DIR__ <> "/../generated/#{path}.ex"
end
