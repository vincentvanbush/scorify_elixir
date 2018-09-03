defmodule ScorifyElixirWeb.Router do
  use ScorifyElixirWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :graphql do
    plug ScorifyElixirWeb.Context
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

  scope "/api" do
    pipe_through(:graphql)

    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: ScorifyElixirWeb.Schema)
    forward("/graphql", Absinthe.Plug, schema: ScorifyElixirWeb.Schema)
  end
end
