defmodule Sales.PaymentsTest do
  use Sales.DataCase, async: true

  alias Sales.Payments
  alias Sales.Payments.CreditCard

  @fake_credit_card %CreditCard{
    card_number: "45884547854874569",
    card_holder_name: "John Doe",
    card_expiration: "10/22",
    card_brand: "Visa"
  }

  describe "process_payment/2" do
    test "it raises when provided with a negative invoice value" do
      assert {:error, _} = Payments.process_payment(@fake_credit_card, invoice_total: 0)
    end

    test "it processes the payment -- expects fake data" do
      invoice_total = 15.98
      fake_data = %{payment_auth_code: "foo_bar_12_bar", invoice_total: 15.98}

      assert {:ok, fake_data} = Payments.process_payment(@fake_credit_card, invoice_total: 15.98)
    end
  end
end
