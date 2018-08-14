defmodule ScorifyElixir.Sports.League do
  use Ecto.Schema
  import Ecto.Changeset


  schema "leagues" do
    field :name, :string

    belongs_to :sport, ScorifyElixir.Sports.Sport
    has_many :league_seasons, ScorifyElixir.Sports.LeagueSeason
    has_many :sides, through: [:league_seasons, :sides]

    timestamps()
  end

  @doc false
  def changeset(league, attrs) do
    league
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
