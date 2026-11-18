import { AsyncLocalStorage } from 'node:async_hooks';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';

type RuntimeEnvironment = Record<string, string | undefined>;
type RequestRuntime = { environment: RuntimeEnvironment; prisma: PrismaClient };

interface RuntimeConfig {
  adminWebOrigin: string;
  backendPublicUrl: string;
  clientAppUrl: string;
  jwtSecret: string;
  nodeEnv: string;
  port: number;
  smtpFrom?: string;
  smtpHost?: string;
  smtpPass?: string;
  smtpPort: number;
  smtpService?: string;
  smtpUser?: string;
}

const requestRuntime = new AsyncLocalStorage<RequestRuntime>();
let nodePrisma: PrismaClient | undefined;

function environmentValue(name: string): string | undefined {
  return requestRuntime.getStore()?.environment[name] ?? process.env[name];
}

function requiredEnvironmentVariable(name: string, minimumLength = 1): string {
  const value = environmentValue(name)?.trim();
  if (!value || value.length < minimumLength) {
    throw new Error(`${name} must be set to a value at least ${minimumLength} characters long.`);
  }
  return value;
}

function createPrismaClient(connectionString: string): PrismaClient {
  return new PrismaClient({
    adapter: new PrismaPg({ connectionString }),
  });
}

function getNodePrismaClient(): PrismaClient {
  if (!nodePrisma) {
    nodePrisma = createPrismaClient(requiredEnvironmentVariable('DATABASE_URL'));
  }
  return nodePrisma;
}

export const prisma = new Proxy({} as PrismaClient, {
  get(_target, property) {
    const activePrisma = requestRuntime.getStore()?.prisma ?? getNodePrismaClient();
    const value = Reflect.get(activePrisma, property, activePrisma) as unknown;
    return typeof value === 'function' ? value.bind(activePrisma) : value;
  },
});

export function runWithRequestRuntime<T>(
  environment: RuntimeEnvironment,
  requestPrisma: PrismaClient,
  callback: () => T,
): T {
  return requestRuntime.run({ environment, prisma: requestPrisma }, callback);
}

export function createRequestPrisma(connectionString: string): PrismaClient {
  return createPrismaClient(connectionString);
}

export function validateNodeConfiguration(): void {
  const jwtSecret = requiredEnvironmentVariable('JWT_SECRET', 32);
  if (jwtSecret === 'yegna_health_jwt_secret_key_2026_super_secure') {
    throw new Error('JWT_SECRET must not use the published development fallback.');
  }
  if (jwtSecret.startsWith('GENERATE_')) {
    throw new Error('Replace the JWT_SECRET placeholder with a unique random secret.');
  }

  requiredEnvironmentVariable('DATABASE_URL');
  requiredEnvironmentVariable('DIRECT_URL');

  const adminWebOrigin = requiredEnvironmentVariable('ADMIN_WEB_ORIGIN');
  if (environmentValue('NODE_ENV') === 'production' && !/^https:\/\//i.test(adminWebOrigin)) {
    throw new Error('ADMIN_WEB_ORIGIN must be an HTTPS origin in production.');
  }

  if (environmentValue('NODE_ENV') === 'production') {
    requiredEnvironmentVariable('SMTP_USER');
    requiredEnvironmentVariable('SMTP_PASS');
    if (!environmentValue('SMTP_HOST') && !environmentValue('SMTP_SERVICE')) {
      throw new Error('SMTP_HOST or SMTP_SERVICE must be configured in production.');
    }
    requiredEnvironmentVariable('CLIENT_APP_URL');
    requiredEnvironmentVariable('BACKEND_PUBLIC_URL');
  }
}

export async function disconnectNodePrisma(): Promise<void> {
  await nodePrisma?.$disconnect();
  nodePrisma = undefined;
}

export const config = new Proxy({} as RuntimeConfig, {
  get(_target, property) {
    switch (property) {
      case 'adminWebOrigin':
        return requiredEnvironmentVariable('ADMIN_WEB_ORIGIN');
      case 'backendPublicUrl':
        return environmentValue('BACKEND_PUBLIC_URL') || 'http://localhost:5000';
      case 'clientAppUrl':
        return environmentValue('CLIENT_APP_URL') || 'http://localhost:8080';
      case 'jwtSecret': {
        const secret = requiredEnvironmentVariable('JWT_SECRET', 32);
        if (secret === 'yegna_health_jwt_secret_key_2026_super_secure' || secret.startsWith('GENERATE_')) {
          throw new Error('JWT_SECRET must be a unique, randomly generated secret.');
        }
        return secret;
      }
      case 'nodeEnv':
        return environmentValue('NODE_ENV') || 'development';
      case 'port':
        return Number.parseInt(environmentValue('PORT') || '5000', 10);
      case 'smtpFrom':
        return environmentValue('SMTP_FROM');
      case 'smtpHost':
        return environmentValue('SMTP_HOST');
      case 'smtpPass':
        return environmentValue('SMTP_PASS');
      case 'smtpPort':
        return Number.parseInt(environmentValue('SMTP_PORT') || '587', 10);
      case 'smtpService':
        return environmentValue('SMTP_SERVICE');
      case 'smtpUser':
        return environmentValue('SMTP_USER');
      default:
        return undefined;
    }
  },
});
