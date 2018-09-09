defmodule Auth.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:name, :string)
      add(:surname, :string)
      add(:hashed_password, :string)

      timestamps()
    end
  end
end
