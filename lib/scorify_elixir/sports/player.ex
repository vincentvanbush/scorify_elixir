defmodule ScorifyElixir.Sports.Player do
  use Ecto.Schema
  import Ecto.Changeset

  alias ScorifyElixir.Sports.Sport

  schema "players" do
    field(:display_name, :string)
    field(:full_name, :string)

    belongs_to(:sport, ScorifyElixir.Sports.Sport)
    has_many(:player_sides, ScorifyElixir.Sports.PlayerSide)

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    set =
      player
      |> cast(attrs, [:full_name, :display_name, :sport_id])

    set =
      case set.changes[:sport] do
        %Sport{id: sport_id} -> set |> cast(%{sport_id: sport_id}, [:sport_id])
        _ -> set
      end

    set
    |> validate_required([:full_name, :display_name, :sport_id])
    |> assoc_constraint(:sport)
  end
end
