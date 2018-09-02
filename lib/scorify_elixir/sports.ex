defmodule ScorifyElixir.Sports do
  alias ScorifyElixir.Repo

  alias ScorifyElixir.Sports.{
    Sport,
    League,
    Side,
    LeagueSeason,
    SideLeagueSeason,
    Player,
    PlayerSide
  }

  import Ecto
  import Ecto.{Query, Changeset}
  require Ecto.Query

  def list_sports do
    Sport |> Repo.all()
  end

  def get_sport(id) do
    Sport |> Repo.get(id)
  end

  def create_sport(attrs \\ %{}) do
    %Sport{}
    |> Sport.changeset(attrs)
    |> Repo.insert()
  end

  def get_league(id) do
    League |> Repo.get(id)
  end

  def list_leagues do
    League |> Repo.all()
  end

  def list_leagues(sport = %Sport{}) do
    assoc(sport, :leagues) |> Repo.all()
  end

  def list_league_sides(league = %League{}) do
    last_season = league |> league_current_season

    case last_season do
      %LeagueSeason{} ->
        last_season |> assoc(:sides) |> Repo.all()

      nil ->
        []

      _ ->
        raise "fug"
    end
  end

  def get_side(id) do
    Side |> Repo.get(id)
  end

  def league_current_season(league = %League{}) do
    league_seasons_query = league |> assoc(:league_seasons)

    last_season_query =
      from(
        l in league_seasons_query,
        where: l.start_date <= from_now(0, "day"),
        order_by: [desc: :start_date],
        limit: 1
      )

    last_season_query |> Repo.one()
  end

  def current_side_leagues(side = %Side{}) do
    league_seasons_query = side |> assoc(:league_seasons)

    query =
      from(
        league_season in league_seasons_query,
        join: league in assoc(league_season, :league),
        where:
          league_season.start_date <= from_now(0, "day") and
            league_season.end_date >= from_now(0, "day"),
        preload: [league: league]
      )

    league_seasons = query |> Repo.all()
    Enum.map(league_seasons, fn season -> season.league end)
  end

  def list_sport_sides(sport) do
    sport |> assoc(:sides) |> Repo.all()
  end

  def create_league(sport, attrs \\ %{}) do
    sport
    |> build_assoc(:leagues, attrs)
    |> League.changeset(%{})
    |> Repo.insert()
  end

  def update_league(league, attrs \\ %{}) do
    league
    |> League.changeset(attrs)
    |> Repo.update()
  end

  def create_side(sport = %Sport{}, attrs \\ %{}) do
    sport
    |> build_assoc(:sides, attrs)
    |> Side.changeset(%{})
    |> Repo.insert()
  end

  def update_side(side = %Side{}, attrs \\ %{}) do
    side
    |> Side.changeset(attrs)
    |> Repo.update()
  end

  def add_side_to_league(side = %Side{}, league: %League{} = league) do
    case league |> league_current_season do
      %LeagueSeason{} = last_season -> add_side_to_league_season(side, league_season: last_season)
      nil -> {:error, :no_season}
    end
  end

  def add_side_to_league_season(side = %Side{}, league_season: %LeagueSeason{} = league_season) do
    %SideLeagueSeason{}
    |> change
    |> put_assoc(:side, side)
    |> put_assoc(:league_season, league_season)
    |> SideLeagueSeason.changeset()
    |> Repo.insert()
  end

  def create_league_season(league, attrs = %{}) do
    season =
      league
      |> build_assoc(:league_seasons)
      |> LeagueSeason.changeset(attrs)

    season |> Repo.insert()
  end

  def update_league_season(league_season, attrs = %{}) do
    league_season
    |> LeagueSeason.changeset(attrs)
    |> Repo.update()
  end

  def add_player_to_side(side, player, league_season = %LeagueSeason{}) do
    add_player_to_side(side, player, league_season.start_date, league_season.end_date)
  end

  def add_player_to_side(side, player, from_date, until_date) do
    side
    |> build_assoc(:player_sides)
    |> PlayerSide.changeset(%{from_date: from_date, until_date: until_date})
    |> put_assoc(:player, player)
    |> Repo.insert()
  end

  def current_side_players(side = %Side{}) do
    side |> get_side_players_at_given_date(Date.utc_today)
  end

  def get_side_players_at_given_date(side = %Side{}, date) do
    Repo.all(
      from(
        player in Player,
        right_join: player_side in PlayerSide,
        on: [player_id: player.id],
        where: player_side.from_date <= ^date,
        where: player_side.until_date >= ^date,
        where: player_side.side_id == ^side.id,
        select: %{player: player, player_side: player_side}
      )
    )
  end
end
