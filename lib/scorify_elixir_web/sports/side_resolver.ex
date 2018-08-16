defmodule ScorifyElixirWeb.Sports.SideResolver do
  import ScorifyElixir.Sports
  require Ecto.Query

  def all(league = %ScorifyElixir.Sports.League{}, _, _) do
    {:ok, league |> list_league_sides}
  end

  def create(%{name: name, sport_id: sport_id}, _info) do
    sport = get_sport!(sport_id)
    {:ok, sport |> create_side(name: name)}
  end
end
