import React, { Component } from "react";
import gql from 'graphql-tag';
import { Query, Mutation } from 'react-apollo';
import { isUserLogged } from '../utils/user';
import { Link } from 'react-router-dom';
import { formatMoney } from '../utils/money';

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

const CANCEL_BASKET = gql`
mutation CancelBasket($id: Int!) {
  cancelBasket(id: $id) {
    status
  }
}
`;

class Basket extends Component {

  itensCount = (itens) => itens.map(item => item.quantity).reduce(((a, b) => a + b), 0);

  basketTotal = (itens) => formatMoney(itens.map(item => parseFloat(item.price)).reduce(((a, b) => a + b), 0));

  render() {
    return isUserLogged() ?
      (
        <Mutation
          mutation={CANCEL_BASKET}
        >
          {(cancelBasket, _) => (
            <Query query={SHOPPING_BASKET}>
              {({ loading, error, data }) => {
                if (loading) return "Loading...";
                if (error) return null;
                if (!data.basket.basketItens.length) return null;

                return (
                  <div className="btn-group">
                    <button className="btn btn-secondary dropdown-toggle" type="button" id="dropdownBasket" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                      <i className="material-icons">shopping_basket</i>
                      <span className="badge badge-light">{this.itensCount(data.basket.basketItens)}</span>
                    </button>

                    <div className="dropdown-menu dropdown-menu-right">
                      {data.basket.basketItens.map(item => (
                        <small key={item.id} className="dropdown-item">{item.productName} ({item.quantity}) - {formatMoney(item.price)}</small>
                      ))}
                      <hr />
                      <div>
                        <h6 className="dropdown-item text-right">Total: {this.basketTotal(data.basket.basketItens)}</h6>
                        <div className="text-center">
                          <div className="btn-group">
                            <Link to="/checkout" className="btn btn-primary">Checkout</Link>
                            <button
                              className="btn btn-secondary"
                              onClick={
                                cancelBasket.bind(
                                  this,
                                  {
                                    variables: { id: data.basket.id },
                                    refetchQueries: [{ query: SHOPPING_BASKET }]
                                  })}
                            >
                              <i className="material-icons">clear</i>
                            </button>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                )
              }}
            </Query>
          )}
        </Mutation>)
      : null
  }
}

export default Basket;