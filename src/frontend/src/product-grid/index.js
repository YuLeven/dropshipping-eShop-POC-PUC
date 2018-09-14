import React, { Component } from "react";
import { Query, Mutation } from 'react-apollo';
import { chunkArray } from '../utils/array';
import gql from 'graphql-tag';
import Product from './product';

const ADD_PRODUCT = gql`
mutation AddProduct($productId: Int!) {
  addProductToBasket(productId: $productId) {
    id
    basketItens {
      id
      productName
      quantity
      price
    }
  }
}`;

const PRODUCTS_QUERY = gql`
  query Products {
    products {
      id
      name
      description
      pictureUrl
      price
    }
  }
`;

class ProductGrid extends Component {

  render() {
    return (
      <Mutation mutation={ADD_PRODUCT}>
        {addProduct => (
          <Query query={PRODUCTS_QUERY}>
            {({ loading, error, data }) => {
              if (loading) return "Loading...";
              if (error) return "Error";

              const chunckedProducts = chunkArray(data.products, 3);
              return (
                <div className="container-fluid">
                  {chunckedProducts.map((row, index) => {
                    return (
                      <div key={index} className="card-deck mb-5">
                        {row.map(product => (<Product addProduct={addProduct} product={product} key={product.id} refetchQuery={PRODUCTS_QUERY} />))}
                      </div>
                    )
                  })}
                </div>
              )
            }}
          </Query>
        )}
      </Mutation>
    );
  }
}

export default ProductGrid;