defmodule ScorifyElixirWeb.Schema.Sports.Mutations do
  alias ScorifyElixirWeb.Sports
  import AbsintheCantare.SafeResolver
  import ScorifyElixirWeb.AbilityResolver

  @doc false
  defmacro __using__(_opts) do
    quote do
      @desc "Create a league in a sport"
      field :create_league, type: :league do
        arg(:name, non_null(:string))
        arg(:sport_id, non_null(:id))

        middleware(&Sports.SportResolver.set_parent_sport/2)

        resolve(safely(&Sports.LeagueResolver.create/3))
      end

      @desc "Create a league season"
      field :create_league_season, type: :league_season do
        arg(:league_id, non_null(:id))
        arg(:name, :string)
        arg(:start_date, non_null(:string))
        arg(:end_date, non_null(:string))

        middleware(&Sports.LeagueResolver.set_parent_league/2)

        resolve(safely(&Sports.LeagueSeasonResolver.create/3))
      end

      @desc "Update a league season"
      field :update_league_season, type: :league_season do
        arg(:id, non_null(:id))
        arg(:params, non_null(:update_league_season_params))
      end

      @desc "Create a side in a sport"
      field :create_side, type: :side do
        arg(:name, non_null(:string))
        arg(:sport_id, non_null(:id))

        middleware(&Sports.SportResolver.set_parent_sport/2)

        resolve(
          build_authorize_insert(
            &Sports.SideResolver.build/3,
            ability: :create
          )
        )
      end

      @desc "Add a side to a league"
      field :add_side_to_league, type: :league do
        arg(:side_id, non_null(:id))
        arg(:league_id, non_null(:id))
        arg(:league_season_id, :id)

        middleware(&Sports.SideResolver.set_parent_side/2)

        resolve(safely(&Sports.SideResolver.add_to_league/3))
      end
    end
  end
end
