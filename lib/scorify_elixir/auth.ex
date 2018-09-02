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
end
