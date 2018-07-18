defmodule Quorum.Contracts.Generated.<%= module_name %> do
  <% module_name_atom = module_name |> Macro.underscore() %>
  @moduledoc false

  alias Quorum.Contract

  @quorum_client Application.get_env(:quorum, :client)

  <%= for %{"name" => function_name, "type" => type, "inputs" => args, "constant" => constant} <- functions, type == "function" do %>
     <% function_quorum_name = function_name %>
     <% function_name = Macro.underscore(function_name) %>
     <% function_params =
          args
          |> Enum.with_index(1)
          |> Enum.map(fn {%{"name" => param_name}, index} -> if param_name == "", do: "param#{index}", else: param_name end)
          |> Enum.map(&String.trim_leading(&1, "_"))
          |> Enum.join(",") %>

     <% options_separator = if length(args) == 0, do: "", else: "," %>

     <%= if constant == true do %>
        def <%= function_name %>(<%= function_params %> <%= options_separator %>options) do
           data = Contract.hash_data(:<%= module_name_atom %>, "<%= function_quorum_name %>", [{<%= function_params %>}])
           params = options |> prepare_options() |> Map.merge(%{data: data})
           quorum_client_request(params)
        end
     <% else %>
        def <%= function_name %>(<%= function_params %> <%= options_separator %>options) do
           data = Contract.hash_data(:<%= module_name_atom %>, "<%= function_quorum_name %>", [{<%= function_params %>}])
           params = options |> prepare_options() |> Map.merge(%{data: data})
           create_transaction(params)
        end

        def <%= function_name %>_queued(<%= function_params %> <%= options_separator %>options) do
           data = Contract.hash_data(:<%= module_name_atom %>, "<%= function_quorum_name %>", [{<%= function_params %>}])
           params = options |> prepare_options() |> Map.merge(%{data: data})
           create_transaction_queue(params, Keyword.get(options, :meta, %{}))
        end
     <% end %>
  <% end %>

  defp prepare_options(options), do: options |> Enum.into(%{}) |> Map.take([:from, :to])

  defp quorum_client_request(params), do: @quorum_client.eth_call(params, "latest", [])

  defp create_transaction(params), do: @quorum_client.eth_send_transaction(params, [])

  defp create_transaction_queue(params, meta), do: Quorum.create_transaction(params, meta)
end
