defmodule ScorifyElixir.Repo.Migrations.CreateSports do
  use Ecto.Migration

  def change do
    create table(:sports) do
      add :name, :string
      add :team, :boolean, default: false, null: false

      timestamps()
    end

  end
end
