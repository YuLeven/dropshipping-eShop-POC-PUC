defmodule SalesWeb.GraphQL.Middleware.Authentication do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.context do
      %{current_user_id: _} ->
        resolution

      _ ->
        resolution
        |> Absinthe.Resolution.put_result(
          {:error, "You must be logged before performing this query"}
        )
    end
  end
end
