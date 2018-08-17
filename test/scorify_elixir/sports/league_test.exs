defmodule ScorifyElixir.Sports.LeagueTest do
  require IEx

  use ScorifyElixir.DataCase

  alias ScorifyElixir.Sports.{Sport, League, LeagueSeason}
  alias ScorifyElixir.Repo

  @valid_attrs %{name: "00jor League Soccer", sport_id: 1}
  @attrs_without_sport_id %{name: "00jor League Soccer"}
  @attrs_without_name %{sport_id: 1}

  setup do
    create_league =
      fn (attrs = %{}) ->
        %League{} |> League.changeset(attrs) |> Repo.insert
      end

    sport =
      %Sport{name: "Football", team: true} |> Repo.insert!

    {
      :ok,
      create_league: create_league,
      sport: sport
    }
  end

  test "changeset with valid attributes" do
    changeset = %League{} |> League.changeset(@valid_attrs)
    assert changeset.valid?
  end

  test "changeset without sport_id" do
    changeset = %League{} |> League.changeset(@attrs_without_sport_id)
    refute changeset.valid?
  end

  test "changeset without name" do
    changeset = %League{} |> League.changeset(@attrs_without_name)
    refute changeset.valid?
  end

  test "changeset with name that already exists for the same sport", %{sport: sport, create_league: create_league} do
    other_sport = %Sport{name: "Basketball", team: true} |> Repo.insert!
    {:ok, _} = create_league.(%{@valid_attrs | sport_id: sport.id})

    assert {:error, _} = create_league.(%{@valid_attrs | sport_id: sport.id})
    assert {:ok, _} = create_league.(%{@valid_attrs | sport_id: other_sport.id})
  end

  test "has many :league_seasons", %{sport: sport, create_league: create_league} do
    {:ok, league} = create_league.(%{@valid_attrs | sport_id: sport.id})
    league_season =
      %LeagueSeason{}
      |> LeagueSeason.changeset(%{league_id: league.id, start_date: "2018-05-15", end_date: "2019-03-15"})
      |> Repo.insert!
    league_season_id = league_season.id
    assert %LeagueSeason{id: ^league_season_id} = league |> assoc(:league_seasons) |> Repo.one
  end
end
