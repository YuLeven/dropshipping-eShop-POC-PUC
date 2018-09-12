defmodule AuthWeb.Router do
  use AuthWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api" do
    pipe_through(:api)

    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: AuthWeb.GraphQL.Schema)
    forward("/", Absinthe.Plug, schema: AuthWeb.GraphQL.Schema)
  end
end
