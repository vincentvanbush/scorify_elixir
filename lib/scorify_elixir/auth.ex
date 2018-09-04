defmodule ScorifyElixir.Auth do
  alias ScorifyElixir.Repo

  alias ScorifyElixir.Auth.{
    User
  }

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(id) do
    User
    |> Repo.get(id)
  end

  def set_token(%User{} = user, token) do
    user
    |> User.store_token_changeset(%{token: token})
    |> Repo.update()
  end
end
