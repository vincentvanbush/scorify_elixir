defmodule ScorifyElixir.Repo.Migrations.AddConstraintsToTables do
  use Ecto.Migration

  def change do
    drop constraint(:sides_league_seasons, "sides_league_seasons_league_season_id_fkey")
    drop constraint(:sides_league_seasons, "sides_league_seasons_side_id_fkey")

    alter table(:sides_league_seasons) do
      modify :league_season_id, references(:league_seasons, on_delete: :delete_all)
      modify :side_id, references(:sides, on_delete: :delete_all)
    end

    drop constraint(:sides, "sides_sport_id_fkey")

    alter table(:sides) do
      modify :sport_id, references(:sports, on_delete: :delete_all)
    end

    drop constraint(:leagues, "leagues_sport_id_fkey")

    alter table(:leagues) do
      modify :sport_id, references(:sports, on_delete: :delete_all)
    end

    drop constraint(:league_seasons, "league_seasons_league_id_fkey")

    alter table(:league_seasons) do
      modify :league_id, references(:leagues, on_delete: :delete_all)
    end

    execute "DELETE FROM sports WHERE name IS NULL;"
    execute "DELETE FROM sides WHERE name IS NULL OR sport_id IS NULL;"
    execute "DELETE FROM leagues WHERE name IS NULL OR sport_id IS NULL;"
    execute "DELETE FROM league_seasons WHERE name IS NULL OR league_id IS NULL OR start_date IS NULL OR end_date IS NULL;"
    execute "DELETE FROM sides_league_seasons WHERE side_id IS NULL OR league_season_id IS NULL;"

    alter table(:sports) do
      modify :name, :string, null: false
    end

    alter table(:sides) do
      modify :name, :string, null: false
      modify :sport_id, :id, null: false
    end

    alter table(:sides_league_seasons) do
      modify :side_id, :id, null: false
      modify :league_season_id, :id, null: false
    end

    alter table(:leagues) do
      modify :name, :string, null: false
      modify :sport_id, :id, null: false
    end

    alter table(:league_seasons) do
      modify :name, :string, null: false
      modify :league_id, :id, null: false
      modify :start_date, :date, null: false
      modify :end_date, :date, null: false
    end
  end
end
