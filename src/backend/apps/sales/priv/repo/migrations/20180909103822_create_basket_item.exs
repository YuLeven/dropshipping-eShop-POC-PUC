defmodule Sales.Repo.Migrations.CreateBasketItem do
  use Ecto.Migration

  def change do
    create table(:basket_itens) do
      add :product_id, :string
      add :product_name, :string
      add :price, :decimal
      add :quantity, :integer
      add :picture_url, :string
      add :basket_id, references(:baskets, on_delete: :nothing)

      timestamps()
    end

    create index(:basket_itens, [:basket_id])
  end
end
