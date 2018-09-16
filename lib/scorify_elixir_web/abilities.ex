defmodule ScorifyElixirWeb.Abilities do
  import Cantare.Abilities

  alias ScorifyElixir.Auth.User
  alias ScorifyElixir.Sports.{Side, Sport}

  # This way you can either call:
  #   a_user |> ScorifyElixirWeb.Abilities.can?(:create, a_record)
  # or `use` the `Can` module with this specific ability definition module
  # in any other module, and call `can?` from the module you `use`d it in.
  use Cantare.Abilities

  @spec abilities(ScorifyElixir.Auth.User) :: {atom(), [...]}
  def abilities(User) do
    User
    |> can(:show, Sport, fn %User{} = _user, %Sport{} = _sport -> true end)
    |> can(:show, Side, fn %User{} = _user, %Side{} = _side -> true end)
    |> can(:create, Side, fn %User{} = _user, %Side{} = _side -> true end)
  end
end
