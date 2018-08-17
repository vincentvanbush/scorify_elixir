defmodule ScorifyElixir.Repo.Migrations.AddUniqueConstraintsToTables do
  use Ecto.Migration

  def up do
    execute "UPDATE sports SET name = CONCAT(name, '(', id, ')') WHERE (SELECT COUNT(1) FROM sports s WHERE sports.name = s.name) > 1;"
    execute "UPDATE sides SET name = CONCAT(name, '(', id, ')') WHERE (SELECT COUNT(1) FROM sides s WHERE sides.name = s.name) > 1;"
    execute "UPDATE leagues SET name = CONCAT(name, '(', id, ')') WHERE (SELECT COUNT(1) FROM leagues l WHERE leagues.name = l.name AND leagues.sport_id = l.sport_id) > 1;"
    execute "UPDATE league_seasons SET name = concat(name, '(', id, ')') WHERE (SELECT COUNT(1) FROM league_seasons l WHERE league_seasons.name = l.name AND league_seasons.league_id = l.league_id) > 1;"

    create unique_index(:sports, [:name])
    create unique_index(:leagues, [:sport_id, :name])
    create unique_index(:sides, [:sport_id, :name])
    create unique_index(:league_seasons, [:league_id, :name])
  end

  def down do
    drop unique_index(:sports, [:name])
    drop unique_index(:leagues, [:sport_id, :name])
    drop unique_index(:sides, [:sport_id, :name])
    drop unique_index(:league_seasons, [:league_id, :name])
  end
end
