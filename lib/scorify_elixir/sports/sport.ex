defmodule ScorifyElixir.Sports.Sport do
  use Ecto.Schema
  import Ecto.Changeset


  schema "sports" do
    field :name, :string
    field :team, :boolean, default: false

    has_many :sides, ScorifyElixir.Sports.Side
    has_many :leagues, ScorifyElixir.Sports.League

    timestamps()
  end

  @doc false
  def changeset(sport, attrs) do
    sport
    |> cast(attrs, [:name, :team])
    |> validate_required([:name, :team])
  end
end
