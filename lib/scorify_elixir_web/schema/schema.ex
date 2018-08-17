defmodule ScorifyElixirWeb.Schema do
  use Absinthe.Schema
  Absinthe.Resolution
  import_types(ScorifyElixirWeb.Schema.Types)
  alias ScorifyElixirWeb.Sports
  import ScorifyElixirWeb.SafeResolver

  query do
    field :sport, :sport do
      arg(:id, non_null(:id))
      resolve safely(&Sports.SportResolver.find/2)
    end

    field :sports, list_of(:sport) do
      resolve safely(&Sports.SportResolver.all/2)
    end

    field :league, :league do
      arg(:id, non_null(:id))
      resolve safely(&Sports.LeagueResolver.find/2)
    end

    field :leagues, list_of(:league) do
      arg(:sport_id, non_null(:id))
      resolve safely(&Sports.LeagueResolver.all/2)
    end

    field :side, :side do
      arg(:id, non_null(:id))
      resolve safely(&Sports.SideResolver.find/2)
    end

    mutation do
      @desc "Create a league in a sport"
      field :create_league, type: :league do
        arg :name, non_null(:string)
        arg :sport_id, non_null(:id)

        middleware(&Sports.SportResolver.set_parent_sport/2)

        resolve safely(&Sports.LeagueResolver.create/3)
      end

      @desc "Create a league season"
      field :create_league_season, type: :league_season do
        arg :league_id, non_null(:id)
        arg :name, :string
        arg :start_date, non_null(:string)
        arg :end_date, non_null(:string)

        middleware(&Sports.LeagueResolver.set_parent_league/2)

        resolve safely(&Sports.LeagueSeasonResolver.create/3)
      end

      @desc "Create a side in a sport"
      field :create_side, type: :side do
        arg :name, non_null(:string)
        arg :sport_id, non_null(:id)

        middleware(&Sports.SportResolver.set_parent_sport/2)

        resolve safely(&Sports.SideResolver.create/3)
      end

      @desc "Add a side to a league"
      field :add_side_to_league, type: :league do
        arg :side_id, non_null(:id)
        arg :league_id, non_null(:id)
        arg :league_season_id, :id

        middleware(&Sports.SideResolver.set_parent_side/2)

        resolve safely(&Sports.SideResolver.add_to_league/3)
      end
    end
  end
end
