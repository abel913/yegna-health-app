import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { router } from './routes/index.js';
import { errorHandler } from './middleware/error.middleware.js';
import { config } from './config/index.js';

export function createApp(requestScope?: express.RequestHandler, enableHttpLogging = true) {
  const app = express();

  if (requestScope) app.use(requestScope);

  app.use(helmet());
  app.use(cors({
    origin(origin, callback) {
      if (!origin) {
        callback(null, true);
        return;
      }
      const isAllowedConfig = origin === config.adminWebOrigin || origin === config.clientAppUrl;
      const isLocalDev = origin.startsWith('http://localhost:') || origin.startsWith('http://127.0.0.1:');
      if (isAllowedConfig || isLocalDev) {
        callback(null, true);
        return;
      }
      callback(null, false);
    },
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Accept', 'X-Requested-With'],
    credentials: false,
  }));
  if (enableHttpLogging) app.use(morgan('dev'));
  app.use(express.json({ limit: '10mb' }));
  app.use(express.urlencoded({ extended: true, limit: '10mb' }));

  app.use('/api', router);
  app.use(errorHandler);

  return app;
}

export const app = createApp();
