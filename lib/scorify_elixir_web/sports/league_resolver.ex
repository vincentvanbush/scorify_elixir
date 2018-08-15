defmodule ScorifyElixirWeb.Sports.LeagueResolver do
  alias ScorifyElixir.Sports
  require Ecto.Query

  def all(%{sport_id: sport_id}, _info) do
    {:ok, Sports.list_leagues(Sports.get_sport!(sport_id)) }
  end

  def find(%{id: id}, _info) do
    {:ok, Sports.get_league!(id)}
  end

  def current_sides(sides_query, _args, _context) do
    Ecto.Query.from(s in sides_query,
                    where: fragment(
                      "NOT EXISTS (SELECT 1 FROM league_seasons AS _ls WHERE _ls.start_date > l1.start_date)"
                    ))
  end
end
