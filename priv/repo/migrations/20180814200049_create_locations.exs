defmodule ScorifyElixir.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :full_name, :string
      add :entered_name, :string
      add :lat, :decimal
      add :lng, :decimal
      add :locality, :string
      add :street_address, :string


      timestamps()
    end

  end
end
