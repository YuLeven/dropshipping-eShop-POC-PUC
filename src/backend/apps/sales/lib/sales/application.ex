defmodule Sales.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Sales.Repo, []),
      supervisor(Sales.ProductRepo, []),
      # Start the endpoint when the application starts
      supervisor(SalesWeb.Endpoint, []),
      worker(Sales.ProductsFakeDataProvider, [], restart: :temporary),
      worker(Sales.OrdersWorker, [])
      # Start your own worker by calling: Sales.Worker.start_link(arg1, arg2, arg3)
      # worker(Sales.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sales.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SalesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Sales.ProductsFakeDataProvider do
  use GenServer
  alias Sales.Products
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_args) do
    Logger.info("Seeding fake product data")
    Products.seed_fake_product_data(50)
    {:ok, nil}
  end
end
