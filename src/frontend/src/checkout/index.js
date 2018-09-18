import React, { Component } from 'react';
import gql from 'graphql-tag';
import { Query, Mutation } from 'react-apollo';
import ProductOverview from './product-overview';
import authClient from '../clients/auth-client';
import { Link } from 'react-router-dom';
import { formatCCValue } from '../utils/money';

const SHOPPING_BASKET = gql`
{
  basket {
    id
    basketItens {
      id
      productName
      
      quantity
      price
    }
  }
}
`;

const ACCOUNT_QUERY = gql`
{
  me {
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

const CHECKOUT_MUTATION = gql`
mutation Checkout($addressId: Int!, 
                  $cardBrand: String!, 
                  $cardCsc: String!, 
                  $cardExpiration: String!, 
                  $cardHolderName: String!, 
                  $cardNumber: String!) {
  checkoutBasket(
    addressId: $addressId, 
    creditCardData: {
      cardBrand: $cardBrand
      cardCsc: $cardCsc
      cardExpiration: $cardExpiration
      cardHolderName: $cardHolderName
      cardNumber: $cardNumber
  }) {
    status
  }
}
`;

const $ = window.$;
class Checkout extends Component {

  state = {
    selectedAddress: null,
    selectedPaymentMethod: null,
    cardCsc: null
  }

  selectAddress(id) {
    this.setState({ ...this.state, selectedAddress: id });
  }

  isAddressSelected(address) {
    return this.state.selectedAddress === address.id;
  }

  isPaymentMethodSelected(paymentInfo) {
    return this.state.selectedPaymentMethod === paymentInfo.id;
  }

  selectPaymentInfo(id) {
    this.setState({ ...this.state, selectedPaymentMethod: id });
  }

  isOrderPossible() {
    return this.state.selectedPaymentMethod != null &&
      this.state.selectedAddress != null &&
      this.state.cardCsc && this.state.cardCsc.match(/\d{3}/);
  }

  checkout(mutation, paymentInfoEntries) {
    mutation({
      variables: {
        ...paymentInfoEntries.find(entry => entry.id === this.state.selectedPaymentMethod),
        cardCsc: this.state.cardCsc,
        addressId: this.state.selectedAddress,
      }
    });

    $('#confirmationOrder').modal('show');
  }

  render() {
    return (
      <Query query={SHOPPING_BASKET}>
        {({ loading, error, data: { basket } }) => {

          if (loading) return 'Loading...';
          if (error) return 'Error...';
          if (!basket.basketItens.length) this.props.history.push('/');

          return (
            <Query query={ACCOUNT_QUERY} client={authClient} >
              {({ loading, error, data: { me } }) => {

                if (loading) return 'Loading...';
                if (error) return 'Error...';

                return (
                  <Mutation mutation={CHECKOUT_MUTATION}>
                    {checkout => {
                      return (
                        <div className="row">
                          <ProductOverview basketItens={basket.basketItens} />
                          <div className="col-md-8 order-md-1">
                            <h4 className="mb-3">Billing address</h4>
                            {
                              me.shippingAddresses.length ?
                                <small>Click to select</small> :
                                <Link to="/account">Click here to register a shipping address</Link>
                            }
                            <div className="card-deck">
                              {me.shippingAddresses.map(address => (
                                <div
                                  onClick={this.selectAddress.bind(this, address.id)}
                                  key={address.id}
                                  className="card"
                                  style={{ cursor: 'pointer' }}
                                >
                                  <div className={`card-header ${this.isAddressSelected(address) ? "bg-primary text-white" : ""}`}>
                                    {this.isAddressSelected(address) ? "Ship to this address" : " "}
                                  </div>
                                  <div className="card-body">
                                    <p className="card-text">{address.street}, {address.residenceNumber} - {address.district}</p>
                                    <p className="card-text">{address.city} - {address.state} - {address.postalCode}</p>
                                  </div>
                                </div>
                              ))}
                            </div>
                            <hr />
                            <h4 className="mb-3">Payment method</h4>
                            {
                              me.paymentInfoEntries.length ?
                                <small>Click to select</small> :
                                <Link to="/account">Click here to register a payment method</Link>
                            }
                            <div className="card-deck">
                              {me.paymentInfoEntries.map(paymentInfo => (
                                <div
                                  onClick={this.selectPaymentInfo.bind(this, paymentInfo.id)}
                                  key={paymentInfo.id}
                                  className="card"
                                  style={{ cursor: 'pointer' }}
                                >
                                  <div className={`card-header ${this.isPaymentMethodSelected(paymentInfo) ? "bg-primary text-white" : ""}`}>
                                    {this.isPaymentMethodSelected(paymentInfo) ? "Pay with this card" : " "}
                                  </div>
                                  <div className="card-body">
                                    <p className="card-text">{paymentInfo.cardHolderName}</p>
                                    <p className="card-text">{formatCCValue(paymentInfo.cardNumber)}</p>
                                    {this.isPaymentMethodSelected(paymentInfo) ?
                                      <input onChange={(e) => this.setState({ ...this.state, cardCsc: e.target.value })} type="password" className="form-control" id="cardCsc" pattern="\d{3}" placeholder="" defaultValue="" required /> :
                                      null
                                    }
                                  </div>
                                </div>
                              ))}
                            </div>
                            <button
                              className="btn btn-primary btn-lg btn-block mt-4"
                              type="button"
                              onClick={this.checkout.bind(this, checkout, me.paymentInfoEntries)}
                              disabled={!this.isOrderPossible()}
                            >
                              Place order
                            </button>
                          </div>
                          <div className="modal" id="confirmationOrder" tabIndex="-1" role="dialog">
                            <div className="modal-dialog" role="document">
                              <div className="modal-content">
                                <div className="modal-body">
                                  <h4>Your order was received and will be processed shortly.</h4>
                                </div>
                                <div className="modal-footer">
                                  <button type="button" className="btn btn-primary" onClick={() => window.location.href = '/orders'} data-dismiss="modal">View order progress</button>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      );
                    }}
                  </Mutation>
                );
              }}
            </Query>
          )
        }}
      </Query>
    );
  }
}

export default Checkout;