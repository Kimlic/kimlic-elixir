defmodule Quorum.Jobs.CreateUserAccount do
  use TaskBunny.Job

  @quorum_client Application.get_env(:quorum, :client)

  @spec perform(map) :: :ok
  def perform(params) do
    case @quorum_client.request(params, [], []) do
      {:ok, _} = resp ->
        resp
        # catch errors
    end
  end
end
