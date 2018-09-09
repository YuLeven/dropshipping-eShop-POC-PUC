defmodule Sales.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sales.Baskets.Basket

  schema "orders" do
    field(:buyer_id, :integer)
    field(:delivery_address_id, :integer)
    field(:invoice_total, :decimal)
    field(:supplier_status, :string)
    belongs_to(:basket, Basket, foreign_key: :basket_id)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:buyer_id, :delivery_address_id, :invoice_total, :supplier_status])
    |> validate_required([:buyer_id, :delivery_address_id, :invoice_total, :supplier_status])
  end
end
