import { handleAsNodeRequest } from 'cloudflare:node';
import { env } from 'cloudflare:workers';
import { createServer } from 'node:http';
import { createApp } from './app.js';
import { createRequestPrisma, runWithRequestRuntime } from './config/index.js';

const app = createApp((request, response, next) => {
  const hyperdrive = Reflect.get(env, 'HYPERDRIVE') as { connectionString?: string } | undefined;
  if (!hyperdrive?.connectionString) {
    response.status(503).json({ error: 'Database connection is not configured.' });
    return;
  }

  const requestPrisma = createRequestPrisma(hyperdrive.connectionString);
  let disconnected = false;
  const disconnect = () => {
    if (disconnected) return;
    disconnected = true;
    void requestPrisma.$disconnect().catch(() => {
      console.error(JSON.stringify({ message: 'Request database connection cleanup failed.' }));
    });
  };

  response.once('finish', disconnect);
  runWithRequestRuntime(process.env, requestPrisma, next);
}, false);

const server = createServer((request, response) => new Promise<void>((resolve) => {
  response.once('finish', resolve);
  app(request, response);
}));
server.listen(8787);

export default {
  fetch(request: Request) {
    return handleAsNodeRequest(8787, request);
  },
};
