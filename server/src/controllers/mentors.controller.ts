import { Request, Response } from 'express';
import { z } from 'zod';
import { prisma } from '../config/index.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

const mentorSchema = z.object({
  name: z.string().min(2),
  organization: z.string().min(2),
  campus: z.string().default('Atse Fasil Campus'),
  roleTitleEn: z.string().default('Certified Youth Peer Counselor'),
  roleTitleAm: z.string().default('የተረጋገጠ የወጣቶች አቻ አማካሪ'),
  phone: z.string().min(5),
  whatsapp: z.string().optional().nullable().transform((val) => (val && val.trim().length > 0 ? val.trim() : null)),
  telegramHandle: z.string().optional().nullable().transform((val) => {
    if (!val || !val.trim()) return null;
    return val.replace(/^@+/, '').trim();
  }),
  email: z.string().email().optional().or(z.literal('')).nullable().transform((val) => (val && val.trim().length > 0 ? val.trim() : null)),
  experienceYears: z.coerce.number().int().min(0).default(2),
  sessionsCount: z.coerce.number().int().min(0).default(120),
  workingHoursEn: z.string().default('Mon – Fri: 8:30 AM – 5:30 PM'),
  workingHoursAm: z.string().default('ከሰኞ – ዓርብ፡ 2:30 – 11:30'),
  bioEn: z.string().optional().nullable(),
  bioAm: z.string().optional().nullable(),
  languages: z.array(z.string()).default(['Amharic', 'English']),
  specialties: z.array(z.string()).default([]),
  isAvailable: z.boolean().default(true),
  isVerified: z.boolean().default(true),
});

export async function getAllMentors(req: Request, res: Response) {
  try {
    const mentors = await prisma.mentor.findMany({
      orderBy: { createdAt: 'desc' },
    });

    const parsed = mentors.map((m) => ({
      ...m,
      languages: JSON.parse(m.languages || '[]'),
      specialties: JSON.parse(m.specialties || '[]'),
    }));

    return res.json({ mentors: parsed });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function createMentor(req: AuthRequest, res: Response) {
  try {
    const data = mentorSchema.parse(req.body);

    // Prevent duplicate creations within 15 seconds (double-click debounce protection)
    const fifteenSecondsAgo = new Date(Date.now() - 15 * 1000);
    const existingRecent = await prisma.mentor.findFirst({
      where: {
        name: data.name,
        phone: data.phone,
        createdAt: { gte: fifteenSecondsAgo },
      },
    });

    if (existingRecent) {
      return res.status(200).json({
        mentor: {
          ...existingRecent,
          languages: JSON.parse(existingRecent.languages || '[]'),
          specialties: JSON.parse(existingRecent.specialties || '[]'),
        },
      });
    }

    const mentor = await prisma.mentor.create({
      data: {
        ...data,
        languages: JSON.stringify(data.languages),
        specialties: JSON.stringify(data.specialties),
      },
    });

    await prisma.auditLog.create({
      data: {
        action: 'MENTOR_CREATED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Registered certified mentor: ${mentor.name} (${mentor.organization})`,
      },
    });

    return res.status(201).json({
      mentor: {
        ...mentor,
        languages: data.languages,
        specialties: data.specialties,
      },
    });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: err.errors });
    }
    return res.status(500).json({ error: err.message });
  }
}

export async function updateMentor(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const data = mentorSchema.partial().parse(req.body);

    const updateData: any = { ...data };
    if (data.languages !== undefined) {
      updateData.languages = JSON.stringify(data.languages);
    }
    if (data.specialties !== undefined) {
      updateData.specialties = JSON.stringify(data.specialties);
    }

    const mentor = await prisma.mentor.update({
      where: { id },
      data: updateData,
    });

    await prisma.auditLog.create({
      data: {
        action: 'MENTOR_UPDATED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Updated mentor: ${mentor.name}`,
      },
    });

    return res.json({
      mentor: {
        ...mentor,
        languages: JSON.parse(mentor.languages || '[]'),
        specialties: JSON.parse(mentor.specialties || '[]'),
      },
    });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: err.errors });
    }
    return res.status(500).json({ error: err.message });
  }
}

export async function deleteMentor(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const mentor = await prisma.mentor.delete({ where: { id } });

    await prisma.auditLog.create({
      data: {
        action: 'MENTOR_DELETED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Deleted mentor profile: ${mentor.name}`,
      },
    });

    return res.json({ success: true, message: 'Mentor deleted successfully.' });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}
