defmodule ScorifyElixirWeb.Sports.SportResolver do
  alias ScorifyElixir.Sports

  def all(_args, _info) do
    {:ok, Sports.list_sports()}
  end

  def find(%{id: id}, _info) do
    {:ok, Sports.get_sport!(id)}
  end
end
