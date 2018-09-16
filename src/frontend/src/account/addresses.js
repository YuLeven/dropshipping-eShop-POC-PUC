import React from 'react';
import AddAddress from './add-address';
import AddressDetail from './address-detail';

const $ = window.$;
const Addresses = ({ accountQuery, shippingAddresses, addAddress, removeAddress }) => (
  <div className="col-md-6">
    <div className="card">
      <div className="card-header">Shipping addresses</div>
      <div className="card-body">
        <ul className="list-group list-group-flush">
          {shippingAddresses.map(address => (
            <div key={address.id}>
              <li
                className="list-group-item"
              >
                <span
                  style={{ cursor: 'pointer' }}
                  onClick={() => $('#addressModal-' + address.id).modal('show')}
                >
                  {address.street}, {address.residenceNumber} - {address.city}
                </span>

                <span className="float-right">
                  <i
                    className="material-icons"
                    style={{ cursor: 'pointer' }}
                    onClick={() => {
                      removeAddress({
                        variables: { id: address.id },
                        refetchQueries: [{ query: accountQuery }]
                      })
                    }}
                  >
                    close
                  </i>
                </span>
              </li>
              <AddressDetail address={address} />
            </div>
          ))}
        </ul>
        <AddAddress accountQuery={accountQuery} addAddress={addAddress} />
        <button type="button" className="btn btn-primary mt-2" data-toggle="modal" data-target="#newAddressModal">
          Add Shipping Address
        </button>
      </div>
    </div>
  </div>
);

export default Addresses;