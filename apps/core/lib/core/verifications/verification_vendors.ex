defmodule Core.Verifications.VerificationVendors do
  @moduledoc """
  Manages video verification vendors
  """

  @spec all :: map
  def all do
    :core
    |> Application.app_dir("priv/verification_providers.json")
    |> File.read!()
    |> Jason.decode!()
  end
end
