defmodule ScorifyElixirWeb.Schema.Auth.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: ScorifyElixir.Repo

  object :user do
    field(:id, :id)
  end
end
