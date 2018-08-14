defmodule ScorifyElixir.Repo.Migrations.CreateLeagues do
  use Ecto.Migration

  def change do
    create table(:leagues) do
      add :name, :string
      add :sport_id, references(:sports, on_delete: :nothing)

      timestamps()
    end

    create index(:leagues, [:sport_id])
  end
end
