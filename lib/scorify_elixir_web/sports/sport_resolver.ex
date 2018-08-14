defmodule ScorifyElixirWeb.Sports.SportResolver do
  alias ScorifyElixir.Sports

  def all(_args, _info) do
    {:ok, Sports.list_sports()}
  end
end
