defmodule ScorifyElixirWeb.Abilities do
  import Cantare.Abilities

  alias ScorifyElixir.Auth.User
  alias ScorifyElixir.Sports.{Side}

  # This way you can either call:
  #   a_user |> ScorifyElixirWeb.Abilities.can?(:create, a_record)
  # or `use` the `Can` module with this specific ability definition module
  # in any other module, and call `can?` from the module you `use`d it in.
  use Cantare.Abilities

  @spec abilities(ScorifyElixir.Auth.User) :: {atom(), [...]}
  def abilities(User) do
    User
    |> can(:show, Side, fn %User{} = _user, %Side{} = _side -> true end)
    |> can(:create, Side, fn %User{} = _user, %Side{} = _side -> true end)
    |> can(:show, Sport, fn _, _ -> true end)

    # user |> can?(:show, Side)
    #   -> will return true if any can(:show, Side, ...) entry is present
    # user |> can?(:show, %Side{...})
    #   -> will return true if any entry has a function that returns true for given record
  end
end
