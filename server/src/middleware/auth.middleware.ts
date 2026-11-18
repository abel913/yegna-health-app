import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { config, prisma } from '../config/index.js';

export interface AuthRequest extends Request {
  user?: {
    id: string;
    email: string;
    role: string;
    displayName: string;
    mustChangePassword?: boolean;
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
      mustChangePassword?: boolean;
    };
    req.user = payload;
    next();
  } catch (err) {
    return res.status(403).json({ error: 'Invalid or expired token.' });
  }
}

export async function refreshAuthorizationContext(req: AuthRequest, res: Response, next: NextFunction) {
  if (!req.user) return res.status(401).json({ error: 'Authentication required.' });
  try {
    const account = await prisma.user.findUnique({
      where: { id: req.user.id },
      select: { id: true, email: true, role: true, displayName: true, isSuspended: true, mustChangePassword: true },
    });
    if (!account) return res.status(401).json({ error: 'Account is no longer available.' });
    if (account.isSuspended) return res.status(403).json({ error: 'ACCOUNT_SUSPENDED' });
    req.user = {
      id: account.id,
      email: account.email,
      role: account.role,
      displayName: account.displayName,
      mustChangePassword: account.mustChangePassword || req.user.mustChangePassword === true,
    };
  } catch {
    return res.status(503).json({ error: 'Authentication service unavailable.' });
  }
  return next();
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

export function requireGovernmentViewer(req: AuthRequest, res: Response, next: NextFunction) {
  if (!req.user) return res.status(401).json({ error: 'Authentication required.' });
  if (req.user.role.toUpperCase() !== 'GOVERNMENT_VIEWER') {
    return res.status(403).json({ error: 'Access denied: Government reporting access required.' });
  }
  return next();
}

export function requirePasswordChangeComplete(req: AuthRequest, res: Response, next: NextFunction) {
  if (req.user?.mustChangePassword) return res.status(403).json({ error: 'PASSWORD_CHANGE_REQUIRED' });
  return next();
}

export function requireNotGovernmentViewer(req: AuthRequest, res: Response, next: NextFunction) {
  if (req.user?.role.toUpperCase() === 'GOVERNMENT_VIEWER') {
    return res.status(403).json({ error: 'Access denied: This account is limited to government reports.' });
  }
  return next();
}
