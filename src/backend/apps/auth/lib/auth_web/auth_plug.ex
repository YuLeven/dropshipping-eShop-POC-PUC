defmodule AuthWeb.Auth do
  @behaviour Plug

  @secret_key Application.get_env(:auth, AuthWeb.Endpoint)[:secret_key_base]

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context = conn |> handle_auth
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp handle_auth(conn) do
    conn
    |> get_req_header("authorization")
    |> extract_token
    |> case do
      {:ok, token} ->
        token |> build_context

      {:error, _} ->
        nil
    end
  end

  defp extract_token([]), do: {:error, "Token not present in request"}
  defp extract_token(["Bearer " <> token]), do: {:ok, token}

  defp build_context(token) do
    token
    |> JsonWebToken.verify(%{key: @secret_key})
    |> case do
      {:ok, claims} ->
        %{current_user_id: claims.sub, current_user_email: claims.email}

      {:error, _} ->
        {:error, "Invalid authorization token"}
    end
  end
end
