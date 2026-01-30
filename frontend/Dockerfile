# Use an official Node.js runtime as a parent image
FROM node:18-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies, ensuring devDependencies are included for the build
RUN NODE_ENV=development npm install

# Copy the rest of the application code
COPY . .

# Set the API base URL for the React app
# This will be replaced during the build process
ARG REACT_APP_API_BASE_URL
ENV REACT_APP_API_BASE_URL=$REACT_APP_API_BASE_URL

# Build the React app for production
# Ensure NODE_ENV is set to production for the actual build process
RUN NODE_ENV=production npm run build

# Use a lightweight web server to serve the built files
FROM node:18-alpine
WORKDIR /app

# Install 'serve' globally
RUN npm install -g serve

# Copy the build output from the build stage
COPY --from=build /app/build ./build

# Expose the port the app runs on
EXPOSE 3000

# Command to run the React app
CMD ["serve", "-s", "build", "-l", "3000"]
