defmodule ScorifyElixirWeb.Sports.SideResolver do
  import ScorifyElixir.Sports
  require Ecto.Query

  def all(%{sport_id: sport_id}, _info) do
    {:ok, list_leagues(get_sport!(sport_id)) }
  end

  def all(%{league_id: league_id}, _info) do
    {:ok, get_league!(league_id) |> list_league_sides }
  end
end
