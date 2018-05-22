defmodule Quorum.MixProject do
  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :quorum,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
