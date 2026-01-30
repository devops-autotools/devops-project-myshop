const { PrismaClient } = require('@prisma/client');
const { PrismaPg } = require('@prisma/adapter-pg');
const { Pool } = require('pg');

const connectionString = process.env.DATABASE_URL;
if (!connectionString) {
  throw new Error('DATABASE_URL environment variable is not set.');
}
const pool = new Pool({ connectionString });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log('Start seeding...');

  // Create some sample products
  const product1 = await prisma.product.upsert({
    where: { id: 1 },
    update: {},
    create: {
      name: 'Laptop Pro',
      description: 'Powerful laptop for professionals.',
      price: 1299.99,
    },
  });

  const product2 = await prisma.product.upsert({
    where: { id: 2 },
    update: {},
    create: {
      name: 'Wireless Mouse',
      description: 'Ergonomic wireless mouse.',
      price: 25.00,
    },
  });

  const product3 = await prisma.product.upsert({
    where: { id: 3 },
    update: {},
    create: {
      name: 'Mechanical Keyboard',
      description: 'RGB mechanical keyboard with tactile switches.',
      price: 99.50,
    },
  });

  console.log(`Created products: ${product1.name}, ${product2.name}, ${product3.name}`);

  console.log('Seeding finished.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });