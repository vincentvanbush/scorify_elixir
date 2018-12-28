defmodule ScorifyElixirWeb.Abilities do
  import Cantare.Abilities

  alias ScorifyElixir.Auth.User
  alias ScorifyElixir.Sports.{Side, Sport, League}

  # This way you can either call:
  #   a_user |> ScorifyElixirWeb.Abilities.can?(:create, a_record)
  # or `use` the `Can` module with this specific ability definition module
  # in any other module, and call `can?` from the module you `use`d it in.
  use Cantare.Abilities, repo: ScorifyElixir.Repo

  @spec abilities(ScorifyElixir.Auth.User) :: {atom(), [...]}
  def abilities(User) do
    User
    |> can(:show, Sport, fn %User{} = _user, %Sport{} = _sport -> true end)
    |> can(:show, Side, fn %User{} = _user, %Side{} = _side -> true end)
    |> can(:create, Side, fn %User{} = _user, %Side{} = _side -> true end)
    # TODO: clean this up
    |> can(:create, League, fn current_user -> [name: current_user.email] end)

    # Proposed syntax addition:
    # |> can(:edit, League, fn %User{} = current_user -> [user_id: current_user.id] end)
  end
end
