import React, { Component } from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";
import "../compiled/core/assets/App.css";
import Navbar from "./Navbar";
import { ApolloProvider } from 'react-apollo';
import client from '../clients/sales_client';
import gql from 'graphql-tag';
import { Query } from 'react-apollo';

const productsQuery = gql`
  query Products {
    products {
      id
      name
      description
      pictureUrl
      price
    }
  }
`;

const Home = () => (
  <div>
    <h2>Home</h2>
    <Query query={productsQuery}>
      {({ loading, error, data }) => {
        if (loading) return "Loading...";
        if (error) return "Error";

        return data.products.map(product => (<p key={product.id}>{product.name}</p>))
      }}
    </Query>
  </div>
);

const Account = () => (
  <div>
    <h2>Account</h2>
  </div>
);

class App extends Component {
  render() {
    return (
      <ApolloProvider client={client}>
        <Router>
          <div>
            <Navbar />
            <Route exact path="/" component={Home} />
            <Route path="/account" component={Account} />
          </div>
        </Router>
      </ApolloProvider>
    );
  }
}

export default App;
