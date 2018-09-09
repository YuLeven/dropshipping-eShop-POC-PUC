defmodule Sales.Payments do
  alias Sales.Payments.CreditCard

  def process_payment(_, invoice_total: invoice_total) when invoice_total <= 0 do
    {:error, "A positive invoice must be provided for billing"}
  end

  def process_payment(%CreditCard{} = cc_data, invoice_total: invoice_total) do
    fake_payment_data = %{
      invoice_total: invoice_total,
      payment_auth_code: "foo_bar_12_bar"
    }

    {:ok, fake_payment_data}
  end
end
