defmodule ScorifyElixir.Sports.Location do
  use Ecto.Schema
  import Ecto.Changeset


  schema "locations" do
    field :entered_name, :string
    field :lat, :decimal
    field :lng, :decimal
    field :full_name, :string
    field :locality, :string
    field :street_address, :string

    has_many :sides, ScorifyElixir.Sports.Side

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:full_name, :entered_name, :lat, :lng, :full_name, :locality, :street_address])
    |> validate_required([:full_name, :entered_name, :lat, :lng, :full_name, :locality, :street_address])
  end
end
