import { defineConfig } from '@prisma/client/define-config';

export default defineConfig({
  datasource: {
    db: {
      provider: 'postgresql',
      url: process.env.DATABASE_URL,
    },
  },
});
