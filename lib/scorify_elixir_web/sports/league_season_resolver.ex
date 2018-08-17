defmodule ScorifyElixirWeb.Sports.LeagueSeasonResolver do
  import ScorifyElixir.Sports
  require Ecto.Query

  def create(league, attrs = %{}, _info) do
    league |> create_league_season(attrs)
  end
end
