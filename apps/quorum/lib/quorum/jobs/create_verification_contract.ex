defmodule Core.Jobs.CreateVerificationContract do
  use TaskBunny.Job

  @quorum_client Application.get_env(:quorum, :client)

  def perform(params) do
    case @quorum_client.create_verification_contract(params) do
      {:ok, _} = resp ->
        resp
        # catch errors
    end
  end
end
