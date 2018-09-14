defmodule AuthWeb.GraphQL.Resolvers.Account do
  alias Auth.Accounts
  alias Auth.Accounts.{User, Address, PaymentInfo}

  @user_not_found_exception {:error, "Informed user could not be found."}

  def get_account(_, _, %{context: %{current_user_email: email}}) do
    case Accounts.get_account(email) do
      nil ->
        {:error, "User with email #{email} not found."}

      user ->
        {:ok, user}
    end
  end

  def add_shipping_address(_, %{address: address}, %{context: %{current_user_email: email}}) do
    Accounts.get_account(email)
    |> add_shipping_address(address)
  end

  def remove_shipping_address(_, %{address_id: address_id}, %{
        context: %{current_user_email: email}
      }) do
    user = Accounts.get_account(email)
    address = user.shipping_addresses |> Enum.find(fn ad -> ad.id == address_id end)

    user |> remove_shipping_address(address)
  end

  def add_payment_info(_, %{payment_info: payment_info}, %{context: %{current_user_email: email}}) do
    Accounts.get_account(email)
    |> add_payment_info(payment_info)
  end

  def remove_payment_info(_, %{payment_info_id: payment_info_id}, %{
        context: %{current_user_email: email}
      }) do
    user = Accounts.get_account(email)
    payment_info = user.payment_info_entries |> Enum.find(fn pi -> pi.id == payment_info_id end)

    user |> remove_payment_info(payment_info)
  end

  def new_account(_, %{account: new_account}, _) do
    try do
      Accounts.create_account!(new_account)
      {:ok, Accounts.get_account(new_account.email)}
    rescue
      Ecto.InvalidChangesetError -> {:error, "Please verify the input data."}
    end
  end

  def login(_, %{email: email, password: password}, _) do
    case Accounts.authenticate(email: email, password: password) do
      {:ok, token, user} ->
        {:ok, %{token: token, user: user}}

      {:error, message} ->
        {:error, message}
    end
  end

  defp add_shipping_address(nil, _), do: @user_not_found_exception

  defp add_shipping_address(%User{} = user, address) do
    user |> Accounts.add_shipping_address(struct(Address, address))

    {:ok, user_addresses(user.email)}
  end

  defp add_payment_info(nil, _), do: @user_not_found_exception

  defp add_payment_info(%User{} = user, payment_info) do
    user |> Accounts.add_payment_info(struct(PaymentInfo, payment_info))

    {:ok, user_payment_info_entries(user.email)}
  end

  defp remove_shipping_address(nil, _), do: @user_not_found_exception
  defp remove_shipping_address(_, nil), do: {:error, "Informed address could not be found"}

  defp remove_shipping_address(%User{} = user, address) do
    user |> Accounts.remove_shipping_address(address)

    {:ok, user_addresses(user.email)}
  end

  defp remove_payment_info(_, nil), do: {:error, "Informed payment info could not be found"}

  defp remove_payment_info(%User{} = user, payment_info) do
    user |> Accounts.remove_payment_info(payment_info)

    {:ok, user_payment_info_entries(user.email)}
  end

  defp user_addresses(email), do: Accounts.get_account(email).shipping_addresses
  defp user_payment_info_entries(email), do: Accounts.get_account(email).payment_info_entries
end
