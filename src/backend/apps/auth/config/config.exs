# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :auth,
  namespace: Auth,
  ecto_repos: [Auth.Repo]

# Configures the endpoint
config :auth, AuthWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1NpByXgL1xm7lM6UW913CQvyW4Hazh7UQX4iVwU1VeiQb7S98C/+8sLMgLIX48q5",
  render_errors: [view: AuthWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Auth.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :rabbitmq_client, :rabbitmq, connection_url: {:system, "RABBITMQ_CONNECTION_STRING"}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
