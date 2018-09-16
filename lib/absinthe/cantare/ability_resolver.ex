defmodule Absinthe.Cantare.AbilityResolver do
  defmacro __using__(repo: repo_module) do
    quote do
      use Absinthe.Cantare.AbilityResolver, repo: unquote(repo_module), after: []
    end
  end

  defmacro __using__(
             repo: repo_module,
             abilities: abilities_module,
             after: after_resolve_functions
           ) do
    quote do
      def with_abilities(fun, action)
          when is_function(fun, 2) or (is_function(fun, 3) and is_atom(action)) do
        fn parent, args, config ->
          resolver_result =
            case :erlang.fun_info(fun)[:arity] do
              2 -> fun.(args, config)
              3 -> fun.(parent, args, config)
            end

          case resolver_result do
            {:ok, %{:__struct__ => _schema_module} = resolved_record} ->
              case config do
                %{context: %{current_user: %{__struct__: ScorifyElixir.Auth.User} = current_user}} ->
                  case current_user |> unquote(abilities_module).can?(action, resolved_record) do
                    true -> {:ok, resolved_record}
                    false -> {:error, "Not authorized"}
                  end

                _ ->
                  {:error, "Not authorized"}
              end

            # TODO: handle case when a list is resolved

            {:error, _} ->
              resolver_result
          end
        end
      end

      require IEx

      def build_authorize_insert(build_fn, ability: ability)
          when is_function(build_fn, 2) or is_function(build_fn, 3) do
        resolution =
          build_fn
          |> with_abilities(ability)
          |> insert()

        Enum.reduce(
          unquote(after_resolve_functions),
          resolution,
          fn new_fun, res -> new_fun.(res) end
        )
      end

      defp insert(fun) when is_function(fun, 2) or is_function(fun, 3) do
        fn parent, args, config ->
          resolver_result =
            case :erlang.fun_info(fun)[:arity] do
              2 -> fun.(args, config)
              3 -> fun.(parent, args, config)
            end

          case resolver_result do
            {:ok, %{__meta__: %{state: :built}} = built_record} ->
              built_record
              |> built_record.__struct__.changeset(%{})
              |> unquote(repo_module).insert()

            {:error, _} ->
              resolver_result
          end
        end
      end
    end
  end
end
