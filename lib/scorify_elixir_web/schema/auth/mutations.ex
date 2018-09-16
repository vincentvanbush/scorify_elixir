defmodule ScorifyElixirWeb.Schema.Auth.Mutations do
  import Absinthe.Ecto.SafeResolver

  @doc false
  defmacro __using__(_opts) do
    quote do
      @desc "Create a user"
      field :create_user, type: :user do
        arg(:name, non_null(:string))
        arg(:email, non_null(:string))
        arg(:password, non_null(:string))

        resolve(safely(&ScorifyElixirWeb.Auth.UserResolver.create/2))
      end

      @desc "Sign a user out"
      field :sign_out, type: :user do
        resolve(safely(&ScorifyElixirWeb.Auth.UserResolver.logout/2))
      end
    end
  end
end
