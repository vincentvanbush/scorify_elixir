defmodule ScorifyElixir.SportsTest do
  use ExUnit.Case
  use ScorifyElixir.DataCase
  alias ScorifyElixir.Sports

  alias ScorifyElixir.Sports.{Sport, League, LeagueSeason, Side, SideLeagueSeason}

  alias ScorifyElixir.SportsTest

  describe "list_sports" do
    setup [:create_sport]

    test "lists all existing sports", %{sport: %Sport{id: sport_id}} do
      assert [%Sport{id: ^sport_id} | _] = Sports.list_sports()
    end
  end

  describe "get_sport" do
    setup [:create_sport]

    test "returns existing sport", %{sport: %Sport{id: sport_id}} do
      assert %Sport{id: ^sport_id} = Sports.get_sport(sport_id)
    end

    test "returns nil for nonexistent record" do
      assert(nil == Sports.get_sport(9999))
    end
  end

  describe "create_sport" do
    test "creates new sport" do
      assert {:ok, %{id: sport_id}} = Sports.create_sport(%{name: "Basketball", team: true})
      assert sport_id != nil
    end

    test "does not create new sport if already exists" do
      %{sport: sport} = SportsTest.create_sport()
      assert {:error, _} = Sports.create_sport(%{name: sport.name})
    end
  end

  describe "get_league" do
    setup [:create_league]

    test "returns existing league", %{league: %League{id: league_id}} do
      assert %League{id: ^league_id} = Sports.get_league(league_id)
    end

    test "returns nil for nonexistent record" do
      assert(nil == Sports.get_league(9999))
    end
  end

  describe "list_leagues" do
    setup [:create_league]

    test "returns list of existing leagues", %{league: %League{id: league_id}} do
      assert [%League{id: ^league_id} | []] = Sports.list_leagues()
    end
  end

  describe "list_league_sides" do
    setup [
      :create_league,
      :create_sport_side,
      :create_league_current_season,
      :create_league_side_current_season
    ]

    test "returns list of sides in current league season", %{
      league: %League{} = league,
      side: %Side{id: side_id}
    } do
      assert [%Side{id: ^side_id} | []] = league |> Sports.list_league_sides()
    end
  end

  describe "get_side" do
    setup [:create_league, :create_sport_side]

    test "returns existing side", %{side: %Side{id: side_id}} do
      assert %Side{id: ^side_id} = Sports.get_side(side_id)
    end

    test "returns nil for nonexistent record", %{side: %Side{}} do
      assert(nil == Sports.get_side(9999))
    end
  end

  describe "league_current_season" do
    setup [
      :create_league,
      :create_league_current_season,
      :create_league_future_season,
      :create_league_past_season
    ]

    test "returns current league season", %{
      league: league,
      current_league_season: %LeagueSeason{id: current_league_season_id},
      past_league_season: _,
      future_league_season: _
    } do
      assert %LeagueSeason{id: ^current_league_season_id} =
               league |> Sports.league_current_season()
    end

    test "returns league season that has just ended if no next season was created", %{
      league: league,
      current_league_season: %LeagueSeason{start_date: d} = current_league_season
    } do
      {:ok, new_end_date} = Date.new(d.year, d.month, d.day + 1)

      %LeagueSeason{id: updated_season_id} =
        current_league_season |> LeagueSeason.changeset(%{end_date: new_end_date})
        |> ScorifyElixir.Repo.update!()

      assert %LeagueSeason{id: ^updated_season_id} = league |> Sports.league_current_season()
    end
  end

  describe "current_side_leagues" do
    setup [
      :create_league,
      :create_league_current_season,
      :create_league_future_season,
      :create_league_past_season,
      :create_sport_side
    ]

    test "returns league for side if side enrolled in current season",
         context = %{league: %League{id: league_id}} do
      %{league: %{id: ^league_id}, side: side} = create_league_side_current_season(context)
      assert [%League{id: ^league_id} | []] = Sports.current_side_leagues(side)
    end

    test "does not return league for side if side enrolled in past season",
         context = %{league: %League{id: league_id}} do
      %{league: %{id: ^league_id}, side: side} = create_league_side_past_season(context)
      assert [] = Sports.current_side_leagues(side)
    end

    test "does not return league for side if side enrolled in future season",
         context = %{league: %League{id: league_id}} do
      %{league: %{id: ^league_id}, side: side} = create_league_side_future_season(context)
      assert [] = Sports.current_side_leagues(side)
    end
  end

  describe "list_sport_sides" do
    setup [:create_sport, :create_other_sport, :create_sport_side, :create_other_side]

    test "returns list of sides in given sport", %{
      sport: sport,
      other_sport: _,
      side: %Side{id: side_id},
      other_side: %Side{}
    } do
      assert [%Side{id: ^side_id} | []] = Sports.list_sport_sides(sport)
    end
  end

  describe "create_league" do
    setup [:create_sport]

    test "creates a league in a sport", %{sport: sport} do
      assert {:ok, %League{id: _}} = sport |> Sports.create_league(%{name: "Major League Soccer"})
    end

    test "does not create a league with invalid attrs", %{sport: sport} do
      assert {:error, %Ecto.Changeset{}} = sport |> Sports.create_league(%{name: ""})
    end
  end

  describe "add_side_to_league" do
    setup [:create_sport, :create_league, :create_sport_side]

    test "does not add side to league when no season is created", %{league: league, side: side} do
      assert {:error, :no_season} = side |> Sports.add_side_to_league(league: league)
    end

    test "adds side to last league season", context = %{league: league, side: side} do
      %{current_league_season: %LeagueSeason{id: current_league_season_id}, past_league_season: _} =
        context
        |> create_league_current_season()
        |> create_league_past_season()

      assert {:ok, %SideLeagueSeason{league_season_id: ^current_league_season_id}} =
               side |> Sports.add_side_to_league(league: league)
    end
  end

  describe "add_side_to_league_season" do
    setup [:create_sport, :create_league, :create_sport_side, :create_league_future_season]

    test "adds side to specific league season", %{
      side: side,
      future_league_season: %LeagueSeason{id: future_league_season_id} = future_league_season
    } do
      assert {:ok, %SideLeagueSeason{league_season_id: future_league_season_id}} =
               side |> Sports.add_side_to_league_season(league_season: future_league_season)
    end
  end

  describe "create_league_season" do
    setup [:create_sport, :create_league]

    test "creates specific league season with automatically filled name", %{
      sport: sport,
      league: %League{id: league_id} = league
    } do
      assert {:ok, %LeagueSeason{league_id: league_id, name: "2015/2016"}} =
               league
               |> Sports.create_league_season(%{start_date: "2015-07-10", end_date: "2016-05-10"})
    end

    test "creates specific league season with manually set name", %{
      sport: sport,
      league: %League{id: league_id} = league
    } do
      assert {:ok, %LeagueSeason{league_id: league_id, name: "Cucumber Season"}} =
               league
               |> Sports.create_league_season(%{name: "Cucumber Season", start_date: "2015-07-10", end_date: "2016-05-10"})
    end
  end

  # Named setups

  def create_sport(context \\ %{}) do
    {:ok, sport} = Sports.create_sport(%{name: "Tennis"})
    context |> Map.put(:sport, sport)
  end

  def create_other_sport(context \\ %{}) do
    {:ok, sport} = Sports.create_sport(%{name: "Basketball", team: true})
    context |> Map.put(:other_sport, sport)
  end

  def create_league(context \\ %{})

  def create_league(context = %{sport: %Sport{} = sport}) do
    {:ok, league} = sport |> Sports.create_league(%{name: "Ekstraklasa"})
    context |> Map.put(:league, league)
  end

  def create_league(context) do
    {:ok, sport} = Sports.create_sport(%{name: "Chess"})
    create_league(context |> Map.put(:sport, sport))
  end

  defp create_league_season(context = %{league: %League{} = league}, start_date, end_date, as: as) do
    {:ok, league_season} =
      league
      |> Sports.create_league_season(%{
        start_date: start_date,
        end_date: end_date
      })

    context |> Map.put(as, league_season)
  end

  def create_league_current_season(context = %{league: %League{}}) do
    today = Date.utc_today()
    {:ok, month_begin} = Date.new(today.year, today.month, 1)
    {:ok, next_year_month_before} = Date.new(month_begin.year + 1, today.month - 1, 1)

    context
    |> create_league_season(
      month_begin |> Date.to_string(),
      next_year_month_before |> Date.to_string(),
      as: :current_league_season
    )
  end

  def create_league_future_season(context = %{league: %League{}}) do
    today = Date.utc_today()
    {:ok, month_begin} = Date.new(today.year + 1, today.month, 1)
    {:ok, next_year_month_before} = Date.new(month_begin.year + 2, today.month - 1, 1)

    context
    |> create_league_season(
      month_begin |> Date.to_string(),
      next_year_month_before |> Date.to_string(),
      as: :future_league_season
    )
  end

  def create_league_past_season(context = %{league: %League{}}) do
    today = Date.utc_today()
    {:ok, month_begin} = Date.new(today.year - 1, today.month, 1)
    {:ok, next_year_month_before} = Date.new(month_begin.year, today.month - 1, 1)

    context
    |> create_league_season(
      month_begin |> Date.to_string(),
      next_year_month_before |> Date.to_string(),
      as: :past_league_season
    )
  end

  def create_sport_side(context = %{sport: %Sport{} = sport}) do
    {:ok, side} = sport |> Sports.create_side(%{name: "Ebin"})
    context |> Map.put(:side, side)
  end

  def create_other_side(context = %{other_sport: %Sport{} = sport}) do
    {:ok, other_side} = sport |> Sports.create_side(%{name: "Ebin"})
    context |> Map.put(:other_side, other_side)
  end

  def create_league_side_current_season(
        context = %{
          side: %Side{} = side,
          current_league_season: %LeagueSeason{} = current_league_season
        }
      ) do
    {:ok, _} = side |> Sports.add_side_to_league_season(league_season: current_league_season)
    context
  end

  def create_league_side_past_season(
        context = %{
          side: %Side{} = side,
          past_league_season: %LeagueSeason{} = past_league_season
        }
      ) do
    {:ok, _} = side |> Sports.add_side_to_league_season(league_season: past_league_season)
    context
  end

  def create_league_side_future_season(
        context = %{
          side: %Side{} = side,
          future_league_season: %LeagueSeason{} = future_league_season
        }
      ) do
    {:ok, _} = side |> Sports.add_side_to_league_season(league_season: future_league_season)
    context
  end
end
