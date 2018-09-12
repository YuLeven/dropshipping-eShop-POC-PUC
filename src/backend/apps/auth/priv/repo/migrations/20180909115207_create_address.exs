defmodule Auth.Repo.Migrations.CreateAddress do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add(:street, :string)
      add(:residence_number, :integer)
      add(:complement, :string)
      add(:district, :string)
      add(:city, :string)
      add(:state, :string)
      add(:postal_code, :string)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:addresses, [:user_id]))
  end
end
