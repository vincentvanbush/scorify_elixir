defmodule ScorifyElixir.Sports do
  alias ScorifyElixir.Repo
  alias ScorifyElixir.Sports.{Sport, League}
  import Ecto

  def list_sports do
    Sport |> Repo.all
  end

  def get_sport!(id) do
    Sport |> Repo.get!(id)
  end

  def create_sport(attrs \\ %{}) do
    %Sport{}
    |> Sport.changeset(attrs)
    |> Repo.insert!()
  end

  def get_league!(id) do
    League |> Repo.get!(id)
  end

  def list_leagues do
    League |> Repo.all
  end

  def list_leagues(sport) do
    assoc(sport, :leagues) |> Repo.all
  end

  def create_league(sport, attrs \\ %{}) do
    sport |> build_assoc(:leagues, attrs) |> Repo.insert!
  end
end
