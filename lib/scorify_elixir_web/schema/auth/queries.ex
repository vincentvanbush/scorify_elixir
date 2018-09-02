defmodule ScorifyElixirWeb.Schema.Auth.Queries do
  # import ScorifyElixirWeb.SafeResolver

  @doc false
  defmacro __using__(_opts) do
    quote do
      field :user, :user do
        arg(:id, :id)

        resolve fn (x, y) ->
          {:ok, %{id: 555}}
        end
      end
    end
  end
end
