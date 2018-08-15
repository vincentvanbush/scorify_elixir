defmodule ScorifyElixirWeb.Schema do
  use Absinthe.Schema
  import_types(ScorifyElixirWeb.Schema.Types)
  alias ScorifyElixirWeb.Sports

  query do
    field :sports, list_of(:sport) do
      resolve(&Sports.SportResolver.all/2)
    end

    field :leagues, list_of(:league) do
      arg(:sport_id, non_null(:id))
      resolve(&Sports.LeagueResolver.all/2)
    end

    field :sides, list_of(:side) do
      arg(:sport_id, :id)
      arg(:league_id, :id)
      resolve(&Sports.SideResolver.all/2)
    end

    mutation do

    end
  end
end
