defmodule ScorifyElixir.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :full_name, :string, null: false
      add :display_name, :string, null: false
      add :sport_id, references(:sports, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:players, [:sport_id])
  end
end
