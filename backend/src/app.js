const express = require('express');
const cors = require('cors'); // Import cors
const prisma = require('./utils/prisma'); // Import prisma from the new utility file

const app = express();

app.use(express.json());
app.use(cors()); // Use cors middleware

// Routes
const authRoutes = require('./routes/auth');
const cartRoutes = require('./routes/cart');
const productRoutes = require('./routes/products'); // Import product routes

app.use('/api/auth', authRoutes);
app.use('/api/cart', cartRoutes);
app.use('/api/products', productRoutes); // Use product routes

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.status(200).send('OK');
});

const PORT = process.env.PORT || 3000;

const server = app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

// Disconnect PrismaClient when the application closes
process.on('beforeExit', async () => {
  await prisma.$disconnect();
});

module.exports = { app, server }; // Export only app, prisma is now imported directly where needed