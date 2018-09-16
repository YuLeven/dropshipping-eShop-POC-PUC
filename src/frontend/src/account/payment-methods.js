import React from 'react';
import AddPaymentMethod from './add-payment-method';
import PaymentMethodDetail from './payment-method-detail';
import { formatCCValue } from '../utils/money';

const $ = window.$;
const PaymentMethods = ({ accountQuery, paymentMethods, addPaymentMethod, removePaymentMethod }) => (
  <div className="col-md-6">
    <div className="card">
      <div className="card-header">Payment methods</div>
      <div className="card-body">
        <ul className="list-group list-group-flush">
          {paymentMethods.map(paymentMethod => (
            <div key={paymentMethod.id}>
              <li
                className="list-group-item"
              >
                <span
                  onClick={() => $('#paymentMethodModal-' + paymentMethod.id).modal('show')}
                  style={{ cursor: 'pointer' }}
                >
                  {formatCCValue(paymentMethod.cardNumber)} - ({paymentMethod.cardBrand})
                </span>
                <span className="float-right">
                  <i
                    className="material-icons"
                    style={{ cursor: 'pointer' }}
                    onClick={() => {
                      removePaymentMethod({
                        variables: { id: paymentMethod.id },
                        refetchQueries: [{ query: accountQuery }]
                      });
                    }}
                  >
                    close
                  </i>
                </span>
              </li>
              <PaymentMethodDetail paymentMethod={paymentMethod} />
            </div>
          ))}
        </ul>
        <AddPaymentMethod accountQuery={accountQuery} addPaymentMethod={addPaymentMethod} />
        <button type="button" className="btn btn-primary mt-2" data-toggle="modal" data-target="#newPaymentMethod">
          Add payment method
        </button>
      </div>
    </div>
  </div>
);

export default PaymentMethods;