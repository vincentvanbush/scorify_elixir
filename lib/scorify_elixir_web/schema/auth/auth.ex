defmodule ScorifyElixirWeb.Schema.Auth do
  @doc false
  defmacro __using__(_opts) do
    quote do
      import_types(ScorifyElixirWeb.Schema.Auth.Types)

      field :user, :user do
        arg(:id, :id)

        resolve fn (x, y) ->
          {:ok, %{id: 555}}
        end
      end
    end
  end
end
