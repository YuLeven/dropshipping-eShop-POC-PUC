import React from 'react';
import { formatMoney } from '../utils/money';

const itensCount = (itens) => itens.map(item => item.quantity).reduce(((a, b) => a + b), 0);
const basketTotal = (itens) => formatMoney(itens.map(item => parseFloat(item.price)).reduce(((a, b) => a + b), 0));

const ProductOverview = ({ basketItens }) => (
  <div className="col-md-4 order-md-2 mb-4">
    <h4 className="d-flex justify-content-between align-items-center mb-3">
      <span className="text-muted">Your cart</span>
      <span className="badge badge-secondary badge-pill">{itensCount(basketItens)}</span>
    </h4>
    <ul className="list-group mb-3">
      {
        basketItens.map(item => (
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
        <span className="text-muted">{basketTotal(basketItens)}</span>
      </li>
    </ul>
  </div>
);

export default ProductOverview;