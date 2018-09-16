import React from 'react';

const $ = window.$;
const AddPaymentMethod = ({ accountQuery, addPaymentMethod }) => {
  let holder;
  let number;
  let expiration;
  let brand;

  return (
    <div className="modal fade" id="newPaymentMethod" tabIndex="-1" role="dialog" aria-labelledby="newPaymentMethodLabel" aria-hidden="true">
      <div className="modal-dialog" role="document">
        <div className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title" id="newPaymentMethodLabel">Add payment method</h5>
            <button type="button" className="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div className="modal-body">
            <form
              className="needs-validation"
              onSubmit={e => {
                e.preventDefault();

                addPaymentMethod({
                  variables: {
                    cardBrand: brand.value,
                    cardExpiration: expiration.value,
                    cardHolderName: holder.value,
                    cardNumber: number.value
                  },
                  refetchQueries: [
                    { query: accountQuery }
                  ]
                });

                $('#newPaymentMethod').modal('hide');
              }}
            >
              <div className="row">
                <div className="col-md-12 mb-3">
                  <label htmlFor="street">Holder</label>
                  <input ref={node => { holder = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" required />
                  <div className="invalid-feedback">
                    Holder is required.
                  </div>
                </div>
              </div>
              <div className="row">
                <div className="col-md-12 mb-3">
                  <label htmlFor="street">Card number</label>
                  <input ref={node => { number = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" required />
                  <div className="invalid-feedback">
                    Card number is required.
                  </div>
                </div>
              </div>
              <div className="row">
                <div className="col-md-6 mb-3">
                  <label htmlFor="residenceNumber">Card Brand</label>
                  <input ref={node => { brand = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" required />
                  <div className="invalid-feedback">
                    Card brand is required.
                      </div>
                </div>
                <div className="col-md-6 mb-3">
                  <label htmlFor="complement">Expiration</label>
                  <input ref={node => { expiration = node }} type="text" pattern="\d{2}/\d{4}" className="form-control" id="firstName" placeholder="" defaultValue="" required />
                </div>
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="submit" className="btn btn-primary">Save changes</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  )
};

export default AddPaymentMethod;