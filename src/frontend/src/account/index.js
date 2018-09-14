import React, { Component } from "react";
import gql from "graphql-tag";
import { Query, Mutation } from "react-apollo";
import authClient from '../clients/auth-client';

const $ = window.$;
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
      street
      residenceNumber
      city
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

const Addresses = ({ shippingAddresses, addAddress, removeAddress }) => (
  <div className="col-md-6">
    <div className="card">
      <div className="card-header">Shipping addresses</div>
      <div className="card-body">
        <ul className="list-group list-group-flush">
          {shippingAddresses.map(address => (
            <li
              key={address.id}
              className="list-group-item"
            >
              {address.street}, {address.residenceNumber} - {address.city}
              <span className="float-right">
                <i
                  className="material-icons"
                  style={{ cursor: 'pointer' }}
                  onClick={() => {
                    removeAddress({
                      variables: { id: address.id },
                      refetchQueries: [{ query: ACCOUNT_QUERY }]
                    })
                  }}
                >
                  close
                </i>
              </span>
            </li>
          ))}
        </ul>
        <AddAddressModal addAddress={addAddress} />
        <button type="button" className="btn btn-primary mt-2" data-toggle="modal" data-target="#newAddressModal">
          Add Shipping Address
        </button>
      </div>
    </div>
  </div>
);

const AddAddressModal = ({ addAddress }) => {
  let street;
  let residenceNumber;
  let complement;
  let district;
  let city;
  let state;
  let postalCode;

  return (
    <div className="modal fade" id="newAddressModal" tabIndex="-1" role="dialog" aria-labelledby="newAddressModalLabel" aria-hidden="true">
      <div className="modal-dialog" role="document">
        <div className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title" id="newAddressModalLabel">Modal title</h5>
            <button type="button" className="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div className="modal-body">
            <form
              className="needs-validation"
              onSubmit={e => {
                e.preventDefault();

                addAddress({
                  variables: {
                    street: street.value,
                    residenceNumber: parseInt(residenceNumber.value),
                    complement: complement.value,
                    district: district.value,
                    city: city.value,
                    state: state.value,
                    postalCode: postalCode.value
                  },
                  refetchQueries: [
                    { query: ACCOUNT_QUERY }
                  ]
                });

                $('#newAddressModal').modal('hide')
              }}
            >
              <div className="row">
                <div className="col-md-12 mb-3">
                  <label htmlFor="street">Street</label>
                  <input ref={node => { street = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" required />
                  <div className="invalid-feedback">
                    Street is required.
                      </div>
                </div>
              </div>
              <div className="row">
                <div className="col-md-6 mb-3">
                  <label htmlFor="residenceNumber">Residence number</label>
                  <input ref={node => { residenceNumber = node }} type="number" className="form-control" id="firstName" placeholder="" defaultValue="" required />
                  <div className="invalid-feedback">
                    Residence number is required.
                      </div>
                </div>
                <div className="col-md-6 mb-3">
                  <label htmlFor="complement">Complement</label>
                  <input ref={node => { complement = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" />
                </div>
              </div>
              <div className="row">
                <div className="col-md-6 mb-3">
                  <label htmlFor="district">District</label>
                  <input ref={node => { district = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" required />
                  <div className="invalid-feedback">
                    District number is required.
                      </div>
                </div>
                <div className="col-md-6 mb-3">
                  <label htmlFor="city">City</label>
                  <input ref={node => { city = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" />
                  <div className="invalid-feedback">
                    City number is required.
                      </div>
                </div>
              </div>
              <div className="row">
                <div className="col-md-6 mb-3">
                  <label htmlFor="state">State</label>
                  <input ref={node => { state = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" required />
                  <div className="invalid-feedback">
                    State is required.
                      </div>
                </div>
                <div className="col-md-6 mb-3">
                  <label htmlFor="postalCode">Postal Code</label>
                  <input ref={node => { postalCode = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" />
                  <div className="invalid-feedback">
                    Postal code number is required.
                      </div>
                </div>
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="submit" className="btn btn-primary">Save changes</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  )
}

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
                            <Addresses addAddress={addAddress} removeAddress={removeAddress} shippingAddresses={data.me.shippingAddresses} />
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