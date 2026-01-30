const request = require('supertest');
const app = require('../src/app');

afterAll((done) => {
    app.close(done);
});

describe('Auth Endpoints', () => {
    it('should register a new user', async () => {
        const res = await request(app)
            .post('/api/auth/register')
            .send({
                email: 'test@example.com',
                password: 'password',
                name: 'Test User'
            });
        expect(res.statusCode).toEqual(201);
        expect(res.body).toHaveProperty('message', 'User registered successfully');
    });

    it('should not register an existing user', async () => {
        await request(app)
            .post('/api/auth/register')
            .send({
                email: 'test@example.com',
                password: 'password',
                name: 'Test User'
            });
        const res = await request(app)
            .post('/api/auth/register')
            .send({
                email: 'test@example.com',
                password: 'password',
                name: 'Test User'
            });
        expect(res.statusCode).toEqual(400);
        expect(res.body).toHaveProperty('message', 'User already exists');
    });

    it('should login an existing user', async () => {
        await request(app)
            .post('/api/auth/register')
            .send({
                email: 'login@example.com',
                password: 'password'
            });
        const res = await request(app)
            .post('/api/auth/login')
            .send({
                email: 'login@example.com',
                password: 'password'
            });
        expect(res.statusCode).toEqual(200);
        expect(res.body).toHaveProperty('message', 'Logged in successfully');
    });

    it('should not login a user with invalid credentials', async () => {
        const res = await request(app)
            .post('/api/auth/login')
            .send({
                email: 'wrong@example.com',
                password: 'wrongpassword'
            });
        expect(res.statusCode).toEqual(401);
        expect(res.body).toHaveProperty('message', 'Invalid credentials');
    });
});