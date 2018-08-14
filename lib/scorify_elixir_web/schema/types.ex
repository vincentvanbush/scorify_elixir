defmodule ScorifyElixirWeb.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: ScorifyElixir.Repo

  object :sport do
    field(:id, :id)
    field(:name, :string)
    field(:team, :boolean)
    field(:sides, list_of(:side), resolve: assoc(:sides))
    field(:leagues, list_of(:league), resolve: assoc(:leagues))
  end

  object :league do
    field(:id, :id)
    field(:name, :string)
    field(:sport, :sport, resolve: assoc(:sport))
    field(:league_seasons, list_of(:league_season), resolve: assoc(:league_seasons))
    field(:sides, list_of(:side)) do
      resolve assoc(:sides, &ScorifyElixirWeb.Sports.LeagueResolver.current_sides/3)
    end
  end

  object :side do
    field(:id, :id)
    field(:name, :string)
    field(:sport, :sport, resolve: assoc(:sport))
    field(:location, :location, resolve: assoc(:location))
    field(:league_seasons, list_of(:league_season), resolve: assoc(:league_seasons))
  end

  object :league_season do
    field(:id, :id)
    field(:name, :string)
    field(:start_date, :string)
    field(:end_date, :string)
    field(:sides, list_of(:side), resolve: assoc(:sides))
  end

  object :location do
    field(:id, :id)
    field(:entered_name, :string)
    field(:full_name, :string)
    field(:lng, :string)
    field(:lat, :string)
    field(:locality, :string)
    field(:street_address, :string)
    field(:sides, list_of(:side), resolve: assoc(:sides))
  end
end
