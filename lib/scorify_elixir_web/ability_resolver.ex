defmodule ScorifyElixirWeb.AbilityResolver do
  use Absinthe.Cantare.AbilityResolver,
    repo: ScorifyElixir.Repo,
    abilities: ScorifyElixirWeb.Abilities,
    after: [&Absinthe.Ecto.SafeResolver.safely/1]
end
