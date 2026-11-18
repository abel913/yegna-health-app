import dotenv from 'dotenv';

async function startServer(): Promise<void> {
  dotenv.config();

  const [{ app }, { config, disconnectNodePrisma, validateNodeConfiguration }] = await Promise.all([
    import('./app.js'),
    import('./config/index.js'),
  ]);

  validateNodeConfiguration();

  const server = app.listen(config.port, () => {
    console.log('===============================================');
    console.log(`Yegna Health Custom Server Running on Port ${config.port}`);
    console.log(`Base URL: http://localhost:${config.port}/api`);
    console.log('Zero-Knowledge Student Privacy Mode Active');
    console.log('===============================================');
  });

  process.on('SIGTERM', async () => {
    console.log('SIGTERM signal received: closing HTTP server');
    server.close(async () => {
      await disconnectNodePrisma();
      console.log('HTTP server closed, Prisma disconnected.');
    });
  });
}

void startServer().catch((error: unknown) => {
  console.error('Yegna Health server could not start.');
  console.error(error instanceof Error ? error.message : 'Unknown startup error.');
  process.exitCode = 1;
});
