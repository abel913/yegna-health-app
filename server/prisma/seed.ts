import 'dotenv/config';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import bcrypt from 'bcryptjs';

const databaseUrl = process.env.DIRECT_URL || process.env.DATABASE_URL;
if (!databaseUrl) throw new Error('Set DIRECT_URL or DATABASE_URL before creating an admin account.');

const prisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString: databaseUrl }),
});

async function main() {
  const email = process.env.ADMIN_INITIAL_EMAIL?.trim().toLowerCase();
  const password = process.env.ADMIN_INITIAL_PASSWORD;
  const displayName = process.env.ADMIN_INITIAL_DISPLAY_NAME?.trim();

  if (!email || !password || !displayName) {
    throw new Error(
      'Set ADMIN_INITIAL_EMAIL, ADMIN_INITIAL_PASSWORD, and ADMIN_INITIAL_DISPLAY_NAME to bootstrap an admin. No default account is created.',
    );
  }
  if (password.length < 16) {
    throw new Error('ADMIN_INITIAL_PASSWORD must be at least 16 characters long.');
  }

  const existing = await prisma.user.findUnique({ where: { email } });
  if (existing) {
    throw new Error('The requested admin email already exists. Use the approved account recovery process.');
  }

  const passwordHash = await bcrypt.hash(password, 12);
  const admin = await prisma.user.create({
    data: {
      email,
      displayName,
      passwordHash,
      role: 'SUPER_ADMIN',
      isEmailVerified: true,
    },
    select: { id: true, email: true, role: true },
  });

  console.log(`Created initial administrator ${admin.email} (${admin.role}).`);
  console.log('No sample clinics, mentors, learning content, or clubs were inserted.');
}

main()
  .catch((error: unknown) => {
    console.error(error instanceof Error ? error.message : 'Admin bootstrap failed.');
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
