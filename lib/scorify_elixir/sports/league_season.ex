defmodule ScorifyElixir.Sports.LeagueSeason do
  use Ecto.Schema
  import Ecto.Changeset


  schema "league_seasons" do
    field :end_date, :date
    field :name, :string
    field :start_date, :date

    belongs_to :league, ScorifyElixir.Sports.League
    many_to_many :sides, ScorifyElixir.Sports.Side, join_through: "sides_league_seasons"

    timestamps()
  end

  @doc false
  def changeset(league_season, attrs) do
    league_season
    |> cast(attrs, [:name, :start_date, :end_date])
    |> validate_required([:name, :start_date, :end_date])
  end
end
