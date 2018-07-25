defmodule Quorum.Contracts.Generated.<%= module_name %> do
  <% module_name_atom = module_name |> Macro.underscore() %>
  @moduledoc false

  alias Quorum.Contract
  alias Ethereumex.HttpClient, as: QuorumClient

  @behaviour Quorum.Contracts.Generated.<%= module_name %>Behaviour

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

     <%= if constant? == true do %>
        def <%= function_name %>(<%= function_params %> <%= options_separator %>options) do
            data = Contract.hash_data(:<%= module_name_atom %>, "<%= function_quorum_name %>", [{<%= function_params %>}])
            quorum_client_request(data, options)
        end
     <% else %>
        def <%= function_name %>(<%= function_params %> <%= options_separator %>options) do
             data = Contract.hash_data(:<%= module_name_atom %>, "<%= function_quorum_name %>", [{<%= function_params %>}])
             transaction_via_queue(data, options)
        end

        def <%= function_name %>_raw(<%= function_params %> <%= options_separator %>options) do
             data = Contract.hash_data(:<%= module_name_atom %>, "<%= function_quorum_name %>", [{<%= function_params %>}])
             quorum_send_transaction(data, options)
        end
     <% end %>
  <% end %>

  @spec quorum_client_request(map, keyword) :: {:ok, binary}
  defp quorum_client_request(data, options) do
     data
     |> prepare_params(options)
     |> QuorumClient.eth_call("latest", [])
  end

  @spec quorum_send_transaction(map, keyword) :: {:ok, binary}
  defp quorum_send_transaction(data, options) do
     data
     |> prepare_params(options)
     |> Map.merge(%{gasPrice: "0x0", gas: "0x500000"})
     |> QuorumClient.eth_send_transaction([])
  end

  @spec transaction_via_queue(map, map) :: :ok
  defp transaction_via_queue(data, options) do
     data
     |> prepare_params(options)
     |> Quorum.create_transaction(Keyword.get(options, :meta, %{}))
  end

  @spec prepare_params(map, keyword) :: map
  defp prepare_params(data, options) do
     options
     |> Enum.into(%{})
     |> Map.take([:from, :to])
     |> Map.merge(%{data: data})
  end
end
