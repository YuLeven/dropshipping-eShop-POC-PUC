defmodule SalesWeb.Router do
  use SalesWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(SalesWeb.Auth)
    plug(CORSPlug, origin: "*")
  end

  scope "/api" do
    pipe_through(:api)

    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: SalesWeb.GraphQL.Schema)
    forward("/", Absinthe.Plug, schema: SalesWeb.GraphQL.Schema)
  end
end
