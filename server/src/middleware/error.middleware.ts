import { Request, Response, NextFunction } from 'express';
import { config } from '../config/index.js';

export function errorHandler(err: any, req: Request, res: Response, next: NextFunction) {
  console.error('Unhandled error:', err);
  const status = err.status || 500;
  const message = err.message || 'Internal server error';
  res.status(status).json({
    error: message,
    ...(config.nodeEnv === 'development' ? { stack: err.stack } : {}),
  });
}
