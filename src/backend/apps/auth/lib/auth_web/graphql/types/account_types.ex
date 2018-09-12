defmodule AuthWeb.GraphQL.Schema.AccountTypes do
  use Absinthe.Schema.Notation
  alias Auth.Accounts
  alias AuthWeb.GraphQL.Resolvers

  object :login_response do
    field(:token, :string)
    field(:user, :user)
  end

  object :user do
    field(:id, :string)
    field(:email, :string)
    field(:name, :string)
    field(:surname, :string)
    field(:shipping_addresses, list_of(:shipping_address))
    field(:payment_info_entries, list_of(:payment_info))
  end

  input_object :new_account do
    field(:email, :string)
    field(:name, :string)
    field(:surname, :string)
    field(:password, :string)
  end

  object :account_queries do
    field :user, :user do
      arg(:email, non_null(:string))

      resolve(&Resolvers.Account.get_account/3)
    end

    field :login, :login_response do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Account.login/3)
    end
  end

  object :account_mutations do
    field :create_account, :user do
      arg(:account, non_null(:new_account))

      resolve(&Resolvers.Account.new_account/3)
    end
  end
end
