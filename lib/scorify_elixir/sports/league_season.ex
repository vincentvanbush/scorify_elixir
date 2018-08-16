defmodule ScorifyElixir.Sports.LeagueSeason do
  use Ecto.Schema
  import Ecto.Changeset

  require IEx

  schema "league_seasons" do
    field :end_date, :date
    field :name, :string
    field :start_date, :date

    belongs_to :league, ScorifyElixir.Sports.League
    many_to_many :sides, ScorifyElixir.Sports.Side, join_through: "sides_league_seasons"

    timestamps()
  end

  @doc false
  def changeset(league_season,
                attrs = %{start_date: start_date, end_date: end_date, name: name})
                when is_nil(name) and not(is_nil(start_date) or is_nil(end_date)) do
    start_year = Ecto.Date.cast!(start_date).year
    end_year = Ecto.Date.cast!(end_date).year
    make_changeset(league_season, attrs |> Map.put(:name, "#{start_year}/#{end_year}"))
  end

  def changeset(league_season, attrs = %{name: name}) when is_nil(name) do
    make_changeset(league_season, attrs |> Map.put(:name, nil))
  end

  def changeset(league_season, attrs = %{name: _name}) do
    make_changeset(league_season, attrs)
  end

  def changeset(league_season, attrs) do
    changeset(league_season, attrs |> Map.put_new(:name, nil))
  end

  defp make_changeset(league_season, attrs) do
    league_season
    |> cast(attrs, [:name, :start_date, :end_date])
    |> validate_required([:name, :start_date, :end_date])
  end
end
