defmodule Sales.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:buyer_id, :integer)
      add(:delivery_address_id, :integer)
      add(:invoice_total, :decimal)
      add(:supplier_status, :string)
      add(:basket_id, references(:baskets, on_delete: :nothing))

      timestamps()
    end

    create(index(:orders, [:basket_id]))
  end
end
