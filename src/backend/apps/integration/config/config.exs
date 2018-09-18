# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :integration,
  namespace: Integration,
  ecto_repos: [Integration.Repo]

# Configures the endpoint
config :integration, IntegrationWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4cHFEzpupLmCk4v/lE/Koo0pUyY8Ior1ZVQ7byiHOuHAi7ZN0SiUnXOTyLn0uw5I",
  render_errors: [view: IntegrationWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Integration.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :rabbitmq_client, :rabbitmq, connection_url: {:system, "RABBITMQ_CONNECTION_STRING"}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
