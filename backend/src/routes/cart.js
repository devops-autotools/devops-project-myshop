const express = require('express');
const router = express.Router();
const cartController = require('../controllers/cartController');
const authenticateToken = require('../middlewares/authMiddleware'); // Import authentication middleware

// Apply authentication middleware to all cart routes
router.use(authenticateToken);

// Add item to cart
router.post('/add', cartController.addToCart);

// Get user's cart
router.get('/', cartController.getCart);

// Checkout route
router.post('/checkout', cartController.checkout);

// Remove item from cart
router.delete('/items/:cartItemId', cartController.removeCartItem);

module.exports = router;