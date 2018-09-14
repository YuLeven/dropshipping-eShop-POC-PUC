import React, { Component } from "react";
import authClient from '../clients/auth-client';
import gql from 'graphql-tag';
import { Query } from 'react-apollo';
import { Link } from 'react-router-dom';
import { isUserLogged } from '../utils/user';
import Basket from '../basket';

const ME = gql`
{
  me {
    name
  }
}
`;


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
                  <Link to="/account" className="dropdown-item">Account</Link>
                  <a className="dropdown-item" onClick={this.logout}>Logout</a>
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
        <Link to="/" className={"navbar-brand"}>Dropshipping e-Shop</Link>
      </nav>
    )
  }
}

export default Navbar;
