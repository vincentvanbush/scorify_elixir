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
end
