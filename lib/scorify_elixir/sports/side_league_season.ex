defmodule ScorifyElixir.Sports.SideLeagueSeason do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "sides_league_seasons" do
    belongs_to :side, ScorifyElixir.Sports.Side
    belongs_to :league_season, ScorifyElixir.Sports.LeagueSeason
  end

  @doc false
  def changeset(side, attrs \\ %{}) do
    side
    |> cast(attrs, [:side_id, :league_season_id])
    |> validate_required([:side, :league_season])
  end
end
