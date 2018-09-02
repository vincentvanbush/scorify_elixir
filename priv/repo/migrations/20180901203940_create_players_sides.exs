defmodule ScorifyElixir.Repo.Migrations.CreatePlayersSides do
  use Ecto.Migration

  def change do
    create table(:players_sides) do
      add :from_date, :date, null: false
      add :until_date, :date, null: false
      add :player_id, references(:players, on_delete: :nothing), null: false
      add :side_id, references(:sides, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:players_sides, [:player_id])
    create index(:players_sides, [:side_id])
  end
end
