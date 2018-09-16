defmodule Absinthe.Cantare.AbilityResolver do
  defmacro __using__(repo: repo_module, abilities: abilities_module, user_schema: user_schema) do
    quote do
      use Absinthe.Cantare.AbilityResolver,
        repo: unquote(repo_module),
        abilities: unquote(abilities_module),
        user_schema: unquote(user_schema),
        after: []
    end
  end

  defmacro __using__(
             repo: repo_module,
             abilities: abilities_module,
             user_schema: user_schema,
             after: after_resolve_functions
           ) do
    quote do
      def with_abilities(fun, action, target_schema \\ nil)
          when is_function(fun, 2) or (is_function(fun, 3) and is_atom(action)) do
        fn parent, args, config ->
          resolver_result =
            case :erlang.fun_info(fun)[:arity] do
              2 -> fun.(args, config)
              3 -> fun.(parent, args, config)
            end

          s = unquote(user_schema)

          case config do
            %{context: %{current_user: %{__struct__: ^s} = current_user}} ->
              case resolver_result do
                {:ok, %{:__struct__ => _schema_module} = resolved_record} ->
                  case current_user |> unquote(abilities_module).can?(action, resolved_record) do
                    true -> {:ok, resolved_record}
                    false -> {:error, "Not authorized: #{action}"}
                  end

                {:ok, record_list} when is_list(record_list) ->
                  case current_user |> unquote(abilities_module).can?(action, target_schema) do
                    true ->
                      {:ok,
                       Enum.filter(record_list, fn elem ->
                         current_user |> unquote(abilities_module).can?(action, elem)
                       end)}

                    false ->
                      {:error, "Not authorized: #{action}"}
                  end

                {:error, _} ->
                  resolver_result
              end

            _ ->
              {:error, "Not signed in"}
          end
        end
      end

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

      def list_authorize(list_fn, ability: ability, schema: schema) do
        list_fn
        |> with_abilities(ability, schema)
        |> filter(ability)
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

      defp filter(fun, ability) when is_function(fun, 2) or is_function(fun, 3) do
        fn parent, args, config ->
          resolver_result =
            case :erlang.fun_info(fun)[:arity] do
              2 -> fun.(args, config)
              3 -> fun.(parent, args, config)
            end

          case resolver_result do
            {:ok, resolved_list} when is_list(resolved_list) ->
              s = unquote(user_schema)

              case config do
                %{context: %{current_user: %{__struct__: ^s} = current_user}} ->
                  {:ok, resolved_list}

                _ ->
                  {:error, "Not authorized"}
              end

            {:error, _} ->
              resolver_result
          end
        end
      end
    end
  end
end
