defmodule AuthWeb.GraphQL.Schema.AddressTypes do
  use Absinthe.Schema.Notation
  alias AuthWeb.GraphQL.Resolvers
  alias AuthWeb.GraphQL.Schema

  input_object :new_shipping_address do
    field(:street, non_null(:string))
    field(:residence_number, non_null(:integer))
    field(:complement, :string)
    field(:district, non_null(:string))
    field(:city, non_null(:string))
    field(:state, non_null(:string))
    field(:postal_code, non_null(:string))
  end

  object :shipping_address do
    field(:id, :integer)
    field(:street, :string)
    field(:residence_number, :string)
    field(:complement, :string)
    field(:district, :string)
    field(:city, :string)
    field(:state, :string)
    field(:postal_code, :string)
  end

  object :addresses_mutations do
    field :add_shipping_address, type: :user do
      arg(:email, non_null(:string))
      arg(:address, non_null(:new_shipping_address))

      resolve(&Resolvers.Account.add_shipping_address/3)
    end

    field :remove_shipping_address, type: :user do
      arg(:email, non_null(:string))
      arg(:address_id, non_null(:integer))

      resolve(&Resolvers.Account.remove_shipping_address/3)
    end
  end
end
