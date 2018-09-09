defmodule Sales.Repo.Migrations.CreateBasket do
  use Ecto.Migration

  def change do
    create table(:baskets) do
      add(:buyer_id, :integer)
      add(:payed, :boolean, default: false)

      timestamps()
    end
  end
end
