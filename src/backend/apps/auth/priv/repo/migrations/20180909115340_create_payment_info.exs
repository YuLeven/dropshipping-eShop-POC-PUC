defmodule Auth.Repo.Migrations.CreatePaymentInfo do
  use Ecto.Migration

  def change do
    create table(:payment_infos) do
      add :card_number, :string
      add :card_holder_name, :string
      add :card_expiration, :string
      add :card_brand, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:payment_infos, [:user_id])
  end
end
