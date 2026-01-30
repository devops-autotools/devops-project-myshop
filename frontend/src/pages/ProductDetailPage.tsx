import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { getProductById, addToCart } from '../api/api'; // Import addToCart
import './ProductDetail.css'; // Import custom CSS

interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
}

const ProductDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const [product, setProduct] = useState<Product | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchProduct = async () => {
      if (!id) {
        setError('Product ID is missing.');
        setLoading(false);
        return;
      }
      try {
        const data = await getProductById(id);
        if (data) {
          setProduct(data);
        } else {
          setError('Product not found.');
        }
      } catch (err) {
        setError('Failed to fetch product details.');
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchProduct();
  }, [id]);

  const handleAddToCart = async () => {
    if (product) {
      try {
        await addToCart(product.id, 1); // Add 1 quantity of the product
        alert(`${product.name} added to cart!`);
      } catch (err: any) {
        alert(`Failed to add ${product.name} to cart: ${err.message}`);
        console.error('Add to cart error:', err);
      }
    }
  };

  if (loading) {
    return (
      <div className="loading-message">
        <p>Loading product details...</p>
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

  if (!product) {
    return (
      <div className="no-product-found-message">
        <p>No product found.</p>
      </div>
    );
  }

  return (
    <div className="product-detail-page">
      <h1>{product.name}</h1>
      <p className="product-id">Product ID: <span>{product.id}</span></p>
      <p className="description">{product.description}</p>
      <p className="price">Price: ${product.price.toFixed(2)}</p>
      <button onClick={handleAddToCart}>
        Add to Cart
      </button>
    </div>
  );
};

export default ProductDetailPage;
