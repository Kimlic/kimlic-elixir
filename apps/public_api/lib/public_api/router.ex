defmodule PublicApi.Router do
  use PublicApi, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", PublicApi do
    pipe_through(:api)
  end
end
