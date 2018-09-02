defmodule ScorifyElixirWeb.Schema do
  use Absinthe.Schema

  require ScorifyElixirWeb.Schema.Auth
  require ScorifyElixirWeb.Schema.Sports

  query do
    use ScorifyElixirWeb.Schema.Auth
    use ScorifyElixirWeb.Schema.Sports
  end
end
