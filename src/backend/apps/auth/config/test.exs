use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :auth, AuthWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :auth, Auth.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "poc",
  password: "poc",
  database: "auth_test",
  hostname: "auth.data",
  pool: Ecto.Adapters.SQL.Sandbox
