defmodule ScorifyElixir.Sports do
  alias ScorifyElixir.Repo
  alias ScorifyElixir.Sports.Sport

  def list_sports do
    Repo.all(Sport)
  end
end
