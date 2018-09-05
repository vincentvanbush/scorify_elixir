defmodule ScorifyElixir.Can do
  require IEx

  @spec can(module(), atom(), module(), (%{}, %{:__meta__ => Ecto.Schema.Metadata} -> boolean())) ::
          {module(), list()}
  def can(entity_module, action, object_module, matcher) when is_atom(entity_module) and is_function(matcher) do
    {entity_module, [{action, object_module, matcher}]}
  end

  @spec can(
          {module(), list()},
          atom(),
          module(),
          (struct(), struct() -> boolean())
        ) :: {module(), list()}
  def can({entity_module, [_ | _] = action_matcher_list}, action, object_module, matcher)
      when is_atom(entity_module) and is_function(matcher) do
    {entity_module, [{action, object_module, matcher} | action_matcher_list]}
  end

  @spec can?(struct(), atom(), module(), struct(), [
          {:abilities, {any(), any()}},
          ...
        ]) :: boolean()
  def can?(
        %{:__struct__ => subject_schema} = subject,
        action,
        object_schema,
        %{:__struct__ => object_schema} = object,
        abilities: {subject_schema, [_ | _] = ability_list}
      )
      when is_atom(action) do
    ability_list
    |> Enum.filter(fn {act, sch, _} -> action == act && sch == object_schema end)
    |> Enum.all?(fn {_, _, matcher} -> matcher.(subject, object) end)
  end

  # TODO: define `can?` for general abilities, will be useful when lists
  # are retrieved

  defmacro __using__(abilities_module) do
    quote do
      def can?(
            %{:__struct__ => subject_schema} = subject,
            action,
            %{:__struct__ => object_schema} = object
          ) do
        ScorifyElixir.Can.can?(subject, action, object_schema, object, abilities: unquote(abilities_module).abilities(subject_schema))
      end
    end
  end
end
