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
      if (!origin || origin === config.adminWebOrigin) {
        callback(null, true);
        return;
      }
      callback(new Error('Origin is not allowed by CORS.'));
    },
    credentials: false,
  }));
  if (enableHttpLogging) app.use(morgan('dev'));
  app.use(express.json({ limit: '1mb' }));
  app.use(express.urlencoded({ extended: true, limit: '1mb' }));

  app.use('/api', router);
  app.use(errorHandler);

  return app;
}

export const app = createApp();
