defmodule Cantare.Abilities do
  @spec can(module(), atom(), module(), (%{}, %{:__meta__ => Ecto.Schema.Metadata} -> boolean())) ::
          {module(), list()}
  def can(entity_module, action, object_module, matcher)
      when is_atom(entity_module) and is_function(matcher) do
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

  def can?(
        %{:__struct__ => subject_schema} = _subject,
        action,
        object_schema,
        abilities: {subject_schema, [_ | _] = ability_list}
      )
      when is_atom(action) do
    ability_list
    |> Enum.any?(fn {act, sch, _} -> action == act && sch == object_schema end)
  end

  defmacro __using__(_opts) do
    quote do
      def can?(
            %{:__struct__ => subject_schema} = subject,
            action,
            %{:__struct__ => object_schema} = object
          ) do
        Cantare.Abilities.can?(subject, action, object_schema, object,
          abilities: __MODULE__.abilities(subject_schema)
        )
      end

      def can?(
            %{:__struct__ => subject_schema} = subject,
            action,
            object_schema
          )
          when is_atom(object_schema) do
        Cantare.Abilities.can?(subject, action, object_schema,
          abilities: __MODULE__.abilities(subject_schema)
        )
      end

      # TODO: This method only filters records after they've been fetched.
      # This might sometimes be fine, but we still probably need a cancan-like
      # mechanism that lets users specify requirements with a keyword list
      # which is then converted into a function that can be either passed
      # to Ecto queries or used on single objects.
      def accessible_post_filter(
            %{:__struct__ => subject_schema} = subject,
            action,
            record_list
          )
          when is_list(record_list) do
        Enum.filter(record_list, fn elem ->
          subject |> __MODULE__.can?(action, elem)
        end)
      end
    end
  end
end
