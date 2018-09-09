defmodule SalesWeb.Router do
  use SalesWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SalesWeb do
    pipe_through :api
  end
end
