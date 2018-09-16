defmodule ScorifyElixirWeb.AbilityResolver do
  use Absinthe.Cantare.AbilityResolver,
    repo: ScorifyElixir.Repo,
    abilities: ScorifyElixirWeb.Abilities,
    user_schema: ScorifyElixir.Auth.User,
    after: [&Absinthe.Ecto.SafeResolver.safely/1]
end
