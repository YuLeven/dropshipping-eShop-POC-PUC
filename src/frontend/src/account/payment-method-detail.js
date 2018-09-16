import React from 'react';

const PaymentMethodDetail = ({ paymentMethod }) => {

  return (
    <div className="modal fade" id={`paymentMethodModal-${paymentMethod.id}`} tabIndex="-1" role="dialog" aria-labelledby="newPaymentMethodLabel" aria-hidden="true">
      <div className="modal-dialog" role="document">
        <div className="modal-content">
          <div className="modal-header">
            <button type="button" className="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div className="modal-body">
            <div className="row">
              <div className="col-md-12 mb-3">
                <label htmlFor="street">Holder</label>
                <input type="text" className="form-control" id="cardHolderName" placeholder="" value={paymentMethod.cardHolderName} readOnly />
              </div>
            </div>
            <div className="row">
              <div className="col-md-12 mb-3">
                <label htmlFor="street">Card number</label>
                <input type="text" className="form-control" id="cardNumber" placeholder="" value={paymentMethod.cardNumber} readOnly />
              </div>
            </div>
            <div className="row">
              <div className="col-md-6 mb-3">
                <label htmlFor="residenceNumber">Card Brand</label>
                <input type="text" className="form-control" id="cardBrand" placeholder="" value={paymentMethod.cardBrand} readOnly />
              </div>
              <div className="col-md-6 mb-3">
                <label htmlFor="complement">Expiration</label>
                <input type="text" className="form-control" id="cardExpiration" placeholder="" value={paymentMethod.cardExpiration} readOnly />
              </div>
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
};

export default PaymentMethodDetail;