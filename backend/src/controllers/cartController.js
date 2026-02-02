const prisma = require('../utils/prisma');
const redisClient = require('../utils/redis'); // Import the Redis client

// Helper function to get a user's cart from Redis
const getUserCart = async (userId) => {
  const cartString = await redisClient.get(`cart:${userId}`);
  return cartString ? JSON.parse(cartString) : { userId, items: [] };
};

// Helper function to save a user's cart to Redis
const saveUserCart = async (userId, cart) => {
  await redisClient.set(`cart:${userId}`, JSON.stringify(cart));
  // Optional: Set an expiration for the cart, e.g., 24 hours
  await redisClient.expire(`cart:${userId}`, 60 * 60 * 24);
};

// Function to add a product to the cart
const addToCart = async (req, res) => {
  const { productId, quantity } = req.body;
  const userId = req.userId;

  if (!userId) {
    return res.status(401).json({ message: 'Unauthorized: User ID not found.' });
  }

  if (!productId || !quantity || quantity <= 0) {
    return res.status(400).json({ message: 'Product ID and a positive quantity are required.' });
  }

  try {
    const product = await prisma.product.findUnique({
      where: { id: parseInt(productId) },
    });

    if (!product) {
      return res.status(404).json({ message: 'Product not found.' });
    }

    const userCart = await getUserCart(userId);

    const existingItemIndex = userCart.items.findIndex(item => item.productId === parseInt(productId));

    if (existingItemIndex > -1) {
      userCart.items[existingItemIndex].quantity += quantity;
    } else {
      userCart.items.push({
        productId: product.id,
        name: product.name,
        price: product.price,
        quantity: quantity,
      });
    }

    await saveUserCart(userId, userCart);

    res.status(200).json({ message: 'Item added to cart successfully.', cart: userCart });
  } catch (error) {
    console.error('Error adding item to cart:', error);
    res.status(500).json({ message: 'Internal server error.' });
  }
};

// Function to get the user's cart
const getCart = async (req, res) => {
  const userId = req.userId;

  if (!userId) {
    return res.status(401).json({ message: 'Unauthorized: User ID not found.' });
  }

  try {
    const userCart = await getUserCart(userId);
    res.status(200).json(userCart);
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
    const userCart = await getUserCart(userId);

    if (!userCart || userCart.items.length === 0) {
      return res.status(400).json({ message: 'Cannot checkout with an empty cart.' });
    }

    let total = 0;
    const orderItemsData = [];

    // Fetch product details from DB to ensure current prices and existence
    for (const item of userCart.items) {
      const product = await prisma.product.findUnique({
        where: { id: item.productId },
      });

      if (!product) {
        // Optionally handle cases where a product in cart is no longer available
        console.warn(`Product with ID ${item.productId} not found during checkout.`);
        continue; 
      }
      total += item.quantity * product.price;
      orderItemsData.push({
        productId: product.id,
        quantity: item.quantity,
        price: product.price, // Store current product price
      });
    }

    if (orderItemsData.length === 0) {
      return res.status(400).json({ message: 'No valid items to checkout.' });
    }

    // Create a new order in PostgreSQL
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

    // Clear the user's cart in Redis after successful checkout
    await redisClient.del(`cart:${userId}`);

    res.status(201).json({ message: 'Checkout successful!', orderId: order.id, total: order.total });
  } catch (error) {
    console.error('Error during checkout:', error);
    res.status(500).json({ message: 'Internal server error during checkout.' });
  }
};

// Function to remove a product from the cart
const removeCartItem = async (req, res) => {
  const { productId } = req.params; // Changed from cartItemId to productId
  const userId = req.userId;

  if (!userId) {
    return res.status(401).json({ message: 'Unauthorized: User ID not found.' });
  }

  try {
    const userCart = await getUserCart(userId);

    const initialItemCount = userCart.items.length;
    userCart.items = userCart.items.filter(item => item.productId !== parseInt(productId));

    if (userCart.items.length === initialItemCount) {
      return res.status(404).json({ message: 'Product not found in cart.' });
    }

    await saveUserCart(userId, userCart);

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
  removeCartItem,
};