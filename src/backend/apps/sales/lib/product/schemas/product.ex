defmodule Sales.Product.Schemas.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field(:name, :string)
    field(:price, :string)
    field(:description, :string)
    field(:picture_url, :string)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :price, :description, :picture_url])
    |> validate_required([:name, :price, :description, :picture_url])
  end
end
