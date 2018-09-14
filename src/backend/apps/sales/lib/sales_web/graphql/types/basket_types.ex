defmodule SalesWeb.GraphQL.Schema.BasketTypes do
  use Absinthe.Schema.Notation
  alias SalesWeb.GraphQL.Resolvers
  alias SalesWeb.GraphQL.Middleware.Authentication

  object :basket do
    field(:id, :integer)
    field(:buyer_id, :integer)
    field(:status, :string)
    field(:basket_itens, list_of(:basket_item))
  end

  object :basket_item do
    field(:id, :integer)
    field(:product_id, :integer)
    field(:product_name, :string)
    field(:price, :float)
    field(:quantity, :integer)
    field(:picture_url, :string)
  end

  input_object :add_product do
    field(:product_id, :integer)
  end

  object :basket_queries do
    field :basket, :basket do
      middleware(Authentication)
      resolve(&Resolvers.Basket.get_basket/3)
    end
  end

  input_object :credit_card_input do
    field(:card_number, non_null(:string))
    field(:card_holder_name, non_null(:string))
    field(:card_expiration, non_null(:string))
    field(:card_brand, non_null(:string))
    field(:card_csc, non_null(:string))
  end

  object :basket_mutations do
    field :add_product_to_basket, :basket do
      middleware(Authentication)
      arg(:product_id, non_null(:integer))
      resolve(&Resolvers.Basket.add_product/3)
    end

    field :remove_product_from_basket, :basket do
      middleware(Authentication)
      arg(:product_id, non_null(:integer))
      resolve(&Resolvers.Basket.remove_product/3)
    end

    field :checkout_basket, :basket do
      middleware(Authentication)
      arg(:credit_card_data, non_null(:credit_card_input))
      arg(:address_id, non_null(:integer))

      resolve(&Resolvers.Basket.checkout/3)
    end

    field :cancel_basket, :basket do
      middleware(Authentication)
      arg(:id, non_null(:integer))

      resolve(&Resolvers.Basket.cancel_basket/3)
    end
  end
end
