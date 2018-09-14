defmodule Sales.Repo.Migrations.CreateBasket do
  use Ecto.Migration

  def change do
    create table(:baskets) do
      add(:buyer_id, :integer)
      add(:status, :string, default: "active")

      timestamps()
    end
  end
end
