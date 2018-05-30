defmodule Quorum.Jobs.UpdateUserAccount do
  use TaskBunny.Job

  @quorum_client Application.get_env(:quorum, :client)

  def perform(params) do
    case @quorum_client.update_user_account(params) do
      {:ok, _} = resp ->
        resp
        # catch errors
    end
  end
end
