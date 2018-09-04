defmodule ScorifyElixirWeb.Sports.SideResolver do
  import ScorifyElixir.Sports
  alias ScorifyElixir.Sports.{League, Sport}
  alias ScorifyElixir.Auth.User
  require Ecto.Query

  require IEx

  def all(league = %League{}, _, _) do
    {:ok, league |> list_league_sides}
  end

  def all(sport = %Sport{}, _, _) do
    {:ok, sport |> list_sport_sides}
  end

  def find(%{id: id}, _) do
    {:ok, get_side(id)}
  end

  def create(sport, attrs = %{}, %{context: %{current_user: %User{}}}) do
    sport |> create_side(attrs)
  end

  def create(_, _, _) do
    {:error, "Not authorized"}
  end

  def add_to_league(side, %{league_id: league_id}, _info) do
    league = get_league(league_id)
    {status, result} = side |> add_side_to_league(league: league)

    case status do
      :ok -> {:ok, side}
      :error -> {:error, result}
    end
  end

  @doc """
  Used as Absinthe mutation middleware so that a Side struct can be
  seen as a parent by a resolver function.
  """
  def set_parent_side(resolution = %{arguments: %{side_id: side_id}}, _) do
    side = get_side(side_id)
    resolution |> Map.put(:source, side)
  end
end
