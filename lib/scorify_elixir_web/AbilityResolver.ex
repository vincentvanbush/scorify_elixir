defmodule ScorifyElixirWeb.AbilityResolver do
  alias ScorifyElixir.Auth.User
  alias ScorifyElixir.Abilities

  def with_abilities(fun, action) when is_function(fun, 2) or is_function(fun, 3) and is_atom(action) do
    fn parent, args, config ->
      resolver_result =
        case :erlang.fun_info(fun)[:arity] do
          2 -> fun.(args, config)
          3 -> fun.(parent, args, config)
        end

      case resolver_result do
        {:ok, %{:__struct__ => _schema_module} = resolved_record} ->
          case config do
            %{context: %{current_user: %User{} = current_user}} ->
              case current_user |> Abilities.can?(action, resolved_record) do
                true -> {:ok, resolved_record}
                false -> {:error, "Not authorized"}
              end

            _ -> {:error, "Not authorized"}
          end

        # TODO: handle case when a list is resolved

        {:error, _} -> resolver_result
      end
    end
  end
end
