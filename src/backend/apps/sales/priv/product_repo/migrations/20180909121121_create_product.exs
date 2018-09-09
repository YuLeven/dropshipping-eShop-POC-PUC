defmodule Sales.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :price, :string
      add :description, :string
      add :picture_url, :string

      timestamps()
    end
  end
end
