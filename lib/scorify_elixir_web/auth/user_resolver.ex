defmodule ScorifyElixirWeb.Auth.UserResolver do
  alias ScorifyElixir.Auth

  def create(params, _info) do
    Auth.create_user(params)
  end
end
