import { app } from './app.js';
import { config, prisma } from './config/index.js';

const server = app.listen(config.port, () => {
  console.log(`===============================================`);
  console.log(`🚀 Yegna Health Custom Server Running on Port ${config.port}`);
  console.log(`📡 Base URL: http://localhost:${config.port}/api`);
  console.log(`🛡️  Zero-Knowledge Student Privacy Mode Active`);
  console.log(`===============================================`);
});

process.on('SIGTERM', async () => {
  console.log('SIGTERM signal received: closing HTTP server');
  server.close(async () => {
    await prisma.$disconnect();
    console.log('HTTP server closed, Prisma disconnected.');
  });
});
