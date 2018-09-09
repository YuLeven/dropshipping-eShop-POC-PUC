defmodule Auth.Accounts do
  alias Auth.Accounts.{User, Address, PaymentInfo}

  def create_account(%{name: name, surname: surname, email: email, password: password}) do
    # TODO: Implement
  end

  def authenticate(%{email: email, password: password}) do
    # TODO: Implement
  end

  def change_password(%{email: email, password: password}) do
    # TODO: Implement
  end

  def get_account(%{email: email}) do
    # TODO: Implement
  end

  def add_shipping_address(%User{}, %Address{}) do
    # TODO: Implement
  end

  def remove_shipping_address(%User{}, %Address{}) do
    # TODO: Implement
  end

  def add_payment_info(%User{}, %PaymentInfo{}) do
    # TODO: Implement
  end

  def remove_payment_info(%User{}, %PaymentInfo{}) do
    # TODO: Implement
  end
end
