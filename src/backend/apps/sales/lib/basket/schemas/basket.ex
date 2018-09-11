defmodule Sales.Baskets.Basket do
  use Ecto.Schema
  import Ecto.Changeset
  alias Sales.Baskets.BasketItem

  @derive {Poison.Encoder, only: [:buyer_id, :payed, :basket_itens]}
  schema "baskets" do
    field(:buyer_id, :integer)
    field(:payed, :boolean)
    has_many(:basket_itens, BasketItem)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:buyer_id, :payed])
    |> validate_required([:buyer_id, :payed])
  end
end
