defmodule Auth.Accounts.AddressTest do
  use Auth.DataCase

  alias Auth.Accounts.Address

  @valid_attrs %{
    city: "some city",
    complement: "some complement",
    district: "some district",
    postal_code: "some postal_code",
    residence_number: 212,
    state: "some state",
    street: "some street",
    user_id: 1
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
