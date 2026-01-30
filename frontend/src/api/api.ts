// frontend/src/api/api.ts

const API_BASE_URL = process.env.REACT_APP_API_BASE_URL;

interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
}

interface LoginResponse {
  message: string;
  userId: number;
  email: string;
  token: string;
}

// Helper functions for token management
export const setAuthToken = (token: string) => {
  localStorage.setItem('authToken', token);
};

export const getAuthToken = (): string | null => {
  return localStorage.getItem('authToken');
};

export const removeAuthToken = () => {
  localStorage.removeItem('authToken');
};

// Function to handle API requests
async function callApi<T>(endpoint: string, options?: RequestInit): Promise<T> {
  const headers: HeadersInit = {
    'Content-Type': 'application/json',
  };

  const token = getAuthToken();
  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }

  const response = await fetch(`${API_BASE_URL}${endpoint}`, {
    headers: {
      ...headers,
      ...options?.headers, // Merge with any custom headers passed in options
    },
    ...options,
  });

  if (!response.ok) {
    const errorData = await response.json();
    throw new Error(errorData.message || 'Something went wrong');
  }

  return response.json();
}

// Fetching products from the backend
export const getProducts = async (): Promise<Product[]> => {
  // Assuming a /products endpoint in your backend
  return callApi<Product[]>('/products');
};

// Fetching a single product by ID from the backend
export const getProductById = async (id: string): Promise<Product | undefined> => {
  // Assuming a /products/:id endpoint in your backend
  return callApi<Product>(`/products/${id}`);
};

// User login via backend API
export const login = async (credentials: any): Promise<LoginResponse> => {
  console.log('Attempting login with:', credentials);
  const response = await callApi<LoginResponse>('/auth/login', {
    method: 'POST',
    body: JSON.stringify(credentials),
  });
  if (response.token) {
    setAuthToken(response.token);
  }
  return response;
};

// User registration via backend API
export const register = async (userData: any): Promise<any> => {
  console.log('Attempting registration with:', userData);
  return callApi('/auth/register', {
    method: 'POST',
    body: JSON.stringify(userData),
  });
};

// Add to cart via backend API
export const addToCart = async (productId: string, quantity: number): Promise<any> => {
  console.log(`Adding product ${productId} with quantity ${quantity} to cart.`);
  return callApi('/cart/add', {
    method: 'POST',
    body: JSON.stringify({ productId: parseInt(productId), quantity }),
  });
};

// Get cart via backend API
export const getCart = async (): Promise<any> => {
  console.log('Fetching cart...');
  return callApi('/cart');
};

// Checkout via backend API
export const checkout = async (): Promise<any> => {
  console.log('Proceeding to checkout...');
  return callApi('/cart/checkout', {
    method: 'POST',
  });
};

// Remove item from cart via backend API
export const removeCartItem = async (cartItemId: number): Promise<any> => {
  console.log(`Removing item ${cartItemId} from cart...`);
  return callApi(`/cart/items/${cartItemId}`, {
    method: 'DELETE',
  });
};