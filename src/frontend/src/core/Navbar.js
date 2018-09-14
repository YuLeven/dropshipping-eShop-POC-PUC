import React, { Component } from "react";
import authClient from '../clients/auth-client';
import gql from 'graphql-tag';
import { Query } from 'react-apollo';
import { Link } from 'react-router-dom';
import { isUserLogged } from '../utils/user';

const ME = gql`
{
  me {
    name
  }
}
`;

const SHOPPING_BASKET = gql`
{
  basket {
    basketItens {
      id
      productName
      quantity
      price
    }
  }
}
`;

const itensCount = (itens) => itens.map(item => item.quantity).reduce((a, b, []) => a + b);
const basketTotal = (itens) => itens.map(item => parseFloat(item.price)).reduce((a, b, []) => a + b);

const Basket = () => {
  return isUserLogged() ?
    (
      <Query query={SHOPPING_BASKET}>
        {({ loading, error, data }) => {
          if (loading) return "Loading...";
          if (error) return null;

          return (
            <div className="btn-group">
              <button className="btn btn-secondary dropdown-toggle" type="button" id="dropdownBasket" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i className="material-icons">shopping_basket</i>
                <span className="badge badge-light">{itensCount(data.basket.basketItens)}</span>
              </button>

              <div className="dropdown-menu dropdown-menu-right">
                {data.basket.basketItens.map(item => (
                  <small key={item.id} className="dropdown-item">{item.productName} ({item.quantity}) - ${item.price}</small>
                ))}
                <hr />
                <h6 className="dropdown-item text-right">Total: ${basketTotal(data.basket.basketItens)}</h6>
                <Link to="/" className="dropdown-item text-center active">Checkout</Link>
              </div>
            </div>
          )
        }}
      </Query>)
    : null
}

class LoginButton extends Component {

  logout = () => {
    localStorage.removeItem('token');
    window.location.href = "/";
  }

  render() {
    return isUserLogged() ?
      (
        <Query query={ME} client={authClient} >
          {({ loading, error, data }) => {
            if (loading) return "Loading...";
            if (error) return "Error";

            return (
              <div className="btn-group ml-2">
                <button className="btn btn-secondary">
                  {data.me.name}
                </button>
                <button type="button" className="btn btn-secondary dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                  <span className="sr-only">Toggle Dropdown</span>
                </button>

                <div className="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenuLink">
                  <button className="dropdown-item" onClick={this.logout}>Logout</button>
                </div>
              </div>
            );
          }}
        </Query>)
      : <Link to="/login" className="btn btn-secondary">Login</Link>
  }
}

class Navbar extends Component {
  render() {
    return (
      <nav className={"navbar navbar-light bg-light"}>
        <div className="dropdown show">
          <div className="btn-toolbar">
            <Basket />
            <LoginButton />
          </div>
        </div>
        <a className={"navbar-brand"}>Dropshipping e-Shop</a>
      </nav>
    )
  }
}

export default Navbar;
