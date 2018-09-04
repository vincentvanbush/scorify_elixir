defmodule ScorifyElixir.Can do
  @spec can(module(), atom(), (%{}, %{:__meta__ => Ecto.Schema.Metadata} -> boolean())) ::
          {module(), list()}
  def can(entity_module, action, matcher) when is_atom(entity_module) and is_function(matcher) do
    {entity_module, [{action, matcher}]}
  end

  @spec can(
          {module(), list()},
          atom(),
          (%{}, %{:__meta__ => Ecto.Schema.Metadata} -> boolean())
        ) :: {module(), list()}
  def can({entity_module, [_ | _] = action_matcher_list}, action, matcher)
      when is_atom(entity_module) and is_function(matcher) do
    {entity_module, [{action, matcher} | action_matcher_list]}
  end

  @spec can?(struct(), atom(), struct(), [
          {:abilities, {any(), any()}},
          ...
        ]) :: boolean()
  def can?(
        %{:__struct__ => subject_schema} = subject,
        action,
        %{:__struct__ => _} = object,
        abilities: {subject_schema, [_ | _] = ability_list}
      )
      when is_atom(action) do
    ability_list
    |> Enum.filter(fn {act, _matcher} -> action == act end)
    |> Enum.any?(fn {_, matcher} -> matcher.(subject, object) end)
  end

  defmacro __using__(abilities_module) do
    quote do
      def can?(
            %{:__struct__ => subject_schema} = subject,
            action,
            %{:__struct__ => _} = object
          ) do
        ScorifyElixir.Can.can?(subject, action, object, abilities: unquote(abilities_module).abilities(subject_schema))
      end
    end
  end
end
