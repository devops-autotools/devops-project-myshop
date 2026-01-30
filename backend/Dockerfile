# Use an official Node.js runtime as a parent image
FROM node:20

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install any needed packages
RUN npm install

# Install postgresql-client for pg_isready
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

# Copy the Prisma schema and run Prisma generate
COPY prisma ./prisma
RUN npx prisma generate

# Copy the rest of the application's code
COPY . .

# Make init-db.sh and start.sh executable after copying all files
RUN chmod +x init-db.sh
RUN chmod +x start.sh

# Make port 3001 available to the world outside this container
EXPOSE 3001

# Run the app when the container launches
CMD ["/bin/sh", "-c", "./init-db.sh && ./start.sh"]