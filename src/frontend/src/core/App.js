import React, { Component } from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";
import "../compiled/core/assets/App.css";
import Navbar from "./Navbar";
import { ApolloProvider } from 'react-apollo';
import client from '../clients/sales-client';
import ProductGrid from '../product-grid';
import Login from '../login';
import Register from '../register';
import Checkout from '../checkout';
import Account from '../account';
import Orders from '../orders';

class App extends Component {
  render() {
    return (
      <ApolloProvider client={client}>
        <Router>
          <div>
            <Navbar />
            <div className="container">
              <Route exact path="/" component={ProductGrid} />
              <Route path="/login" component={Login} />
              <Route path="/sign-up" component={Register} />
              <Route path="/checkout" component={Checkout} />
              <Route path="/account" component={Account} />
              <Route path="/orders" component={Orders} />
            </div>
          </div>
        </Router>
      </ApolloProvider>
    );
  }
}

export default App;
