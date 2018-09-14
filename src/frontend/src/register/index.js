import React, { Component } from "react";
import gql from "graphql-tag";
import { Mutation } from 'react-apollo';
import { isUserLogged } from '../utils/user';
import authClient from '../clients/auth-client';

const CREATE_ACCOUNT_MUTATION = gql`
mutation CreatAccount($email: String!, $name: String!, $surname: String!, $password: String) {
  createAccount(account: {
    email: $email
    name: $name
    surname: $surname
    password: $password
  }) {
    email
  }
}
`;

class Register extends Component {

  state = {
    creationFailed: false,
    creationFailureMessage: ""
  }

  componentWillMount() {
    if (isUserLogged()) this.props.history.push('/');
  }

  render() {

    let firstName;
    let lastName;
    let email;
    let password;
    let passwordConfirmation;

    return (
      <Mutation mutation={CREATE_ACCOUNT_MUTATION} client={authClient}>
        {(register, { data, error }) => {

          if (data && data.createAccount && data.createAccount.email) {
            this.props.history.push('/login')
          }

          return (
            <div className="text-center">
              <div className="row h-100 justify-content-center align-items-center">
                <div className="col-md-8 order-md-1">
                  <h4 className="mb-3">New Account</h4>
                  {(this.state.creationFailed || (error && error.message)) ?
                    <div className="alert alert-danger alert-dismissible fade show" role="alert">
                      {this.state.creationFailureMessage || error.message}
                      <button type="button" className="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                      </button>
                    </div> : null}
                  <form
                    className="needs-validation"
                    onSubmit={e => {
                      e.preventDefault();

                      if (password.value !== passwordConfirmation.value) {
                        this.setState({
                          creationFailed: true,
                          creationFailureMessage: "Passwords do not match"
                        });
                      }

                      register({
                        variables: { name: firstName.value, surname: lastName.value, email: email.value, password: password.value }
                      });
                    }}
                  >
                    <div className="row">
                      <div className="col-md-6 mb-3">
                        <label htmlFor="firstName">First name</label>
                        <input ref={node => { firstName = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" required />
                        <div className="invalid-feedback">
                          Valid first name is required.
                    </div>
                      </div>
                      <div className="col-md-6 mb-3">
                        <label htmlFor="lastName">Last name</label>
                        <input ref={node => { lastName = node }} type="text" className="form-control" id="lastName" placeholder="" defaultValue="" required />
                        <div className="invalid-feedback">
                          Valid last name is required.
                    </div>
                      </div>
                    </div>
                    <div className="mb-3">
                      <label htmlFor="email">Email <span className="text-muted">(Optional)</span></label>
                      <input ref={node => { email = node }} type="email" className="form-control" id="email" placeholder="you@example.com" required />
                      <div className="invalid-feedback">
                        Please enter a valid email address.
                    </div>
                    </div>
                    <div className="row">
                      <div className="col-md-6 mb-3">
                        <label htmlFor="password">Password</label>
                        <input ref={node => { password = node }} type="password" className="form-control" id="password" placeholder="" defaultValue="" required />
                        <div className="invalid-feedback">
                          Password is required.
                    </div>
                      </div>
                      <div className="col-md-6 mb-3">
                        <label htmlFor="passwordConfirmation">Password Confirmation</label>
                        <input ref={node => { passwordConfirmation = node }} type="password" className="form-control" id="passwordConfirmation" placeholder="" defaultValue="" required />
                        <div className="invalid-feedback">
                          Password is required.
                    </div>
                      </div>
                    </div>
                    <hr className="mb-4" />
                    <button className="btn btn-primary btn-lg btn-block" type="submit">Create account</button>
                  </form>
                </div>
              </div>
            </div>
          )
        }}
      </Mutation>
    )
  }
}

export default Register;