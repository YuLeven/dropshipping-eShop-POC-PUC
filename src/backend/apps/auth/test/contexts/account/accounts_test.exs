defmodule Auth.AccountsTest do
  use Auth.DataCase, async: true

  alias Auth.Accounts.{Address}
  alias Auth.Accounts

  @valid_account %{
    name: Faker.Name.first_name(),
    surname: Faker.Name.last_name(),
    email: "foo@bar.com",
    password: "password"
  }

  describe "get_account/1" do
    test "Gets an existing user account" do
      email = Faker.Internet.email()

      %{
        name: Faker.Name.first_name(),
        surname: Faker.Name.last_name(),
        email: email,
        password: "password"
      }
      |> Accounts.create_account!()

      assert %{email: email} = Accounts.get_account(email)
    end

    test "Returns nil when account inexists" do
      assert Accounts.get_account("foo@bar.com") == nil
    end
  end

  describe "create_account!/1" do
    test "creates a new account with hashed password" do
      @valid_account
      |> Accounts.create_account!()

      hashed_password = Bcrypt.hash_pwd_salt("password")

      assert %{email: "foo@bar.com", hashed_password: hashed_password} =
               Accounts.get_account("foo@bar.com")
    end

    test "fails when email is already taken" do
      assert_raise Ecto.InvalidChangesetError, fn ->
        @valid_account |> Accounts.create_account!()
        @valid_account |> Accounts.create_account!()
      end
    end
  end

  describe "authenticate/1" do
    test "signs in a user" do
      @valid_account |> Accounts.create_account!()

      assert {:ok, _} = Accounts.authenticate(email: "foo@bar.com", password: "password")
    end

    test "fails when password is invalid" do
      @valid_account |> Accounts.create_account!()

      assert {:error, "Wrong password"} =
               Accounts.authenticate(email: "foo@bar.com", password: "passwordd")
    end

    test "fails when account not exists" do
      @valid_account |> Accounts.create_account!()

      assert {:error, "Account not found"} =
               Accounts.authenticate(email: "bar@foo.com", password: "password")
    end
  end

  describe "add_shipping_address/2" do
    @shipping_address %Address{
      street: Faker.Address.street_address(),
      residence_number: Faker.Address.building_number(),
      complement: "AP 12",
      district: "Scaraborough",
      city: Faker.Address.city(),
      state: Faker.Address.state(),
      postal_code: "37440-000"
    }

    test "adds a new address to an account" do
      account = @valid_account |> Accounts.create_account!()

      new_address = account |> Accounts.add_shipping_address(@shipping_address)

      expected_address = %{
        street: Faker.Address.street_address(),
        residence_number: Faker.Address.building_number(),
        complement: "AP 12",
        district: "Scaraborough",
        city: Faker.Address.city(),
        state: Faker.Address.state(),
        postal_code: "37440-000"
      }

      assert expected_address = new_address

      assert new_address.id != nil
    end
  end

  describe "remove_shipping_address/2" do
    test "remove a shipping address" do
      account =
        @valid_account
        |> Accounts.create_account!()

      shipping_address = account |> Accounts.add_shipping_address(@shipping_address)

      account |> Accounts.remove_shipping_address(shipping_address)

      account = Accounts.get_account("foo@bar.com")

      assert [] = account.shipping_addresses
    end
  end
end
