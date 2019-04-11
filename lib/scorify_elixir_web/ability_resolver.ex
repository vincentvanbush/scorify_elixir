defmodule ScorifyElixirWeb.AbilityResolver do
  use AbsintheCantare.AbilityResolver,
    repo: ScorifyElixir.Repo,
    abilities: ScorifyElixirWeb.Abilities,
    user_schema: ScorifyElixir.Auth.User,
    after: [&ScorifyElixirWeb.SafeResolver.safely/1]
end
