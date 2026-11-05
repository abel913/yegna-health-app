import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { config, prisma } from '../config/index.js';

export interface AuthRequest extends Request {
  user?: {
    id: string;
    email: string;
    role: string;
    displayName: string;
  };
}

export function authenticateToken(req: AuthRequest, res: Response, next: NextFunction) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null;

  if (!token) {
    return res.status(401).json({ error: 'Access token required.' });
  }

  try {
    const payload = jwt.verify(token, config.jwtSecret) as {
      id: string;
      email: string;
      role: string;
      displayName: string;
    };
    req.user = payload;
    next();
  } catch (err) {
    return res.status(403).json({ error: 'Invalid or expired token.' });
  }
}

export function requireAdmin(req: AuthRequest, res: Response, next: NextFunction) {
  if (!req.user) {
    return res.status(401).json({ error: 'Authentication required.' });
  }

  const role = req.user.role.toUpperCase();
  if (role !== 'ADMIN' && role !== 'SUPER_ADMIN') {
    return res.status(403).json({ error: 'Access denied: Administrator privileges required.' });
  }

  next();
}
