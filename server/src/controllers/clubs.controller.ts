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
  mentorName: z.string().optional(),
  mentorContact: z.string().optional(),
  rules: z.union([z.string(), z.array(z.string())]).optional().transform((val) => {
    if (Array.isArray(val)) return JSON.stringify(val);
    return val;
  }),
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

function toPrismaClub(data: Record<string, any>): Record<string, any> {
  const allowed = [
    'name',
    'description',
    'category',
    'venue',
    'meetingTime',
    'isApproved',
  ] as const;

  const result: Record<string, any> = {};
  for (const key of allowed) {
    if (data[key] !== undefined) {
      result[key] = data[key];
    }
  }
  return result;
}

export async function createClub(req: AuthRequest, res: Response) {
  try {
    const data = clubSchema.parse(req.body);
    const club = await prisma.studentClub.create({
      data: toPrismaClub(data) as any,
    });

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
      return res.status(400).json({ error: 'Validation failed', details: err.issues });
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
      data: toPrismaClub(data) as any,
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
      return res.status(400).json({ error: 'Validation failed', details: err.issues });
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
          orderBy: { joinedAt: 'desc' },
          include: {
            user: {
              select: {
                id: true,
                displayName: true,
                email: true,
                role: true,
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
      userId: m.user?.id || m.userId,
      displayName: m.user?.displayName || 'Student Member',
      email: m.user?.email || 'student@yegnahealth.org',
      role: m.user?.role || 'STUDENT',
      joinedAt: m.joinedAt,
      user: m.user,
    }));

    return res.json({ clubName: club.name, memberCount: roster.length, roster });
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
      include: {
        user: {
          select: {
            id: true,
            displayName: true,
            email: true,
            role: true,
          },
        },
      },
    });

    return res.status(201).json({ success: true, membership });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function leaveClub(req: AuthRequest, res: Response) {
  try {
    if (!req.user) {
      return res.status(401).json({ error: 'Authentication required' });
    }
    const { id: clubId } = req.params;
    const userId = req.user.id;

    await prisma.clubMember.deleteMany({
      where: { userId, clubId },
    });

    return res.json({ success: true, message: 'Left club successfully.' });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function removeMemberAdmin(req: AuthRequest, res: Response) {
  try {
    const { id: clubId, userId } = req.params;

    const deleted = await prisma.clubMember.deleteMany({
      where: { userId, clubId },
    });

    if (deleted.count === 0) {
      return res.status(404).json({ error: 'Membership record not found.' });
    }

    await prisma.auditLog.create({
      data: {
        action: 'CLUB_MEMBER_REMOVED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Removed user ${userId} from club ${clubId}`,
      },
    });

    return res.json({ success: true, message: 'Member removed from club successfully.' });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}
