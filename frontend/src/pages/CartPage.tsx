import React, { useEffect, useState } from 'react';
import { getCart, checkout, removeCartItem, getAuthToken } from '../api/api'; // Import getAuthToken
import './CartPage.css'; // Import custom CSS

interface CartItem {
  productId: number;
  name: string;
  price: number;
  quantity: number;
}

interface Cart {
  userId: number; // Only userId is returned for consistency, actual cart is items array
  items: CartItem[];
}

const CartPage: React.FC = () => {
  const [cart, setCart] = useState<Cart | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [isLoggedIn, setIsLoggedIn] = useState<boolean>(false);

  const fetchCart = async () => {
    const token = getAuthToken();
    if (!token) {
      setError('You need to be logged in to view your cart.');
      setLoading(false);
      setIsLoggedIn(false);
      return;
    }
    setIsLoggedIn(true);
    try {
      const response = await getCart();
      setCart(response);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch cart');
      console.error('Error fetching cart:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchCart();
  }, []);

  const handleCheckout = async () => {
    if (!cart || cart.items.length === 0) {
      alert('Your cart is empty. Please add items before checking out.');
      return;
    }

    try {
      await checkout();
      alert('Checkout successful!');
      fetchCart(); // Refresh cart to show it's empty
    } catch (err: any) {
      alert(`Checkout failed: ${err.message}`);
      console.error('Checkout error:', err);
    }
  };

  const handleRemoveItem = async (productId: number) => { // Changed from cartItemId to productId
    try {
      await removeCartItem(productId); // Pass productId
      alert('Item removed from cart!');
      fetchCart(); // Refresh cart to update the display
    } catch (err: any) {
      alert(`Failed to remove item: ${err.message}`);
      console.error('Remove item error:', err);
    }
  };

  if (!isLoggedIn) {
    return (
      <div className="cart-page">
        <p>You need to be logged in to view your cart.</p>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="cart-page">
        <p>Loading cart...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="cart-page">
        <p>Error: {error}</p>
      </div>
    );
  }

  const total = cart?.items.reduce((sum, item) => sum + item.quantity * item.price, 0) || 0; // Use item.price directly

  return (
    <div className="cart-page">
      <h1>Shopping Cart</h1>
      <p className="intro-text">Review your selected items before checkout.</p>
      
      <div className="cart-items">
        {cart && cart.items.length > 0 ? (
          cart.items.map((item) => (
            <div key={item.productId} className="cart-item"> {/* Use productId as key */}
              <div className="cart-item-details">
                <h3>{item.name}</h3> {/* Use item.name directly */}
                <p>Quantity: {item.quantity}</p>
                <button 
                  className="remove-item-button" 
                  onClick={() => handleRemoveItem(item.productId)} // Pass item.productId
                >
                  Remove
                </button>
              </div>
              <p className="cart-item-price">${(item.quantity * item.price).toFixed(2)}</p> {/* Use item.price directly */}
            </div>
          ))
        ) : (
          <p>Your cart is empty.</p>
        )}
      </div>

      <div className="cart-summary">
        <h2>Total:</h2>
        <p className="total-price">${total.toFixed(2)}</p>
      </div>

      <button className="checkout-button" onClick={handleCheckout}>
        Checkout
      </button>
    </div>
  );
};

export default CartPage;
