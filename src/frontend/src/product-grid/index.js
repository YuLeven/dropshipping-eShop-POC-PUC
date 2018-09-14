import React, { Component } from "react";
import { Query } from 'react-apollo';
import { chunkArray } from '../utils/array';
import gql from 'graphql-tag';
import Product from './product';

const productsQuery = gql`
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
      <div>
        <Query query={productsQuery}>
          {({ loading, error, data }) => {
            if (loading) return "Loading...";
            if (error) return "Error";

            const chunckedProducts = chunkArray(data.products, 3);
            return (
              <div className="container-fluid">
                {chunckedProducts.map((row, index) => {
                  return (
                    <div key={index} className="card-deck mb-5">
                      {row.map(product => <Product key={product.id} product={product} />)}
                    </div>
                  )
                })}
              </div>
            )
          }}
        </Query>
      </div>
    );
  }
}

export default ProductGrid;