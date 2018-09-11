defmodule Auth.AccountsTest do
  use Auth.DataCase, async: true

  alias Auth.Accounts.{Address, PaymentInfo}
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

      new_account = Accounts.get_account("foo@bar.com")
      assert %{email: "foo@bar.com"} = new_account
      assert Bcrypt.verify_pass("password", new_account.hashed_password)
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
      street: "Fake Street",
      residence_number: "37",
      complement: "AP 12",
      district: "Centro",
      city: "Caxambu",
      state: "Minas Gerais",
      postal_code: "37440-000"
    }

    test "adds a new address to an account" do
      account = @valid_account |> Accounts.create_account!()

      new_address = account |> Accounts.add_shipping_address(@shipping_address)

      assert %Address{
               street: "Fake Street",
               residence_number: "37",
               complement: "AP 12",
               district: "Centro",
               city: "Caxambu",
               state: "Minas Gerais",
               postal_code: "37440-000"
             } = new_address

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

  describe "add_payment_info/2" do
    @valid_payment_info %PaymentInfo{
      card_number: "4547568497853654",
      card_holder_name: "John Doe",
      card_expiration: "12/22",
      card_brand: "VISA"
    }

    test "adds a new payment info to an account" do
      account = @valid_account |> Accounts.create_account!()

      payment_info = account |> Accounts.add_payment_info(@valid_payment_info)

      assert %PaymentInfo{
               card_number: "4547568497853654",
               card_holder_name: "John Doe",
               card_expiration: "12/22",
               card_brand: "VISA"
             } = payment_info

      assert payment_info.id != nil
    end
  end

  describe "remove_payment_info/2" do
    test "remove a payment info entry" do
      account =
        @valid_account
        |> Accounts.create_account!()

      payment_info = account |> Accounts.add_payment_info(@valid_payment_info)

      account |> Accounts.remove_payment_info(payment_info)

      account = Accounts.get_account("foo@bar.com")

      assert [] = account.payment_info_entries
    end
  end
end
