defmodule ScorifyElixir.Sports.PlayerSide do
  use Ecto.Schema
  import Ecto.Changeset

  alias ScorifyElixir.Sports.Player
  alias ScorifyElixir.Sports.Side

  schema "players_sides" do
    field :from_date, :date
    field :until_date, :date

    belongs_to :player, ScorifyElixir.Sports.Player
    belongs_to :side, ScorifyElixir.Sports.Side

    timestamps()
  end

  @doc false
  def changeset(player_side, attrs) do
    set =
      player_side
      |> cast(attrs, [:from_date, :until_date])

    set =
      case set.changes[:player] do
        %Player{id: player_id} -> set |> cast(%{player_id: player_id}, [:player_id])
        _ -> set
      end

    set =
      case set.changes[:side] do
        %Side{id: side_id} -> set |> cast(%{side_id: side_id}, [:side_id])
        _ -> set
      end

    set
    |> validate_required([:from_date, :until_date])
    |> assoc_constraint(:player)
    |> assoc_constraint(:side)
  end
end
