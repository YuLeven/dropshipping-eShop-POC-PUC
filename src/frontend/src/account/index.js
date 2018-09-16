import React, { Component } from "react";
import gql from "graphql-tag";
import { Query, Mutation } from "react-apollo";
import authClient from '../clients/auth-client';
import Addresses from './addresses';

const ACCOUNT_QUERY = gql`
{
  me {
    email
    name
    surname
    paymentInfoEntries {
      id
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

const PaymentInfos = ({ paymentInfoEntries }) => (
  <div className="col-md-6">
    <div className="card">
      <div className="card-header">Payment methods</div>
      <div className="card-body">
        <ul className="list-group list-group-flush">
          {paymentInfoEntries.map(paymentInfo => (
            <li className="list-group-item">{paymentInfo.cardHolderName}</li>
          ))}
        </ul>
        <a className="btn btn-primary mt-2">Add payment method</a>
      </div>
    </div>
  </div>
);


class Account extends Component {
  render() {
    return (
      <Mutation mutation={ADD_SHIPPING_ADDRESS_MUTATION} client={authClient}>
        {addAddress => {
          return (
            <Mutation mutation={REMOVE_SHIPPING_ADDRESS_MUTATION} client={authClient}>
              {removeAddress => {
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
                            <PaymentInfos paymentInfoEntries={data.me.paymentInfoEntries} />
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
  }
}

export default Account;