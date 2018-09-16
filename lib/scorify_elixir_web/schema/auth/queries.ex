defmodule ScorifyElixirWeb.Schema.Auth.Queries do
  @doc false
  defmacro __using__(_opts) do
    quote do
      # TODO: Perhaps better off as a mutation?
      @desc "Sign a user in, returning JWT token"
      field :login, type: :session do
        arg(:email, non_null(:string))
        arg(:password, non_null(:string))

        resolve(&ScorifyElixirWeb.Auth.UserResolver.login/2)
      end
    end
  end
end
