import React, { useEffect, useState } from 'react';
import { getCart, checkout, removeCartItem } from '../api/api'; // Import removeCartItem
import './CartPage.css'; // Import custom CSS

interface CartItem {
  id: number;
  productId: number;
  quantity: number;
  product: {
    id: number;
    name: string;
    price: number;
  };
}

interface Cart {
  id: number;
  userId: number;
  items: CartItem[];
}

const CartPage: React.FC = () => {
  const [cart, setCart] = useState<Cart | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  const fetchCart = async () => {
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

  const handleRemoveItem = async (cartItemId: number) => {
    try {
      await removeCartItem(cartItemId);
      alert('Item removed from cart!');
      fetchCart(); // Refresh cart to update the display
    } catch (err: any) {
      alert(`Failed to remove item: ${err.message}`);
      console.error('Remove item error:', err);
    }
  };

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

  const total = cart?.items.reduce((sum, item) => sum + item.quantity * item.product.price, 0) || 0;

  return (
    <div className="cart-page">
      <h1>Shopping Cart</h1>
      <p className="intro-text">Review your selected items before checkout.</p>
      
      <div className="cart-items">
        {cart && cart.items.length > 0 ? (
          cart.items.map((item) => (
            <div key={item.id} className="cart-item">
              <div className="cart-item-details">
                <h3>{item.product.name}</h3>
                <p>Quantity: {item.quantity}</p>
                <button 
                  className="remove-item-button" 
                  onClick={() => handleRemoveItem(item.id)}
                >
                  Remove
                </button>
              </div>
              <p className="cart-item-price">${(item.quantity * item.product.price).toFixed(2)}</p>
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
