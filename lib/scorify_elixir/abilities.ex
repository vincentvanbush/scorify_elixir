defmodule ScorifyElixir.Abilities do
  import ScorifyElixir.Can

  alias ScorifyElixir.Auth.User
  alias ScorifyElixir.Sports.{Side, League}

  # This way you can either call:
  #   a_user |> ScorifyElixir.Abilities.can?(:create, a_record)
  # or `use` the `Can` module with this specific ability definition module
  # in any other module, and call `can?` from the module you `use`d it in.
  use ScorifyElixir.Can, ScorifyElixir.Abilities

  @spec abilities(ScorifyElixir.Auth.User) :: {atom(), [...]}
  def abilities(User) do
    User
    |> can(:show, Side, fn %User{} = _user, %Side{} = _side -> true end)
    |> can(:create, Side, fn %User{} = user, %Side{} = side ->
      String.starts_with?(side.name, String.first(user.email))
    end)
    |> can(:create, League, fn %User{} = _user, %League{} = league -> !(league.sport == nil) end)
  end
end
