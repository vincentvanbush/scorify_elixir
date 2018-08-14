defmodule ScorifyElixir.Repo.Migrations.CreateSidesLeagueSeasons do
  use Ecto.Migration

  def change do
    create table(:sides_league_seasons) do
      add :side_id, references(:sides)
      add :league_season_id, references(:league_seasons)
    end

    create unique_index(:sides_league_seasons, [:side_id, :league_season_id])
  end
end
