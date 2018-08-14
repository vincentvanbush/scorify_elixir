defmodule ScorifyElixir.Repo.Migrations.CreateLeagueSeasons do
  use Ecto.Migration

  def change do
    create table(:league_seasons) do
      add :name, :string
      add :start_date, :date
      add :end_date, :date
      add :league_id, references(:leagues, on_delete: :nothing)

      timestamps()
    end

    create index(:league_seasons, [:league_id])
  end
end
