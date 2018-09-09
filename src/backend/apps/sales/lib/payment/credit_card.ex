defmodule Sales.Payments.CreditCard do
  defstruct [:card_number, :card_holder_name, :card_expiration, :card_brand, :card_csc]
end
