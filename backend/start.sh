#!/bin/sh
set -e

# Wait for the database to be ready
# The 'postgres' is the service name in docker-compose.yml
./wait-for-it.sh postgres

# Run database migrations
npx prisma migrate deploy --config prisma/prisma.config.ts

exec node src/app.js