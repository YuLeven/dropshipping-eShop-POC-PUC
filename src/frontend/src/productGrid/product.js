import React from "react";

const Product = ({ product }) => (
  <div className="card">
    <img className="card-img-top" src={product.pictureUrl} alt={product.name} />
    <div className="card-body">
      <div className="row justify-content-center">
        <button type="button" className="btn btn-success text-center">Add to cart</button>
      </div>
      <hr />
      <h6 className="d-flex justify-content-center">{product.name}</h6>
      <h3 className="d-flex justify-content-center">${product.price}</h3>
    </div>
  </div>
)

export default Product;