# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ScorifyElixir.Repo.insert!(%ScorifyElixir.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ScorifyElixir.Sports

{:ok, sport} = Sports.create_sport(%{name: "Football", team: true})

{:ok, team1} = sport |> Sports.create_side(%{name: "FC Choroszcz"})
{:ok, team2} = sport |> Sports.create_side(%{name: "Reduta Bisztynek"})
{:ok, team3} = sport |> Sports.create_side(%{name: "Mexicano FC"})
{:ok, team4} = sport |> Sports.create_side(%{name: "Topkek Football Club"})

{:ok, league1} = sport |> Sports.create_league(%{name: "President League"})
{:ok, league2} = sport |> Sports.create_league(%{name: "The Championship"})
{:ok, league3} = sport |> Sports.create_league(%{name: "League One"})

created_seasons =
  [league1, league2, league3]
  |> Enum.map(fn league ->
    {:ok, season_current} =
      league |> Sports.create_league_season(%{start_date: "2018-08-01", end_date: "2019-04-30"})

    {:ok, season_past} =
      league |> Sports.create_league_season(%{start_date: "2017-08-01", end_date: "2018-04-30"})

    {league, [current: season_current, past: season_past]}
  end)
  |> Map.new()

team1 |> Sports.add_side_to_league_season(league_season: created_seasons[league1][:current])
team2 |> Sports.add_side_to_league_season(league_season: created_seasons[league1][:current])
team1 |> Sports.add_side_to_league_season(league_season: created_seasons[league1][:past])
team3 |> Sports.add_side_to_league_season(league_season: created_seasons[league1][:past])

team2 |> Sports.add_side_to_league_season(league_season: created_seasons[league2][:current])
team3 |> Sports.add_side_to_league_season(league_season: created_seasons[league2][:current])
team1 |> Sports.add_side_to_league_season(league_season: created_seasons[league2][:past])
team2 |> Sports.add_side_to_league_season(league_season: created_seasons[league2][:past])

team1 |> Sports.add_side_to_league_season(league_season: created_seasons[league3][:current])
team3 |> Sports.add_side_to_league_season(league_season: created_seasons[league3][:current])
team2 |> Sports.add_side_to_league_season(league_season: created_seasons[league3][:past])
team3 |> Sports.add_side_to_league_season(league_season: created_seasons[league3][:past])

{:ok, basketball} = Sports.create_sport(%{name: "Basketball", team: true})

{:ok, tennis} = Sports.create_sport(%{name: "Tennis", team: false})
