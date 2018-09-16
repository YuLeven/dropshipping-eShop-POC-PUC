import React from 'react';

const $ = window.$;
const AddAddress = ({ accountQuery, addAddress }) => {
  let street;
  let residenceNumber;
  let complement;
  let district;
  let city;
  let state;
  let postalCode;

  return (
    <div className="modal fade" id="newAddressModal" tabIndex="-1" role="dialog" aria-labelledby="newAddressModalLabel" aria-hidden="true">
      <div className="modal-dialog" role="document">
        <div className="modal-content">
          <div className="modal-header">
            <h5 className="modal-title" id="newAddressModalLabel">Modal title</h5>
            <button type="button" className="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div className="modal-body">
            <form
              className="needs-validation"
              onSubmit={e => {
                e.preventDefault();

                addAddress({
                  variables: {
                    street: street.value,
                    residenceNumber: parseInt(residenceNumber.value),
                    complement: complement.value,
                    district: district.value,
                    city: city.value,
                    state: state.value,
                    postalCode: postalCode.value
                  },
                  refetchQueries: [
                    { query: accountQuery }
                  ]
                });

                $('#newAddressModal').modal('hide');
              }}
            >
              <div className="row">
                <div className="col-md-12 mb-3">
                  <label htmlFor="street">Street</label>
                  <input ref={node => { street = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" required />
                  <div className="invalid-feedback">
                    Street is required.
                      </div>
                </div>
              </div>
              <div className="row">
                <div className="col-md-6 mb-3">
                  <label htmlFor="residenceNumber">Residence number</label>
                  <input ref={node => { residenceNumber = node }} type="number" className="form-control" id="firstName" placeholder="" defaultValue="" required />
                  <div className="invalid-feedback">
                    Residence number is required.
                      </div>
                </div>
                <div className="col-md-6 mb-3">
                  <label htmlFor="complement">Complement</label>
                  <input ref={node => { complement = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" />
                </div>
              </div>
              <div className="row">
                <div className="col-md-6 mb-3">
                  <label htmlFor="district">District</label>
                  <input ref={node => { district = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" required />
                  <div className="invalid-feedback">
                    District number is required.
                      </div>
                </div>
                <div className="col-md-6 mb-3">
                  <label htmlFor="city">City</label>
                  <input ref={node => { city = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" />
                  <div className="invalid-feedback">
                    City number is required.
                      </div>
                </div>
              </div>
              <div className="row">
                <div className="col-md-6 mb-3">
                  <label htmlFor="state">State</label>
                  <input ref={node => { state = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" required />
                  <div className="invalid-feedback">
                    State is required.
                      </div>
                </div>
                <div className="col-md-6 mb-3">
                  <label htmlFor="postalCode">Postal Code</label>
                  <input ref={node => { postalCode = node }} type="text" className="form-control" id="firstName" placeholder="" defaultValue="" />
                  <div className="invalid-feedback">
                    Postal code number is required.
                      </div>
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

export default AddAddress;