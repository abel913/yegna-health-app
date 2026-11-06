import { Response } from 'express';
import bcrypt from 'bcryptjs';
import { z } from 'zod';
import { prisma } from '../config/index.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

const resetPasswordSchema = z.object({
  newPassword: z.string().min(6),
});

const createUserSchema = z.object({
  email: z.string().email(),
  displayName: z.string().min(2),
  password: z.string().min(6),
  role: z.enum(['STUDENT', 'MENTOR', 'CONTENT_AUTHOR', 'ADMIN', 'SUPER_ADMIN']).default('STUDENT'),
  isEmailVerified: z.boolean().default(true),
});

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
        isEmailVerified: true,
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

export async function verifyUserEmail(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const user = await prisma.user.findUnique({ where: { id } });
    if (!user) return res.status(404).json({ error: 'User not found.' });

    const updated = await prisma.user.update({
      where: { id },
      data: { isEmailVerified: true, verificationCode: null, verificationToken: null },
      select: { id: true, email: true, isEmailVerified: true },
    });

    await prisma.auditLog.create({
      data: {
        action: 'ADMIN_VERIFIED_USER_EMAIL',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Administrator manually verified email for ${user.email}`,
      },
    });

    return res.json({ success: true, user: updated });
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

export async function resetUserPassword(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const { newPassword } = resetPasswordSchema.parse(req.body);

    const user = await prisma.user.findUnique({ where: { id } });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(newPassword, salt);

    await prisma.user.update({
      where: { id },
      data: { passwordHash },
    });

    await prisma.auditLog.create({
      data: {
        action: 'USER_PASSWORD_RESET',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Reset password for user: ${user.email}`,
      },
    });

    return res.json({ success: true, message: `Password reset successfully for ${user.email}` });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'VALIDATION_FAILED', details: err.errors });
    }
    return res.status(500).json({ error: err.message });
  }
}

export async function deleteUser(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const user = await prisma.user.findUnique({ where: { id } });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Safety guard: Prevent deleting primary super admin
    if (user.email === 'admin@yegnahealth.org' || user.role === 'SUPER_ADMIN') {
      return res.status(403).json({ error: 'Cannot delete SuperAdmin accounts for security purposes.' });
    }

    await prisma.user.delete({ where: { id } });

    await prisma.auditLog.create({
      data: {
        action: 'USER_DELETED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Deleted user account: ${user.email} (${user.displayName})`,
      },
    });

    return res.json({ success: true, message: `User ${user.email} deleted successfully.` });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function createUser(req: AuthRequest, res: Response) {
  try {
    const { email, displayName, password, role, isEmailVerified } = createUserSchema.parse(req.body);

    const existing = await prisma.user.findUnique({
      where: { email: email.toLowerCase().trim() },
    });
    if (existing) {
      return res.status(409).json({ error: 'EMAIL_EXISTS', message: 'User with this email already exists.' });
    }

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    const user = await prisma.user.create({
      data: {
        email: email.toLowerCase().trim(),
        displayName: displayName.trim(),
        passwordHash,
        role,
        isEmailVerified,
      },
      select: {
        id: true,
        email: true,
        displayName: true,
        role: true,
        isSuspended: true,
        isEmailVerified: true,
        createdAt: true,
      },
    });

    await prisma.auditLog.create({
      data: {
        action: 'USER_CREATED_BY_ADMIN',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Created new user ${user.email} with role ${user.role}`,
      },
    });

    return res.status(201).json({
      success: true,
      user: {
        ...user,
        joinedClubCount: 0,
      },
    });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'VALIDATION_FAILED', details: err.errors });
    }
    return res.status(500).json({ error: err.message });
  }
}
