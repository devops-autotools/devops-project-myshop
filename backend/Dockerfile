# ---------- Build stage ----------
FROM node:20-alpine AS build

WORKDIR /app

# Install dependencies first (cache-friendly)
COPY package*.json ./
RUN npm ci

# Copy source
COPY . .

# Generate Prisma client
RUN npx prisma generate


# ---------- Runtime stage ----------
FROM node:20-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -S app && adduser -S app -G app

# Install tini and postgresql-client for pg_isready
RUN apk add --no-cache tini postgresql-client curl

# Copy only needed files
COPY --from=build /app/package*.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/src ./src
COPY --from=build /app/prisma ./prisma
COPY --from=build /app/wait-for-it.sh ./wait-for-it.sh
COPY --from=build /app/start.sh ./start.sh
COPY --from=build /app/init-db.sh ./init-db.sh

# Make scripts executable
RUN chmod +x start.sh
RUN chmod +x wait-for-it.sh
RUN chmod +x init-db.sh

USER app

EXPOSE 3000

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["./start.sh"]