defmodule IntegrationWeb.Router do
  use IntegrationWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", IntegrationWeb do
    pipe_through :api
  end
end
