defmodule ScorifyElixirWeb.Auth.UserResolver do
  import ScorifyElixirWeb.Auth.Helper
  alias ScorifyElixir.Auth

  def create(params, _info) do
    Auth.create_user(params)
  end

  def login(%{email: email, password: password}, _info) do
    with {:ok, user} <- login_with_email_pass(email, password),
         {:ok, jwt, _} <- ScorifyElixirWeb.Guardian.encode_and_sign(user),
         {:ok, _} <- store_token(user, jwt) do
      {:ok, %{token: jwt}}
    end
  end

  def logout(_args, %{context: %{current_user: current_user, token: _}}) do
    current_user |> Auth.set_token(nil)
    {:ok, current_user}
  end

  def logout(_args, _) do
    {:error, "You are not signed in"}
  end
end
