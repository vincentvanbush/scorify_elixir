defmodule ScorifyElixirWeb.Schema.Sports.Queries do
  alias ScorifyElixirWeb.Sports.{SportResolver, LeagueResolver, SideResolver}
  import AbsintheCantare.SafeResolver
  import ScorifyElixirWeb.AbilityResolver

  @doc false
  defmacro __using__(_opts) do
    quote do
      field :sport, :sport do
        arg(:id, non_null(:id))
        resolve(safely(&SportResolver.find/2))
      end

      field :sports, list_of(:sport) do
        resolve(
          list_authorize(
            &SportResolver.all/2,
            ability: :show,
            schema: ScorifyElixir.Sports.Sport
          )
        )
      end

      field :league, :league do
        arg(:id, non_null(:id))
        resolve(safely(&LeagueResolver.find/2))
      end

      field :leagues, list_of(:league) do
        arg(:sport_id, non_null(:id))
        resolve(safely(&LeagueResolver.all/2))
      end

      field :side, :side do
        arg(:id, non_null(:id))
        resolve(safely(&SideResolver.find/2))
      end
    end
  end
end
