import { Request, Response } from 'express';
import { z } from 'zod';
import { prisma } from '../config/index.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

export const broadcastNotificationSchema = z.object({
  titleEn: z.string().min(2, 'English title must be at least 2 characters'),
  titleAm: z.string().min(2, 'Amharic title must be at least 2 characters'),
  messageEn: z.string().min(2, 'English message must be at least 2 characters'),
  messageAm: z.string().min(2, 'Amharic message must be at least 2 characters'),
  type: z.enum(['healthTip', 'system', 'alert', 'learning', 'facility', 'club']).default('system'),
  priority: z.enum(['normal', 'high', 'urgent']).default('normal'),
  targetCampus: z.string().default('All'),
  routePayload: z.string().optional().nullable(),
  actionLabelEn: z.string().optional().nullable(),
  actionLabelAm: z.string().optional().nullable(),
  isPinned: z.boolean().default(false),
  expiresAt: z.string().datetime().optional().nullable(),
});

export async function getUserNotifications(req: AuthRequest, res: Response) {
  try {
    const userId = req.user?.id;
    const campusQuery = req.query.campus ? String(req.query.campus) : undefined;
    const now = new Date();

    // 1. Fetch active broadcasts (not expired, and matching targetCampus)
    const campusConditions: any[] = [{ targetCampus: 'All' }];
    if (campusQuery && campusQuery !== 'All') {
      campusConditions.push({ targetCampus: campusQuery });
    }

    const broadcasts = await prisma.broadcastNotification.findMany({
      where: {
        OR: campusConditions,
        AND: [
          {
            OR: [
              { expiresAt: null },
              { expiresAt: { gt: now } },
            ],
          },
        ],
      },
      orderBy: [{ isPinned: 'desc' }, { createdAt: 'desc' }],
      take: 30,
    });

    const broadcastNotifs = broadcasts.map((b) => ({
      id: `broadcast_${b.id}`,
      rawId: b.id,
      titleEn: b.titleEn,
      titleAm: b.titleAm,
      title: b.titleEn,
      messageEn: b.messageEn,
      messageAm: b.messageAm,
      message: b.messageEn,
      timestamp: b.createdAt,
      type: b.type,
      priority: b.priority,
      targetCampus: b.targetCampus,
      routePayload: b.routePayload || undefined,
      actionLabelEn: b.actionLabelEn || undefined,
      actionLabelAm: b.actionLabelAm || undefined,
      actionLabel: b.actionLabelEn || undefined,
      isPinned: b.isPinned,
      source: 'broadcast',
    }));

    // 2. Fetch club announcements
    let clubNotifs: any[] = [];
    if (!userId) {
      // Guests receive pinned public announcements
      const publicAnnouncements = await prisma.clubAnnouncement.findMany({
        where: { isPinned: true },
        orderBy: { createdAt: 'desc' },
        take: 10,
        include: {
          club: { select: { id: true, name: true } },
        },
      });

      clubNotifs = publicAnnouncements.map((ann) => ({
        id: `ann_${ann.id}`,
        rawId: ann.id,
        titleEn: `📢 ${ann.club.name}: ${ann.title}`,
        titleAm: `📢 ${ann.club.name}: ${ann.title}`,
        title: `📢 ${ann.club.name}: ${ann.title}`,
        messageEn: ann.content,
        messageAm: ann.content,
        message: ann.content,
        timestamp: ann.createdAt,
        type: 'club',
        priority: ann.isPinned ? 'high' : 'normal',
        targetCampus: 'All',
        routePayload: `club:${ann.clubId}`,
        actionLabelEn: 'View Club',
        actionLabelAm: 'ክበቡን ይመልከቱ',
        actionLabel: 'View Club',
        clubId: ann.clubId,
        clubName: ann.club.name,
        isPinned: ann.isPinned,
        source: 'club',
      }));
    } else {
      // Authenticated users receive announcements for joined clubs + pinned notices
      const memberships = await prisma.clubMember.findMany({
        where: { userId },
        select: { clubId: true },
      });
      const clubIds = memberships.map((m) => m.clubId);

      const announcements = await prisma.clubAnnouncement.findMany({
        where: {
          OR: [
            { clubId: { in: clubIds } },
            { isPinned: true },
          ],
        },
        orderBy: { createdAt: 'desc' },
        take: 25,
        include: {
          club: { select: { id: true, name: true } },
        },
      });

      clubNotifs = announcements.map((ann) => ({
        id: `ann_${ann.id}`,
        rawId: ann.id,
        titleEn: `📢 ${ann.club.name}: ${ann.title}`,
        titleAm: `📢 ${ann.club.name}: ${ann.title}`,
        title: `📢 ${ann.club.name}: ${ann.title}`,
        messageEn: ann.content,
        messageAm: ann.content,
        message: ann.content,
        timestamp: ann.createdAt,
        type: 'club',
        priority: ann.isPinned ? 'high' : 'normal',
        targetCampus: 'All',
        routePayload: `club:${ann.clubId}`,
        actionLabelEn: 'View Club',
        actionLabelAm: 'ክበቡን ይመልከቱ',
        actionLabel: 'View Club',
        clubId: ann.clubId,
        clubName: ann.club.name,
        isPinned: ann.isPinned,
        source: 'club',
      }));
    }

    // 3. Merge & sort by pinned first, then newest
    const merged = [...broadcastNotifs, ...clubNotifs];
    merged.sort((a, b) => {
      if (a.isPinned !== b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      if (a.priority === 'urgent' && b.priority !== 'urgent') return -1;
      if (b.priority === 'urgent' && a.priority !== 'urgent') return 1;
      return new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime();
    });

    return res.json({ notifications: merged });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function getAdminBroadcasts(req: AuthRequest, res: Response) {
  try {
    const broadcasts = await prisma.broadcastNotification.findMany({
      orderBy: { createdAt: 'desc' },
    });
    return res.json({ broadcasts });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function broadcastNotification(req: AuthRequest, res: Response) {
  try {
    const data = broadcastNotificationSchema.parse(req.body);

    const broadcast = await prisma.broadcastNotification.create({
      data: {
        titleEn: data.titleEn,
        titleAm: data.titleAm,
        messageEn: data.messageEn,
        messageAm: data.messageAm,
        type: data.type,
        priority: data.priority,
        targetCampus: data.targetCampus,
        routePayload: data.routePayload || null,
        actionLabelEn: data.actionLabelEn || null,
        actionLabelAm: data.actionLabelAm || null,
        isPinned: data.isPinned,
        authorEmail: req.user?.email || 'admin@yegnahealth.org',
        expiresAt: data.expiresAt ? new Date(data.expiresAt) : null,
      },
    });

    await prisma.auditLog.create({
      data: {
        action: 'NOTIFICATION_BROADCAST_CREATED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Broadcasted ${data.priority.toUpperCase()} [${data.type}] notification: "${data.titleEn}" to ${data.targetCampus}`,
      },
    });

    return res.status(201).json({ broadcast });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: err.issues });
    }
    return res.status(500).json({ error: err.message });
  }
}

export async function deleteBroadcastNotification(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const broadcast = await prisma.broadcastNotification.delete({
      where: { id },
    });

    await prisma.auditLog.create({
      data: {
        action: 'NOTIFICATION_BROADCAST_DELETED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Deleted notification broadcast: "${broadcast.titleEn}"`,
      },
    });

    return res.json({ success: true, message: 'Broadcast deleted' });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}
