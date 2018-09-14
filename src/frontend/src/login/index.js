import React, { Component } from "react";
import gql from 'graphql-tag';
import authClient from '../clients/auth-client';
import { isUserLogged } from "../utils/user";

const LOGIN_QUERY = gql`
query Login($email: String!, $password: String!) {
  login(email: $email password: $password) {
    token
  }
}
`;

class Login extends Component {

  state = {
    loginFailed: false,
    loginFailureErrorMessage: ""
  }

  componentWillMount() {
    if (isUserLogged()) {
      this.props.history.push('/');
    }
  }

  async login(email, password) {
    try {
      const response = await authClient.query({
        query: LOGIN_QUERY,
        variables: { email, password }
      });

      localStorage.setItem('token', response.data.login.token);
      this.props.history.push('/');

    } catch (error) {
      this.setState({
        loginFailed: true,
        loginFailureErrorMessage: "Wrong account or username provided"
      })
    }
  }

  render() {
    let emailInput;
    let passwordInput;

    return (
      <div className="container h-100 mt-5">
        <div className="row h-100 justify-content-center align-items-center">
          <div className="card text-center" style={{ width: '25rem' }}>
            {(this.state.loginFailed) ? (
              <div className="alert alert-danger alert-dismissible fade show" role="alert">
                {this.state.loginFailureErrorMessage}
                <button type="button" className="close" data-dismiss="alert" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
            ) : null}
            <form
              className="form-signin p-2"
              onSubmit={e => {
                e.preventDefault();
                this.login(emailInput.value, passwordInput.value);
                emailInput.value = "";
                passwordInput.value = "";
              }}
            >
              <i className="material-icons">lock_open</i>
              <h1 className="h3 mb-3 font-weight-normal">Please sign in</h1>
              <label htmlFor="inputEmail" className="sr-only">Email address</label>
              <input ref={node => { emailInput = node }} type="email" id="inputEmail" className="form-control" placeholder="Email address" required={true} autoFocus={true} />
              <label htmlFor="inputPassword" className="sr-only">Password</label>
              <input ref={node => { passwordInput = node }} type="password" id="inputPassword" className="form-control" placeholder="Password" required={true} />
              <button className="btn btn-lg btn-primary btn-block mt-3" type="submit">Sign in</button>
            </form>
          </div>
        </div>
      </div>
    )
  }
}

export default Login;