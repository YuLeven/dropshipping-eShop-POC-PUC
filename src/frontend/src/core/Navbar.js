import React from "react";
import authClient from '../clients/auth_client';
import gql from 'graphql-tag';
import { Query } from 'react-apollo';

const ME = gql`
{
  me {
    name
  }
}
`;

const LoginButton = () => {
  return localStorage.getItem('token') ?
    (
      <Query query={ME} client={authClient} >
        {({ loading, error, data }) => {
          if (loading) return "Loading...";
          if (error) return "Error";

          return (
            <div className="dropdown show">
              <a className="btn btn-secondary dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                {data.me.name}
              </a>

              <div className="dropdown-menu" aria-labelledby="dropdownMenuLink">
                <a className="dropdown-item" href="#">Logout</a>
              </div>
            </div>
          )
        }}
      </Query>)
    : <h1>Not logged</h1>
}

const Navbar = () => (
  <nav className={"navbar navbar-light bg-light"}>
    <a className={"navbar-brand"}>Dropshipping e-Shop</a>
    <LoginButton />
  </nav>
);

export default Navbar;
