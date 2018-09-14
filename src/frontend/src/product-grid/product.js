import React from "react";
import gql from "graphql-tag";
import { Mutation } from "react-apollo";

const ADD_PRODUCT = gql`
mutation AddProduct($productId: Int!) {
  addProductToBasket(productId: $productId) {
    basketItens {
      id
      pictureUrl
      price
      productId
      productName
      quantity
    }
  }
}`;

const Product = ({ product }) => (
  <div className="card">
    <img className="card-img-top" src={product.pictureUrl} alt={product.name} />
    <div className="card-body">
      <div className="row justify-content-center">
        <Mutation mutation={ADD_PRODUCT}>
          {(addProduct, { data }) => (
            <div>
              <form
                onSubmit={e => {
                  e.preventDefault();
                  addProduct({
                    variables: { productId: product.id }
                  })
                }}
              >
                <button type="submit" className="btn btn-success text-center">Add to cart</button>
              </form>
            </div>
          )}
        </Mutation>
      </div>
      <hr />
      <h6 className="d-flex justify-content-center">{product.name}</h6>
      <h3 className="d-flex justify-content-center">${product.price}</h3>
    </div>
  </div>
)

export default Product;