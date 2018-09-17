import React, { Component } from 'react';
import gql from 'graphql-tag';
import { Query } from 'react-apollo';
import { formatMoney } from '../utils/money';
import OrderDetail from './order-detail';

const ORDERS_QUERY = gql`
{
  orders {
    id
    invoiceTotal
    supplierStatus
    insertedAt
    basket {
      status
      basketItens {
        id
        productName
        quantity
        price
      }
    }
  }
}
`;

const $ = window.$;
class Orders extends Component {

  orderStatus(status) {
    switch (status) {
      case 'enqueued':
        return {
          class: 'text-warning',
          text: 'Processing'
        };

      default:
        return {
          class: 'text-success',
          text: 'Preparing for shipping'
        }
    }
  }

  render() {
    return (
      <Query query={ORDERS_QUERY} fetchPolicy={'network-only'}>
        {({ loading, error, data: { orders } }) => {
          if (error) return 'Error...';
          if (loading) return 'Loading...';

          orders = orders.sort((a, b) => a.id + b.id);
          return (
            <div>
              <h1>Orders</h1>
              <table className="table table-hover">
                <thead className="thead-dark">
                  <tr>
                    <th scope="col">Order Protocol</th>
                    <th scope="col">Invoice Total</th>
                    <th scope="col">Purchase Date</th>
                    <th scope="col">Status</th>
                  </tr>
                </thead>
                <tbody>
                  {orders.map(order => (
                    <tr
                      key={order.id}
                      style={{ cursor: 'pointer' }}
                      onClick={() => $(`#order-${order.id}-detail`).modal('show')}
                    >
                      <th scope="row">{order.id}</th>
                      <td>{formatMoney(order.invoiceTotal)}</td>
                      <td>{new Date(order.insertedAt).toLocaleDateString("en-GB")}</td>
                      <td>
                        <span className={this.orderStatus(order.supplierStatus).class}>{this.orderStatus(order.supplierStatus).text}</span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
              {orders.map(order => <OrderDetail key={order.id} order={order} />)}
            </div>
          );
        }}
      </Query>
    );
  }
}

export default Orders;