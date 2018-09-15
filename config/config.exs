# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :scorify_elixir,
  ecto_repos: [ScorifyElixir.Repo]

# Configures the endpoint
config :scorify_elixir, ScorifyElixirWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ScorifyElixirWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ScorifyElixir.PubSub, adapter: Phoenix.PubSub.PG2]

config :scorify_elixir, ScorifyElixirWeb.Guardian,
  issuer: "scorify_elixir",
  secret_key: "Yn+wsevYO2zN1OZg9MpAFU3yIzHwBn4GUO8Z07so7xvNmSzwNvtPhgTpm54MHRDB"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
