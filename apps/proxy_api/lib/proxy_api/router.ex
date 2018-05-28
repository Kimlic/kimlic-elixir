defmodule ProxyApi.Router do
  use ProxyApi, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ProxyApi do
    pipe_through :api
  end
end
