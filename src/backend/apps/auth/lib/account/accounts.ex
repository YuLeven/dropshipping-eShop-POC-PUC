defmodule Auth.Accounts do
  alias Auth.Accounts.{User, Address, PaymentInfo}
  alias Auth.Repo
  import Ecto.Query

  @secret_key Application.get_env(:auth, AuthWeb.Endpoint)[:secret_key_base]

  def create_account!(%{name: name, surname: surname, email: email, password: password}) do
    User.changeset(%User{}, %{
      name: name,
      surname: surname,
      email: email,
      hashed_password: Bcrypt.hash_pwd_salt(password)
    })
    |> Repo.insert!()
  end

  def authenticate(email: email, password: password) do
    case get_account(email) do
      nil ->
        {:error, "Account not found"}

      account ->
        if password |> Bcrypt.verify_pass(account.hashed_password) do
          {:ok, issue_token(account), account}
        else
          {:error, "Wrong password"}
        end
    end
  end

  def get_account(email) do
    from(
      u in User,
      where: u.email == ^email,
      preload: [:shipping_addresses, :payment_info_entries]
    )
    |> Repo.one()
  end

  def add_shipping_address(%User{} = user, %Address{} = address) do
    Address.changeset(address, %{user_id: user.id})
    |> Repo.insert!()
  end

  def remove_shipping_address(%User{} = user, %Address{} = address) do
    address |> Repo.delete!()
  end

  def add_payment_info(%User{} = user, %PaymentInfo{} = payment_info) do
    PaymentInfo.changeset(payment_info, %{user_id: user.id})
    |> Repo.insert!()
  end

  def remove_payment_info(%User{} = user, %PaymentInfo{} = payment_info) do
    payment_info |> Repo.delete!()
  end

  defp random_nonce do
    :crypto.strong_rand_bytes(15)
    |> Base.url_encode64()
    |> binary_part(0, 15)
  end

  defp issue_token(%User{} = user) do
    JsonWebToken.sign(
      %{
        iss: "dropshipping-poc|auth",
        sub: user.id,
        aud: "dropshipping-poc|auth|sales",
        nonce: random_nonce(),
        exp: Time.utc_now() |> Time.add(60),
        iat: Time.utc_now(),
        email: user.email
      },
      %{key: @secret_key}
    )
  end
end
