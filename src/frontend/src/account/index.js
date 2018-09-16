import React, { Component } from "react";
import gql from "graphql-tag";
import { Query, Mutation } from "react-apollo";
import authClient from '../clients/auth-client';
import Addresses from './addresses';
import PaymentMethods from './payment-methods';

const ACCOUNT_QUERY = gql`
{
  me {
    email
    name
    surname
    paymentInfoEntries {
      id
      cardBrand
      cardExpiration
      cardHolderName
      cardNumber
    }
    shippingAddresses {
      id
      city
      complement
      district
      postalCode
      residenceNumber
      state
      street
    }
  }
}
`;

const ADD_SHIPPING_ADDRESS_MUTATION = gql`
mutation AddShippingAddress($street: String!, $residenceNumber: Int!, $complement: String!, $district: String!, $city: String!, $state: String!, $postalCode: String!){
  addShippingAddress(address: {
    street: $street
    residenceNumber: $residenceNumber
    complement: $complement
    district: $district
    city: $city
    state: $state
    postalCode: $postalCode
  }) {
    id
  }
}
`;

const REMOVE_SHIPPING_ADDRESS_MUTATION = gql`
mutation RemoveShippingAddress($id: Int!){
  removeShippingAddress(addressId: $id) {
    id
  }
}
`;

const ADD_PAYMENT_METHOD_MUTATION = gql`
mutation AddPayment($cardBrand: String!, $cardExpiration: String!, $cardHolderName: String!, $cardNumber: String!) {
  addPaymentInfo(paymentInfo: {
    cardBrand: $cardBrand
    cardExpiration: $cardExpiration
    cardHolderName: $cardHolderName
    cardNumber: $cardNumber
  }) {
    id
  }
}
`;

const REMOVE_PAYMENT_METHOD_MUTATION = gql`
mutation RemovePayment($id: Int!) {
  removePaymentInfo(paymentInfoId: $id) {
    id
  }
}
`;

class Account extends Component {
  render() {
    return (
      <Mutation mutation={ADD_SHIPPING_ADDRESS_MUTATION} client={authClient}>
        {addAddress => {
          return (
            <Mutation mutation={REMOVE_SHIPPING_ADDRESS_MUTATION} client={authClient}>
              {removeAddress => {
                return (
                  <Mutation mutation={ADD_PAYMENT_METHOD_MUTATION} client={authClient}>
                    {addPaymentMethod => {
                      return (
                        <Mutation mutation={REMOVE_PAYMENT_METHOD_MUTATION} client={authClient}>
                          {removePaymentMethod => {
                            return (
                              <Query query={ACCOUNT_QUERY} client={authClient}>
                                {({ loading, error, data }) => {
                                  if (loading) return "Loading...";
                                  if (error) return "Error";

                                  return (
                                    <div>
                                      <h4>{data.me.name} {data.me.surname}</h4>
                                      <h5>{data.me.email}</h5>
                                      <hr />
                                      <div className="row">
                                        <Addresses
                                          accountQuery={ACCOUNT_QUERY}
                                          addAddress={addAddress}
                                          removeAddress={removeAddress}
                                          shippingAddresses={data.me.shippingAddresses}
                                        />
                                        <hr />
                                        <PaymentMethods
                                          accountQuery={ACCOUNT_QUERY}
                                          paymentMethods={data.me.paymentInfoEntries}
                                          addPaymentMethod={addPaymentMethod}
                                          removePaymentMethod={removePaymentMethod}
                                        />
                                      </div>
                                    </div>
                                  )
                                }}
                              </Query>
                            )
                          }}
                        </Mutation>
                      )
                    }}
                  </Mutation>
                )
              }}
            </Mutation>
          )
        }}
      </Mutation>
    )
  }
}

export default Account;