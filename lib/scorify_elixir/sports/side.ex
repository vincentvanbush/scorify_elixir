defmodule ScorifyElixir.Sports.Side do
  use Ecto.Schema
  import Ecto.Changeset

  alias ScorifyElixir.Sports.Sport

  schema "sides" do
    field(:name, :string)

    belongs_to(:sport, ScorifyElixir.Sports.Sport)
    belongs_to(:location, ScorifyElixir.Sports.Location)

    many_to_many(
      :league_seasons,
      ScorifyElixir.Sports.LeagueSeason,
      join_through: "sides_league_seasons"
    )

    has_many(:leagues, through: [:league_seasons, :league])
    has_many(:player_sides, ScorifyElixir.Sports.PlayerSide)

    timestamps()
  end

  @doc false
  def changeset(side, attrs) do
    set =
      side
      |> cast(attrs, [:name, :sport_id])

    set =
      case set.changes[:sport] do
        %Sport{id: sport_id} -> set |> cast(%{sport_id: sport_id}, [:sport_id])
        _ -> set
      end

    set
    |> validate_required([:name, :sport_id])
    |> unique_constraint(:name, name: :sides_sport_id_name_index)
    |> assoc_constraint(:sport)
  end
end
