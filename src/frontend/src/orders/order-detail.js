import React from 'react';
import { formatMoney } from '../utils/money';

const OrderDetail = ({ order }) => (
  <div className="modal" id={`order-${order.id}-detail`} tabIndex="-1" role="dialog">
    <div className="modal-dialog" role="document">
      <div className="modal-content">
        <div className="modal-body">
          <h4>Products</h4>
          <ul className="list-group mb-3">
            {
              order.basket.basketItens.map(item => (
                <li key={item.id} className="list-group-item d-flex justify-content-between lh-condensed">
                  <div>
                    <h6 className="my-0">{item.productName}</h6>
                  </div>
                  <span className="text-muted">{formatMoney(item.price)}</span>
                </li>
              ))
            }
            <li className="list-group-item d-flex justify-content-between lh-condensed">
              <div>
                <h5 className="my-0">Total</h5>
              </div>
              <span className="text-muted">{formatMoney(order.invoiceTotal)}</span>
            </li>
          </ul>
        </div>
        <div className="modal-footer">
          <button type="button" className="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
);

export default OrderDetail;