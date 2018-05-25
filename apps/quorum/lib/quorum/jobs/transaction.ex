defmodule Core.Jobs.Transaction do
  use TaskBunny.Job
  require Logger

  def perform(opts) do
    Logger.info("Hello #{opts}")
    :ok
  end
end
