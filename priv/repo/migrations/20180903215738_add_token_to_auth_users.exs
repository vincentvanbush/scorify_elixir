defmodule ScorifyElixir.Repo.Migrations.AddTokenToAuthUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :token, :text
    end
  end
end
