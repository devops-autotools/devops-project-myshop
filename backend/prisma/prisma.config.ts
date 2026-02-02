// prisma/prisma.config.ts
import "dotenv/config"; // Recommended for loading .env files
import { defineConfig, env } from "prisma/config";

export default defineConfig({
  datasource: {
    url: env("DATABASE_URL"),
  },
});