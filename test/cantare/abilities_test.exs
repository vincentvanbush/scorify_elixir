defmodule Cantare.AbilitiesTest do
  use ExUnit.Case

  defmodule Pig do
    defstruct [:role, :id]
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

    test "simple ability given on a struct", %{
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

  # Named setups

  def prepare_pigs(context \\ %{}) do
    context
    |> Map.merge(%{
      napoleon: %Pig{role: :napoleon, id: 1},
      squealer: %Pig{role: :squealer, id: 2},
      piglet: %Pig{role: :piglet, id: 3}
    })
  end
end
