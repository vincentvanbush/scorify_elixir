defmodule ScorifyElixir.SportsTest do
  use ExUnit.Case
  use ScorifyElixir.DataCase
  alias ScorifyElixir.Sports

  alias ScorifyElixir.Sports.Sport

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
      assert %Sport{id: sport_id} = Sports.get_sport(sport_id)
    end

    test "returns nil for nonexistent record" do
      assert(nil == Sports.get_sport(9999))
    end
  end

  describe "create_sport" do
    test "creates new sport" do
      assert {:ok, sport = %{id: sport_id}} = Sports.create_sport(%{name: "Basketball", team: true})
      assert sport_id != nil
    end

    test "does not create new sport if already exists" do
      %{sport: sport} = SportsTest.create_sport()
      assert {:error, _} = Sports.create_sport(%{name: sport.name})
    end
  end

  describe "get_league" do

  end

  describe "list_leagues" do

  end

  describe "list_league_sides" do

  end

  describe "get_side" do

  end

  describe "league_last_season" do

  end

  describe "current_side_leagues" do

  end

  describe "list_sport_sides" do

  end

  describe "create_league" do

  end

  describe "add_side_to_league" do

  end

  describe "add_side_to_league_season" do

  end

  describe "create_league_season" do

  end

  # Named setups

  def create_sport(context \\ %{}) do
    {:ok, sport} = Sports.create_sport(%{name: "Tennis"})
    context |> Map.put(:sport, sport)
  end
end
