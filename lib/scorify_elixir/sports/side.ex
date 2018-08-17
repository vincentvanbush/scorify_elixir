defmodule ScorifyElixir.Sports.Side do
  use Ecto.Schema
  import Ecto.Changeset


  schema "sides" do
    field :name, :string

    belongs_to :sport, ScorifyElixir.Sports.Sport
    belongs_to :location, ScorifyElixir.Sports.Location
    many_to_many :league_seasons, ScorifyElixir.Sports.LeagueSeason, join_through: "sides_league_seasons"

    timestamps()
  end

  @doc false
  def changeset(side, attrs) do
    side
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: :sides_sport_id_name_index)
  end
end
