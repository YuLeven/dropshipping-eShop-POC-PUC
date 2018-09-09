defmodule Auth.AddressTest do
  use Auth.DataCase

  alias Auth.Account.Schemas.Address

  @valid_attrs %{
    city: "some city",
    complement: "some complement",
    district: "some district",
    postal_code: "some postal_code",
    residence_number: "some residence_number",
    state: "some state",
    street: "some street"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Address.changeset(%Address{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Address.changeset(%Address{}, @invalid_attrs)
    refute changeset.valid?
  end
end
