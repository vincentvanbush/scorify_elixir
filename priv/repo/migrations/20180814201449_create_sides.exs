defmodule ScorifyElixir.Repo.Migrations.CreateSides do
  use Ecto.Migration

  def change do
    create table(:sides) do
      add :name, :string
      add :sport_id, references(:sports, on_delete: :nothing)
      add :location_id, references(:locations, on_delete: :nothing)

      timestamps()
    end

    create index(:sides, [:sport_id])
    create index(:sides, [:location_id])
  end
end
