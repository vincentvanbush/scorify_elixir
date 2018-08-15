defmodule ScorifyElixirWeb.Sports.SideResolver do
  import ScorifyElixir.Sports
  require Ecto.Query

  def all(league = %ScorifyElixir.Sports.League{}, _, _) do
    {:ok, league |> list_league_sides}
  end
end
