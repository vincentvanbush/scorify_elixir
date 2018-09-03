defmodule ScorifyElixirWeb.Context do
  @behaviour Plug

  import Plug.Conn
  import Ecto.Query, only: [where: 2]

  alias ScorifyElixir.Repo
  alias ScorifyElixir.Auth.User

  def init(opts) do
    opts
  end

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} -> conn |> put_private(:absinthe, %{context: context})
      _ -> conn
    end
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- conn |> get_req_header("authorization"),
         {:ok, current_user} <- token |> authorize
    do
      {:ok, %{current_user: current_user, token: token}}
    end
  end

  defp authorize(token) do
    User
    |> where(token: ^token)
    |> Repo.one()
    |> case do
      nil -> {:error, "Invalid authorization token"}
      user -> {:ok, user}
    end
  end
end
