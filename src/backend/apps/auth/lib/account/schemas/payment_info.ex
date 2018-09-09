defmodule Auth.Accounts.PaymentInfo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payment_infos" do
    field(:card_number, :string)
    field(:card_holder_name, :string)
    field(:card_expiration, :string)
    field(:card_brand, :string)
    belongs_to(:user, Auth.Account.User, foreign_key: :user_id)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:card_number, :card_holder_name, :card_expiration, :card_brand])
    |> validate_required([:card_number, :card_holder_name, :card_expiration, :card_brand])
  end
end
