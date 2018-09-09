use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sales, SalesWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :sales, Sales.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "poc",
  password: "poc",
  database: "sales_test",
  hostname: "sales.data",
  pool: Ecto.Adapters.SQL.Sandbox

config :sales, Sales.ProductRepo,
  adapter: Ecto.Adapters.Postgres,
  username: "poc",
  password: "poc",
  database: "products_test",
  hostname: "products.data",
  pool_size: 10
