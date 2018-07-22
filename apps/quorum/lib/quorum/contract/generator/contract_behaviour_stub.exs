defmodule Quorum.Contracts.Generated.<%= module_name %>Behaviour do
  @moduledoc false

  <%= for %{"name" => function_name, "type" => type, "inputs" => args, "constant" => constant} <- functions, type == "function" do %>
     <% return_type = if constant, do: "{:ok, binary}", else: ":ok" %>
     <% options_separator = if length(args) == 0, do: "", else: "," %>
     <% function_name = Macro.underscore(function_name) %>
     <% params_types = ["term"] |> Stream.cycle() |> Enum.take(length(args)) |> Enum.join(", ") %>

     @callback <%= function_name %>(<%= params_types %> <%= options_separator %> keyword) :: <%= return_type %>
  <% end %>
end
