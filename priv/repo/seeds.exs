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

Sports.create_sport(%{name: "Football", team: true})
Sports.create_sport(%{name: "Basketball", team: true})
Sports.create_sport(%{name: "Tennis", team: false})
