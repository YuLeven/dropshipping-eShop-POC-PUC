import React from 'react';

const AddressDetail = ({ address }) => (
  <div className="modal fade" id={`addressModal-${address.id}`} tabIndex="-1" role="dialog" aria-labelledby="newAddressModalLabel" aria-hidden="true">
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
              <label htmlFor="street">Street</label>
              <input type="text" className="form-control" id="street" placeholder="" value={address.street} readOnly />
            </div>
          </div>
          <div className="row">
            <div className="col-md-6 mb-3">
              <label htmlFor="residenceNumber">Residence number</label>
              <input type="number" className="form-control" id="residenceNumber" placeholder="" value={address.residenceNumber} readOnly />
            </div>
            <div className="col-md-6 mb-3">
              <label htmlFor="complement">Complement</label>
              <input type="text" className="form-control" id="complement" placeholder="" value={address.complement} readOnly />
            </div>
          </div>
          <div className="row">
            <div className="col-md-6 mb-3">
              <label htmlFor="district">District</label>
              <input type="text" className="form-control" id="district" placeholder="" value={address.district} readOnly />
            </div>
            <div className="col-md-6 mb-3">
              <label htmlFor="city">City</label>
              <input type="text" className="form-control" id="city" placeholder="" value={address.city} readOnly />
            </div>
          </div>
          <div className="row">
            <div className="col-md-6 mb-3">
              <label htmlFor="state">State</label>
              <input type="text" className="form-control" id="state" placeholder="" value={address.state} readOnly />
            </div>
            <div className="col-md-6 mb-3">
              <label htmlFor="postalCode">Postal Code</label>
              <input type="text" className="form-control" id="postalCode" placeholder="" value={address.postalCode} readOnly />
            </div>
          </div>
          <div className="modal-footer">
            <button type="button" className="btn btn-secondary" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
  </div>
);

export default AddressDetail;