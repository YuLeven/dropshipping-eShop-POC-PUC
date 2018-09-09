defmodule Sales.Basket.BasketItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "basket_itens" do
    field(:product_id, :string)
    field(:product_name, :string)
    field(:price, :decimal)
    field(:quantity, :integer)
    field(:picture_url, :string)
    belongs_to(:basket, Sales.Basket, foreign_key: :basket_id)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:product_id, :product_name, :price, :quantity, :picture_url])
    |> validate_required([:product_id, :product_name, :price, :quantity, :picture_url])
  end
end
