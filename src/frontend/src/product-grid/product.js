import React from "react";
import { formatMoney } from '../utils/money';

const Product = ({ addProduct, product, refetchQuery }) => (
  <div className="card">
    <img className="card-img-top" src={product.pictureUrl} alt={product.name} />
    <div className="card-body">
      <div className="row justify-content-center">
        <div>
          <form
            onSubmit={e => {
              e.preventDefault();
              addProduct({
                variables: { productId: product.id },
                refetchQueries: [
                  { query: refetchQuery }
                ]
              })
            }}
          >
            <button type="submit" className="btn btn-success text-center">Add to cart</button>
          </form>
        </div>
      </div>
      <hr />
      <h6 className="d-flex justify-content-center">{product.name}</h6>
      <h3 className="d-flex justify-content-center">{formatMoney(product.price)}</h3>
    </div>
  </div>
)

export default Product;