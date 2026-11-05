import { Request, Response } from 'express';
import { z } from 'zod';
import { prisma } from '../config/index.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

const clubSchema = z.object({
  name: z.string().min(3),
  description: z.string().min(10),
  category: z.string().min(2),
  venue: z.string().optional(),
  meetingTime: z.string().optional(),
  isApproved: z.boolean().default(true),
});

export async function getAllClubs(req: Request, res: Response) {
  try {
    const clubs = await prisma.studentClub.findMany({
      orderBy: { createdAt: 'desc' },
      include: {
        _count: {
          select: { members: true },
        },
      },
    });

    const parsed = clubs.map((c) => ({
      ...c,
      memberCount: c._count.members,
    }));

    return res.json({ clubs: parsed });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function createClub(req: AuthRequest, res: Response) {
  try {
    const data = clubSchema.parse(req.body);
    const club = await prisma.studentClub.create({ data });

    await prisma.auditLog.create({
      data: {
        action: 'CLUB_CREATED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Approved student club: ${club.name} (${club.category})`,
      },
    });

    return res.status(201).json({ club });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: err.errors });
    }
    return res.status(500).json({ error: err.message });
  }
}

export async function updateClub(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const data = clubSchema.partial().parse(req.body);
    const club = await prisma.studentClub.update({
      where: { id },
      data,
    });

    await prisma.auditLog.create({
      data: {
        action: 'CLUB_UPDATED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Updated student club: ${club.name}`,
      },
    });

    return res.json({ club });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: err.errors });
    }
    return res.status(500).json({ error: err.message });
  }
}

export async function deleteClub(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const club = await prisma.studentClub.delete({ where: { id } });

    await prisma.auditLog.create({
      data: {
        action: 'CLUB_DELETED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Deleted student club: ${club.name}`,
      },
    });

    return res.json({ success: true, message: 'Club deleted successfully.' });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function getClubRoster(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const club = await prisma.studentClub.findUnique({
      where: { id },
      include: {
        members: {
          include: {
            user: {
              select: {
                id: true,
                displayName: true,
                email: true,
                createdAt: true,
              },
            },
          },
        },
      },
    });

    if (!club) {
      return res.status(404).json({ error: 'Club not found' });
    }

    const roster = club.members.map((m) => ({
      membershipId: m.id,
      joinedAt: m.joinedAt,
      user: m.user,
    }));

    return res.json({ clubName: club.name, roster });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function joinClub(req: AuthRequest, res: Response) {
  try {
    if (!req.user) {
      return res.status(401).json({ error: 'Authentication required' });
    }
    const { id: clubId } = req.params;
    const userId = req.user.id;

    const existing = await prisma.clubMember.findUnique({
      where: {
        userId_clubId: { userId, clubId },
      },
    });

    if (existing) {
      return res.status(400).json({ error: 'Already a member of this club.' });
    }

    const membership = await prisma.clubMember.create({
      data: { userId, clubId },
    });

    return res.status(201).json({ success: true, membership });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}
