import { Response } from 'express';
import { prisma } from '../config/index.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

export async function getAllUsers(req: AuthRequest, res: Response) {
  try {
    const users = await prisma.user.findMany({
      orderBy: { createdAt: 'desc' },
      select: {
        id: true,
        email: true,
        displayName: true,
        role: true,
        isSuspended: true,
        createdAt: true,
        _count: {
          select: { memberships: true },
        },
      },
    });

    const parsed = users.map((u) => ({
      ...u,
      joinedClubCount: u._count.memberships,
    }));

    return res.json({ users: parsed });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function updateUserRole(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const { role } = req.body;

    const validRoles = ['STUDENT', 'MENTOR', 'CONTENT_AUTHOR', 'ADMIN', 'SUPER_ADMIN'];
    if (!validRoles.includes(role)) {
      return res.status(400).json({ error: 'Invalid role specified.' });
    }

    const updated = await prisma.user.update({
      where: { id },
      data: { role },
      select: { id: true, email: true, displayName: true, role: true },
    });

    await prisma.auditLog.create({
      data: {
        action: 'USER_ROLE_CHANGED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Changed role of ${updated.email} to ${role}`,
      },
    });

    return res.json({ user: updated });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function toggleUserSuspension(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const user = await prisma.user.findUnique({ where: { id } });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const newSuspensionState = !user.isSuspended;
    const updated = await prisma.user.update({
      where: { id },
      data: { isSuspended: newSuspensionState },
      select: { id: true, email: true, displayName: true, isSuspended: true },
    });

    await prisma.auditLog.create({
      data: {
        action: newSuspensionState ? 'USER_SUSPENDED' : 'USER_REINSTATED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `${newSuspensionState ? 'Suspended' : 'Reinstated'} user: ${updated.email}`,
      },
    });

    return res.json({ user: updated });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}
