defmodule ScorifyElixir.Sports.LeagueSeason do
  use Ecto.Schema
  import Ecto.Changeset

  schema "league_seasons" do
    field(:end_date, :date)
    field(:name, :string)
    field(:start_date, :date)

    belongs_to(:league, ScorifyElixir.Sports.League)
    many_to_many(:sides, ScorifyElixir.Sports.Side, join_through: "sides_league_seasons")

    timestamps()
  end

  @spec changeset(%{:__struct__ => atom(), :name => any(), optional(atom()) => any()}, :invalid | map()) :: Ecto.Changeset.t()
  def changeset(league_season, attrs) do
    attrs =
      if attrs[:name] == nil do
        start_year =
          try do: Ecto.Date.cast!(attrs[:start_date] || league_season.start_date).year,
              rescue: (_ in Ecto.CastError -> nil)

        end_year =
          try do: Ecto.Date.cast!(attrs[:end_date] || league_season.end_date).year,
              rescue: (_ in Ecto.CastError -> nil)

        attrs |> Map.put(:name, "#{start_year}/#{end_year}")
      else
        attrs
      end

    league_season
    |> cast(attrs, [:name, :start_date, :end_date, :league_id])
    |> validate_required([:name, :start_date, :end_date, :league_id])
    |> unique_constraint(:name, name: :league_seasons_league_id_name_index)
  end
end
