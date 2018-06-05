defmodule Quorum.ABI do
  alias Quorum.ABI.{FunctionSelector, Parser, TypeEncoder}

  def encode(function_signature, data) when is_binary(function_signature) do
    function_signature
    |> Parser.parse!()
    |> encode(data)
  end

  def encode(%FunctionSelector{} = function_selector, data) do
    TypeEncoder.encode(data, function_selector)
  end

  def parse_specification(doc) do
    doc
    |> Enum.map(&FunctionSelector.parse_specification_item/1)
    |> Enum.filter(& &1)
  end
end
