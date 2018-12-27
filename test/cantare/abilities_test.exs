defmodule Cantare.AbilitiesTest do
  use ExUnit.Case
  require Ecto.Query

  import TestUtils

  defmodule Pig do
    use Ecto.Schema

    schema "pigs" do
      field(:role, :string)
    end
  end

  defmacro define_pig_abilities(context \\ %{}, do: block) do
    quote do
      {:module, module_name, _, _} =
        defmodule AnimalFarm.Abilities do
          use Cantare.Abilities

          def abilities(Pig) do
            unquote(block)
          end
        end

      {
        :ok,
        Map.put(unquote(context), :ability_module, module_name)
      }
    end
  end

  setup [:prepare_pigs]

  describe "with a basic set of abilities given on Pig" do
    setup context do
      context
      |> define_pig_abilities do
        Pig
        |> Cantare.Abilities.can(:judge, Pig, fn pig, other_pig -> pig.id < other_pig.id end)
      end
    end

    test "can?", %{
      napoleon: napoleon,
      squealer: squealer,
      piglet: piglet,
      ability_module: ability_module
    } do
      assert(napoleon |> ability_module.can?(:judge, squealer))
      assert(napoleon |> ability_module.can?(:judge, piglet))
      assert(squealer |> ability_module.can?(:judge, piglet))
      refute(piglet |> ability_module.can?(:judge, squealer))
      refute(piglet |> ability_module.can?(:judge, napoleon))
      refute(squealer |> ability_module.can?(:judge, napoleon))
    end
  end

  describe "with a set of abilities given on Pig as Ecto keyword list" do
    setup context do
      context
      |> define_pig_abilities do
        Pig |> Cantare.Abilities.can(:view, Pig, fn current_pig -> [role: current_pig.role] end)
      end
    end

    test "can?/3", %{
      napoleon: napoleon,
      squealer: squealer,
      piglet: piglet,
      ability_module: ability_module
    } do
      assert(napoleon |> ability_module.can?(:view, napoleon))
      refute(napoleon |> ability_module.can?(:view, squealer))
      refute(napoleon |> ability_module.can?(:view, piglet))
      refute(piglet |> ability_module.can?(:view, squealer))
      refute(piglet |> ability_module.can?(:view, napoleon))
      refute(squealer |> ability_module.can?(:view, napoleon))
    end

    test "accessible_query/3", %{ability_module: ability_module} do
      base_query = Ecto.Query.from(p in Pig)
      query = base_query |> ability_module.accessible_query(%Pig{role: "napoleon"}, :view)

      assert {"pigs", Pig} = query.from
      assert query |> query_equals(Ecto.Query.from(p in base_query, where: p.role == ^"napoleon"))
    end
  end

  # Named setups

  def prepare_pigs(context \\ %{}) do
    context
    |> Map.merge(%{
      napoleon: %Pig{role: "napoleon", id: 1},
      squealer: %Pig{role: "squealer", id: 2},
      piglet: %Pig{role: "piglet", id: 3}
    })
  end
end
