import React, { Component } from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";
import "../compiled/core/assets/App.css";
import Navbar from "./Navbar";
import { ApolloProvider } from 'react-apollo';
import client from '../clients/sales-client';
import ProductGrid from '../product-grid';
import Login from '../login';

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
            </div>
          </div>
        </Router>
      </ApolloProvider>
    );
  }
}

export default App;
