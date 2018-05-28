defmodule MobileApi.Router do
  use MobileApi, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", MobileApi do
    pipe_through(:api)

    post("/auth/create-profile", AuthController, :create_profile)
  end
end
