defmodule ScorifyElixir.Sports do
  alias ScorifyElixir.Repo
  alias ScorifyElixir.Sports.{Sport, League}
  import Ecto
  require Ecto.Query
  import Ecto.Query

  def list_sports do
    Sport |> Repo.all
  end

  def get_sport!(id) do
    Sport |> Repo.get!(id)
  end

  def create_sport(attrs \\ %{}) do
    %Sport{}
    |> Sport.changeset(attrs)
    |> Repo.insert!()
  end

  def get_league!(id) do
    League |> Repo.get!(id)
  end

  def list_leagues do
    League |> Repo.all
  end

  def list_leagues(sport) do
    assoc(sport, :leagues) |> Repo.all
  end

  def list_league_sides(league) do
    league_seasons_query = league |> assoc(:league_seasons)
    last_season_query =
      from l in league_seasons_query,
      where: l.start_date <= from_now(0, "day"),
      order_by: [desc: :start_date],
      limit: 1
    last_season = last_season_query |> Repo.one!
    last_season |> assoc(:sides) |> Repo.all
  end

  def list_sport_sides(sport) do
    sport |> assoc(:sides) |> Repo.all
  end

  def create_league(sport, attrs \\ %{}) do
    sport |> build_assoc(:leagues, attrs) |> Repo.insert!
  end
end
