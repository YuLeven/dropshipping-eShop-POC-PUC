defmodule Auth.Accounts.Address do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder,
           only: [:street, :residence_number, :complement, :district, :city, :state, :postal_code]}
  schema "addresses" do
    field(:street, :string)
    field(:residence_number, :integer)
    field(:complement, :string)
    field(:district, :string)
    field(:city, :string)
    field(:state, :string)
    field(:postal_code, :string)
    belongs_to(:user, Auth.Accounts.User, foreign_key: :user_id)

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
      :postal_code,
      :user_id
    ])
    |> validate_required([
      :street,
      :residence_number,
      :district,
      :city,
      :state,
      :postal_code,
      :user_id
    ])
  end
end
