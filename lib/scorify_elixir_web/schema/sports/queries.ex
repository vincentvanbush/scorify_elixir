defmodule ScorifyElixirWeb.Schema.Sports.Queries do
  alias ScorifyElixirWeb.Sports
  import Absinthe.Ecto.SafeResolver
  alias Absinthe.Cantare.AbilityResolver

  @doc false
  defmacro __using__(_opts) do
    quote do
      field :sport, :sport do
        arg(:id, non_null(:id))
        resolve(safely(&Sports.SportResolver.find/2))
      end

      field :sports, list_of(:sport) do
        # resolve(safely(&Sports.SportResolver.all/2))
        resolve(
          AbilityResolver.list_authorize(
            &Sports.SportResolver.all/2,
            ability: :show
          )
        )
      end

      field :league, :league do
        arg(:id, non_null(:id))
        resolve(safely(&Sports.LeagueResolver.find/2))
      end

      field :leagues, list_of(:league) do
        arg(:sport_id, non_null(:id))
        resolve(safely(&Sports.LeagueResolver.all/2))
      end

      field :side, :side do
        arg(:id, non_null(:id))
        resolve(safely(&Sports.SideResolver.find/2))
      end
    end
  end
end
