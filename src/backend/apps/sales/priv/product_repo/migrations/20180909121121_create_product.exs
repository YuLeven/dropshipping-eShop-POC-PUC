defmodule Sales.ProductRepo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add(:name, :string)
      add(:price, :decimal)
      add(:description, :string)
      add(:picture_url, :string)
      add(:provider_id, :integer)

      timestamps()
    end
  end
end
