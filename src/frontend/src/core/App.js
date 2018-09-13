import React, { Component } from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";
import "../compiled/core/assets/App.css";
import Navbar from "./Navbar";

const Home = () => (
  <div>
    <h2>Home</h2>
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
      <Router>
        <div>
          <Navbar />
          <Route exact path="/" component={Home} />
          <Route path="/account" component={Account} />
        </div>
      </Router>
    );
  }
}

export default App;
