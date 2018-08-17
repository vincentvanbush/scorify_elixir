defmodule ScorifyElixirWeb.Sports.SportResolver do
  alias ScorifyElixir.Sports

  def all(_args, _info) do
    {:ok, Sports.list_sports()}
  end

  def find(%{id: id}, _info) do
    {:ok, Sports.get_sport(id)}
  end

  @doc """
  Used as Absinthe mutation middleware so that a Sport struct can be
  seen as a parent by a resolver function.
  """
  def set_parent_sport(resolution = %{arguments: %{sport_id: sport_id}}, _) do
    sport = Sports.get_sport(sport_id)
    resolution |> Map.put(:source, sport)
  end
end
