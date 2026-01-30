import React, { useEffect, useState } from 'react';
import { getProducts, addToCart } from '../api/api'; // Import addToCart
import { Link } from 'react-router-dom';
import './ProductList.css'; // Import custom CSS

interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
}

const ProductListPage: React.FC = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const data = await getProducts();
        setProducts(data);
      } catch (err) {
        setError('Failed to fetch products.');
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchProducts();
  }, []);

  const handleAddToCart = async (productId: string, productName: string) => {
    try {
      await addToCart(productId, 1); // Add 1 quantity of the product
      alert(`${productName} added to cart!`);
    } catch (err: any) {
      alert(`Failed to add ${productName} to cart: ${err.message}`);
      console.error('Add to cart error:', err);
    }
  };

  if (loading) {
    return (
      <div className="loading-message">
        <p>Loading products...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="error-message">
        <p>Error: {error}</p>
      </div>
    );
  }

  return (
    <div className="product-list-page">
      <h1>Product List</h1>
      <p>Browse our amazing selection of products.</p>
      <div className="product-grid">
        {products.map((product) => (
          <div key={product.id} className="product-card">
            <div className="product-card-content">
              <h3>
                <Link to={`/product/${product.id}`}>{product.name}</Link>
              </h3>
              <p className="description">{product.description}</p>
              <p className="price">${product.price.toFixed(2)}</p>
              <button onClick={() => handleAddToCart(product.id.toString(), product.name)}>
                Add to Cart
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ProductListPage;
