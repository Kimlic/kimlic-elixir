defmodule Quorum.Contracts.Generated.<%= module_name %> do
  <% module_name_atom = module_name |> Macro.underscore() %>
  @moduledoc false

  alias Quorum.Contract

  @behaviour Quorum.Contracts.Generated.<%= module_name %>Behaviour

  @quorum_client Application.get_env(:quorum, :client)

  <%= for %{"name" => function_name, "type" => type, "inputs" => args, "constant" => constant?} <- functions, type == "function" do %>
     <% function_quorum_name = function_name %>
     <% function_name = Macro.underscore(function_name) %>
     <% function_params =
          args
          |> Enum.with_index(1)
          |> Enum.map(fn {%{"name" => param_name}, index} -> if param_name == "", do: "param#{index}", else: param_name end)
          |> Enum.map(&String.trim_leading(&1, "_"))
          |> Enum.join(",") %>

     <% options_separator = if length(args) == 0, do: "", else: "," %>

     def <%= function_name %>(<%= function_params %> <%= options_separator %>options) do
        <% function_to_call = if constant?, do: "quorum_client_request", else: "create_transaction" %>
        data = Contract.hash_data(:<%= module_name_atom %>, "<%= function_quorum_name %>", [{<%= function_params %>}])

        <%= function_to_call %>(data, options)
     end
  <% end %>

  @spec prepare_params(map, keyword) :: map
  defp prepare_params(data, options) do
     options
     |> Enum.into(%{})
     |> Map.take([:from, :to])
     |> Map.merge(%{data: data})
  end

  @spec quorum_client_request(map, keyword) :: {:ok, binary}
  defp quorum_client_request(data, options) do
     data
     |> prepare_params(options)
     |> @quorum_client.eth_call("latest", [])
  end

  @spec create_transaction(map, map) :: :ok
  defp create_transaction(data, options) do
     data
     |> prepare_params(options)
     |> Quorum.create_transaction(Keyword.get(options, :meta, %{}))
  end
end
