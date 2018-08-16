defmodule ScorifyElixir.Sports do
  alias ScorifyElixir.Repo
  alias ScorifyElixir.Sports.{Sport, League, Side, LeagueSeason, SideLeagueSeason}
  import Ecto
  require Ecto.Query
  import Ecto.Query

  require IEx

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

  def list_leagues(sport = %Sport{}) do
    assoc(sport, :leagues) |> Repo.all
  end

  def list_league_sides(league = %League{}) do
    last_season = league |> league_last_season
    last_season |> assoc(:sides) |> Repo.all
  end

  def league_last_season(league = %League{}) do
    league_seasons_query = league |> assoc(:league_seasons)
    last_season_query =
      from l in league_seasons_query,
      where: l.start_date <= from_now(0, "day"),
      order_by: [desc: :start_date],
      limit: 1
    last_season_query |> Repo.one!
  end

  def list_sport_sides(sport) do
    sport |> assoc(:sides) |> Repo.all
  end

  def create_league(sport, attrs \\ %{}) do
    sport |> build_assoc(:leagues, attrs) |> Repo.insert!
  end

  def create_side(sport = %Sport{}, attrs \\ %{}) do
    sport
    |> build_assoc(:sides, attrs)
    |> Repo.insert!
  end

  def add_side_to_league(side = %Side{}, league: %League{} = league) do
    last_season = league |> league_last_season
    add_side_to_league_season(side, league_season: last_season)
  end

  def add_side_to_league_season(side = %Side{},
                                league_season: (%LeagueSeason{} = league_season)) do
    %SideLeagueSeason{}
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:side, side)
    |> Ecto.Changeset.put_assoc(:league_season, league_season)
    |> SideLeagueSeason.changeset
    |> Repo.insert!
    side
  end

  def create_league_season(league, attrs = %{}) do
    season =
      league
      |> build_assoc(:league_seasons)
      |> LeagueSeason.changeset(attrs)
    season |> Repo.insert!
  end
end
