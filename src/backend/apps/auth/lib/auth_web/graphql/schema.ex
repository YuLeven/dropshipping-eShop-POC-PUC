defmodule AuthWeb.GraphQL.Schema do
  alias AuthWeb.GraphQL.Schema
  use Absinthe.Schema

  import_types(Schema.AccountTypes)
  import_types(Schema.AddressTypes)
  import_types(Schema.PaymentInfoTypes)

  query do
    import_fields(:account_queries)
  end

  mutation do
    import_fields(:addresses_mutations)
    import_fields(:payment_info_types)
    import_fields(:account_mutations)
  end
end
