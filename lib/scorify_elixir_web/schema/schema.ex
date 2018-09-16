defmodule ScorifyElixirWeb.Schema do
  use Absinthe.Schema

  require ScorifyElixirWeb.Schema.Auth.{Queries, Mutations}
  require ScorifyElixirWeb.Schema.Sports.{Queries, Mutations}
  require ScorifyElixirWeb.AbilityResolver

  import_types(ScorifyElixirWeb.Schema.Sports.Types)
  import_types(ScorifyElixirWeb.Schema.Auth.Types)

  query do
    use ScorifyElixirWeb.Schema.Auth.Queries
    use ScorifyElixirWeb.Schema.Sports.Queries
  end

  mutation do
    use ScorifyElixirWeb.Schema.Auth.Mutations
    use ScorifyElixirWeb.Schema.Sports.Mutations
  end
end
