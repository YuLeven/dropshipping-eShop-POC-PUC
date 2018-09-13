defmodule Sales.Baskets.BasketItem do
  alias Sales.Baskets.Basket
  use Ecto.Schema
  import Ecto.Changeset

  # Several of product's traits are duplicated beucase in production
  # product actually belongs to another application.
  @derive {Poison.Encoder,
           only: [
             :product_id,
             :product_name,
             :product_provider_id,
             :price,
             :quantity,
             :picture_url
           ]}
  schema "basket_itens" do
    field(:product_id, :integer)
    field(:product_name, :string)
    field(:product_provider_id, :integer)
    field(:price, :decimal)
    field(:quantity, :integer)
    field(:picture_url, :string)
    belongs_to(:basket, Basket, foreign_key: :basket_id)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :product_id,
      :product_name,
      :price,
      :quantity,
      :picture_url,
      :basket_id,
      :product_provider_id
    ])
    |> validate_required([
      :product_id,
      :product_name,
      :price,
      :quantity,
      :picture_url,
      :basket_id,
      :product_provider_id
    ])
  end
end
