defmodule ScorifyElixirWeb.Router do
  use ScorifyElixirWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ScorifyElixirWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ScorifyElixirWeb do
  #   pipe_through :api
  # end

  forward("/graphql", Absinthe.Plug, schema: ScorifyElixirWeb.Schema)
  forward("/graphiql", Absinthe.Plug.GraphiQL, schema: ScorifyElixirWeb.Schema)
end
