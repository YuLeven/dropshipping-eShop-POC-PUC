defmodule Auth.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:name, :string)
    field(:surname, :string)
    field(:hashed_password, :string)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :surname, :hashed_password])
    |> validate_required([:email, :name, :surname, :hashed_password])
  end
end
