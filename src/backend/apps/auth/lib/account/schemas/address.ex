defmodule Auth.Account.Schemas.Address do
  use Ecto.Schema
  import Ecto.Changeset

  schema "addresses" do
    field(:street, :string)
    field(:residence_number, :string)
    field(:complement, :string)
    field(:district, :string)
    field(:city, :string)
    field(:state, :string)
    field(:postal_code, :string)
    belongs_to(:user, Auth.Account.Schemas.User, foreign_key: :user_id)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :street,
      :residence_number,
      :complement,
      :district,
      :city,
      :state,
      :postal_code
    ])
    |> validate_required([
      :street,
      :residence_number,
      :complement,
      :district,
      :city,
      :state,
      :postal_code
    ])
  end
end
