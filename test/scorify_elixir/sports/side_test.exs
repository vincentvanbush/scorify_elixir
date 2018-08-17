defmodule ScorifyElixir.Sports.SideTest do
  use ExUnit.Case
  use ScorifyElixir.DataCase

  alias ScorifyElixir.Sports.{Sport, Side, League, LeagueSeason, SideLeagueSeason}
  alias ScorifyElixir.Repo

  @valid_attrs %{name: "Mexico FC", sport_id: 1}
  @attrs_without_sport_id %{name: "Mexico FC"}
  @attrs_without_name %{sport_id: 1}

  setup do
    create_side! =
      fn (attrs = %{}) ->
        %Side{} |> Side.changeset(attrs) |> Repo.insert!
      end

    sport =
      %Sport{name: "Football", team: true} |> Repo.insert!

    create_side_with_league_season! =
      fn ->
        side = create_side!.(%{@valid_attrs | sport_id: sport.id})
        league = sport |> build_assoc(:leagues, %{name: "00jor League Soccer"}) |> Repo.insert!
        league_season = league |> build_assoc(:league_seasons) |> LeagueSeason.changeset(%{start_date: "2018-08-15", end_date: "2019-05-15"}) |> Repo.insert!
        %SideLeagueSeason{side_id: side.id, league_season_id: league_season.id} |> Repo.insert!
        {side, league_season}
      end

    {
      :ok,
      create_side!: create_side!,
      create_side_with_league_season!: create_side_with_league_season!,
      sport: sport
    }
  end

  test "changeset with valid attributes" do
    changeset = %Side{} |> Side.changeset(@valid_attrs)
    assert changeset.valid?
  end

  test "changeset without sport_id" do
    changeset = %Side{} |> Side.changeset(@attrs_without_sport_id)
    refute changeset.valid?
  end

  test "changeset without name" do
    changeset = %Side{} |> Side.changeset(@attrs_without_name)
    refute changeset.valid?
  end

  test "changeset with name that already exists for the same sport", %{sport: sport, create_side!: create_side!} do
    other_sport = %Sport{name: "Basketball", team: true} |> Repo.insert!
    create_side!.(%{@valid_attrs | sport_id: sport.id})

    assert {:error, _} = %Side{} |> Side.changeset(%{@valid_attrs | sport_id: sport.id}) |> Repo.insert
    assert {:ok, _} = %Side{} |> Side.changeset(%{@valid_attrs | sport_id: other_sport.id}) |> Repo.insert
  end

  test "belongs to :sport", %{sport: sport, create_side!: create_side!} do
    side = create_side!.(%{@valid_attrs | sport_id: sport.id})
    assert %Sport{} = side |> assoc(:sport) |> Repo.one
  end

  test "has many :league_seasons", %{create_side_with_league_season!: create_side_with_league_season!} do
    {side, %LeagueSeason{id: league_season_id}} = create_side_with_league_season!.()
    assert [%LeagueSeason{id: ^league_season_id} | []] = side |> assoc(:league_seasons) |> Repo.all
  end

  test "has many :leagues", %{create_side_with_league_season!: create_side_with_league_season!} do
    {side, league_season} = create_side_with_league_season!.()
    %{league_id: league_id} = league_season
    assert [%League{id: ^league_id} | []] = side |> assoc(:leagues) |> Repo.all
  end
end
