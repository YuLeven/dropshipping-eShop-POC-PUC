defmodule Sales.Basket.Schemas.Basket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "baskets" do
    field(:buyer_id, :string)
    field(:payed, :boolean)

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
