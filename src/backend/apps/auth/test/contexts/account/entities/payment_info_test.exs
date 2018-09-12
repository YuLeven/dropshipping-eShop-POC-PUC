defmodule Auth.Accounts.PaymentInfoTest do
  use Auth.DataCase

  alias Auth.Accounts.PaymentInfo

  @valid_attrs %{
    card_brand: "some card_brand",
    card_expiration: "some card_expiration",
    card_holder_name: "some card_holder_name",
    card_number: "some card_number",
    user_id: 1
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PaymentInfo.changeset(%PaymentInfo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PaymentInfo.changeset(%PaymentInfo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
