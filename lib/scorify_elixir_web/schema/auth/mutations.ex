defmodule ScorifyElixirWeb.Schema.Auth.Mutations do
  import ScorifyElixirWeb.SafeResolver

  @doc false
  defmacro __using__(_opts) do
    quote do
      @desc "Create a user"
      field :create_user, type: :user do
        arg(:name, non_null(:string))
        arg(:email, non_null(:string))
        arg(:password, non_null(:string))

        resolve safely(&ScorifyElixirWeb.Auth.UserResolver.create/2)
      end
    end
  end
end
