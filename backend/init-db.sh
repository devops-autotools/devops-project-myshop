#!/bin/sh

# Wait for PostgreSQL
until pg_isready -h db -p 5432; do
  echo 'Waiting for PostgreSQL...'
  sleep 1
done

echo 'PostgreSQL is ready.'

# Run Prisma DB Push
echo 'Running Prisma DB Push...'
npx prisma db push --schema prisma/schema.prisma --url "$DATABASE_URL"

# Run Prisma Seed
echo 'Running Prisma Seed...'
node prisma/seed.js