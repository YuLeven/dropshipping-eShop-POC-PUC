defmodule Auth.Accounts.UserTest do
  use Auth.DataCase

  alias Auth.Accounts.User

  @valid_attrs %{
    email: "some email",
    name: "John",
    surname: "Doe",
    hashed_password: "some hashed_password"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
