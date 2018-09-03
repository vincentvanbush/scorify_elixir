defmodule ScorifyElixirWeb.Auth.Helper do
  @moduledoc false

  import Comeonin.Bcrypt, only: [checkpw: 2]
  alias ScorifyElixir.Repo
  alias ScorifyElixir.Auth.User

  def login_with_email_pass(email, given_pass) do
    user = Repo.get_by(User, email: String.downcase(email))

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, "Incorrect login credentials"}

      true ->
        {:error, "User not found"}
    end
  end

  def store_token(%User{} = user, token) do
    user
    |> User.store_token_changeset(%{token: token})
    |> Repo.update()
  end
end
