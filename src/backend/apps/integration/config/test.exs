use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :integration, IntegrationWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :integration, Integration.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "poc",
  password: "poc",
  database: "integration_test",
  hostname: "integration.data",
  pool: Ecto.Adapters.SQL.Sandbox
