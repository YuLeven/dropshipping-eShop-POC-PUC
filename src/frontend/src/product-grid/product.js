import React, { Component } from "react";
import { formatMoney } from '../utils/money';
import { isUserLogged } from '../utils/user';

class Product extends Component {

  handleAddToCart = () => {
    if (!isUserLogged()) {
      return window.location.href = "/login";
    }

    this.props.addProduct({
      variables: { productId: this.props.product.id },
      refetchQueries: [
        { query: this.props.refetchQuery }
      ]
    })
  }

  render() {

    let { product } = this.props;

    return (
      <div className="card">
        <img className="card-img-top" src={product.pictureUrl} alt={product.name} />
        <div className="card-body">
          <div className="row justify-content-center">
            <div>

              <button
                type="button"
                className="btn btn-success text-center"
                onClick={this.handleAddToCart}
              >
                Add to cart
              </button>
            </div>
          </div>
          <hr />
          <h6 className="d-flex justify-content-center">{product.name}</h6>
          <h3 className="d-flex justify-content-center">{formatMoney(product.price)}</h3>
        </div>
      </div>
    )
  }
}

export default Product;