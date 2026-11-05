import dotenv from 'dotenv';
import { PrismaClient } from '@prisma/client';

dotenv.config();

export const config = {
  port: parseInt(process.env.PORT || '5000', 10),
  jwtSecret: process.env.JWT_SECRET || 'yegna_health_jwt_secret_key_2026_super_secure',
  databaseUrl: process.env.DATABASE_URL || 'file:./dev.db',
  adminDefaultEmail: process.env.ADMIN_DEFAULT_EMAIL || 'admin@yegnahealth.org',
  adminDefaultPassword: process.env.ADMIN_DEFAULT_PASSWORD || 'admin1234',
};

export const prisma = new PrismaClient();
