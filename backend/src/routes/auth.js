const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken'); // Import jsonwebtoken
const prisma = require('../utils/prisma'); // Import prisma from the new utility file

// Define a secret key for JWT (should be in .env in a real app)
const JWT_SECRET = process.env.JWT_SECRET || 'your_jwt_secret_key'; 

// Register a new user
router.post('/register', async (req, res) => {
    const { email, password, name } = req.body;
    if (!email || !password) {
        return res.status(400).json({ message: 'Email and password are required' });
    }

    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = await prisma.user.create({
            data: {
                email,
                password: hashedPassword,
                name,
            },
        });
        res.status(201).json({ message: 'User registered successfully', userId: user.id, email: user.email });
    } catch (error) {
        if (error.code === 'P2002') { // Unique constraint violation (email already exists)
            return res.status(400).json({ message: 'User with that email already exists' });
        }
        console.error('Error during registration:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

// Login a user
router.post('/login', async (req, res) => {
    const { email, password } = req.body;
    if (!email || !password) {
        return res.status(400).json({ message: 'Email and password are required' });
    }

    try {
        const user = await prisma.user.findUnique({
            where: { email },
        });

        if (!user) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const isPasswordValid = await bcrypt.compare(password, user.password);

        if (!isPasswordValid) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        // Generate JWT token
        const token = jwt.sign({ userId: user.id, email: user.email }, JWT_SECRET, { expiresIn: '1h' });

        res.json({ message: 'Logged in successfully', userId: user.id, email: user.email, token });
    } catch (error) {
        console.error('Error during login:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

module.exports = router;