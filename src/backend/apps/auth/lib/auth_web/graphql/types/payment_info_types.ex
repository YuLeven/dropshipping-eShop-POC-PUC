defmodule AuthWeb.GraphQL.Schema.PaymentInfoTypes do
  use Absinthe.Schema.Notation
  alias AuthWeb.GraphQL.Resolvers
  alias AuthWeb.GraphQL.Middleware.Authentication

  input_object :new_payment_info do
    field(:card_number, non_null(:string))
    field(:card_holder_name, non_null(:string))
    field(:card_expiration, non_null(:string))
    field(:card_brand, non_null(:string))
  end

  object :payment_info do
    field(:id, :integer)
    field(:card_number, :string)
    field(:card_holder_name, :string)
    field(:card_expiration, :string)
    field(:card_brand, :string)
  end

  object :payment_info_types do
    field :add_payment_info, type: list_of(:payment_info) do
      middleware(Authentication)
      arg(:payment_info, non_null(:new_payment_info))

      resolve(&Resolvers.Account.add_payment_info/3)
    end

    field :remove_payment_info, type: list_of(:payment_info) do
      middleware(Authentication)
      arg(:payment_info_id, non_null(:integer))

      resolve(&Resolvers.Account.remove_payment_info/3)
    end
  end
end
