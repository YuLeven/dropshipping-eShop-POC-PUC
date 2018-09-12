defmodule Sales.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field(:name, :string)
    field(:price, :decimal)
    field(:description, :string)
    field(:picture_url, :string)
    field(:provider_id, :integer)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :price, :description, :picture_url, :provider_id])
    |> validate_required([:name, :price, :description, :picture_url, :provider_id])
  end
end
