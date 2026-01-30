const prisma = require('../utils/prisma');

// Function to add a product to the cart
const addToCart = async (req, res) => {
  const { productId, quantity } = req.body;
  const userId = req.userId; // Assuming userId is attached to the request by authentication middleware

  if (!userId) {
    return res.status(401).json({ message: 'Unauthorized: User ID not found.' });
  }

  if (!productId || !quantity || quantity <= 0) {
    return res.status(400).json({ message: 'Product ID and a positive quantity are required.' });
  }

  try {
    // Check if the product exists
    const product = await prisma.product.findUnique({
      where: { id: parseInt(productId) },
    });

    if (!product) {
      return res.status(404).json({ message: 'Product not found.' });
    }

    // Find or create the user's cart
    let cart = await prisma.cart.findUnique({
      where: { userId: userId },
    });

    if (!cart) {
      cart = await prisma.cart.create({
        data: {
          userId: userId,
        },
      });
    }

    // Check if the item already exists in the cart
    const existingCartItem = await prisma.cartItem.findFirst({
      where: {
        cartId: cart.id,
        productId: parseInt(productId),
      },
    });

    if (existingCartItem) {
      // Update quantity if item exists
      await prisma.cartItem.update({
        where: { id: existingCartItem.id },
        data: { quantity: existingCartItem.quantity + quantity },
      });
    } else {
      // Add new item to cart
      await prisma.cartItem.create({
        data: {
          cartId: cart.id,
          productId: parseInt(productId),
          quantity: quantity,
        },
      });
    }

    // Fetch the updated cart with items
    const updatedCart = await prisma.cart.findUnique({
      where: { id: cart.id },
      include: { items: { include: { product: true } } },
    });

    res.status(200).json({ message: 'Item added to cart successfully.', cart: updatedCart });
  } catch (error) {
    console.error('Error adding item to cart:', error);
    res.status(500).json({ message: 'Internal server error.' });
  }
};

// Function to get the user's cart
const getCart = async (req, res) => {
  const userId = req.userId; // Assuming userId is attached to the request by authentication middleware

  if (!userId) {
    return res.status(401).json({ message: 'Unauthorized: User ID not found.' });
  }

  try {
    const cart = await prisma.cart.findUnique({
      where: { userId: userId },
      include: { items: { include: { product: true } } },
    });

    if (!cart) {
      return res.status(200).json({ message: 'Cart is empty.', cart: { userId, items: [] } });
    }

    res.status(200).json(cart);
  } catch (error) {
    console.error('Error fetching cart:', error);
    res.status(500).json({ message: 'Internal server error.' });
  }
};

// Function to handle checkout
const checkout = async (req, res) => {
  const userId = req.userId;

  if (!userId) {
    return res.status(401).json({ message: 'Unauthorized: User ID not found.' });
  }

  try {
    const userCart = await prisma.cart.findUnique({
      where: { userId: userId },
      include: { items: { include: { product: true } } },
    });

    if (!userCart || userCart.items.length === 0) {
      return res.status(400).json({ message: 'Cannot checkout with an empty cart.' });
    }

    let total = 0;
    const orderItemsData = userCart.items.map((item) => {
      total += item.quantity * item.product.price;
      return {
        productId: item.productId,
        quantity: item.quantity,
        price: item.product.price, // Store current product price
      };
    });

    // Create a new order
    const order = await prisma.order.create({
      data: {
        userId: userId,
        total: total,
        items: {
          createMany: {
            data: orderItemsData,
          },
        },
      },
      include: {
        items: true,
      },
    });

    // Clear the user's cart
    await prisma.cartItem.deleteMany({
      where: { cartId: userCart.id },
    });

    res.status(201).json({ message: 'Checkout successful!', orderId: order.id, total: order.total });
  } catch (error) {
    console.error('Error during checkout:', error);
    res.status(500).json({ message: 'Internal server error during checkout.' });
  }
};

// Function to remove a product from the cart
const removeCartItem = async (req, res) => {
  const { cartItemId } = req.params;
  const userId = req.userId;

  if (!userId) {
    return res.status(401).json({ message: 'Unauthorized: User ID not found.' });
  }

  try {
    // Find the cart item
    const itemToRemove = await prisma.cartItem.findUnique({
      where: { id: parseInt(cartItemId) },
      include: { cart: true }, // Include cart to check ownership
    });

    if (!itemToRemove) {
      return res.status(404).json({ message: 'Cart item not found.' });
    }

    // Check if the user owns this cart item
    if (itemToRemove.cart.userId !== userId) {
      return res.status(403).json({ message: 'Forbidden: You do not own this cart item.' });
    }

    await prisma.cartItem.delete({
      where: { id: parseInt(cartItemId) },
    });

    res.status(200).json({ message: 'Item removed from cart successfully.' });
  } catch (error) {
    console.error('Error removing item from cart:', error);
    res.status(500).json({ message: 'Internal server error.' });
  }
};

module.exports = {
  addToCart,
  getCart,
  checkout,
  removeCartItem, // Export the new function
};