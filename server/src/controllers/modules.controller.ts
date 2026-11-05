import { Request, Response } from 'express';
import { z } from 'zod';
import { prisma } from '../config/index.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

const moduleSchema = z.object({
  category: z.string().min(2),
  titleEn: z.string().min(2),
  titleAm: z.string().min(2),
  summaryEn: z.string().min(5),
  summaryAm: z.string().min(5),
  contentEn: z.string().min(10),
  contentAm: z.string().min(10),
  readTimeMin: z.number().default(4),
  isPublished: z.boolean().default(true),
  authorName: z.string().optional(),
  orderIndex: z.number().default(0),
});

export async function getAllModules(req: Request, res: Response) {
  try {
    const { category } = req.query;
    const where = category ? { category: String(category) } : {};
    const modules = await prisma.module.findMany({
      where,
      orderBy: { orderIndex: 'asc' },
      include: {
        _count: {
          select: { quizzes: true },
        },
      },
    });

    return res.json({ modules });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function getModuleById(req: Request, res: Response) {
  try {
    const { id } = req.params;
    const mod = await prisma.module.findUnique({
      where: { id },
      include: { quizzes: true },
    });

    if (!mod) {
      return res.status(404).json({ error: 'Module not found' });
    }

    const parsedQuizzes = mod.quizzes.map((q) => ({
      ...q,
      optionsEn: JSON.parse(q.optionsEn || '[]'),
      optionsAm: JSON.parse(q.optionsAm || '[]'),
    }));

    return res.json({
      module: {
        ...mod,
        quizzes: parsedQuizzes,
      },
    });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function createModule(req: AuthRequest, res: Response) {
  try {
    const data = moduleSchema.parse(req.body);
    const mod = await prisma.module.create({ data });

    await prisma.auditLog.create({
      data: {
        action: 'MODULE_CREATED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Published health curriculum module: ${mod.titleEn} (${mod.category})`,
      },
    });

    return res.status(201).json({ module: mod });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: err.errors });
    }
    return res.status(500).json({ error: err.message });
  }
}

export async function updateModule(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const data = moduleSchema.partial().parse(req.body);

    const mod = await prisma.module.update({
      where: { id },
      data,
    });

    await prisma.auditLog.create({
      data: {
        action: 'MODULE_UPDATED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Updated health module: ${mod.titleEn}`,
      },
    });

    return res.json({ module: mod });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: err.errors });
    }
    return res.status(500).json({ error: err.message });
  }
}

export async function deleteModule(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const mod = await prisma.module.delete({ where: { id } });

    await prisma.auditLog.create({
      data: {
        action: 'MODULE_DELETED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Deleted health module: ${mod.titleEn}`,
      },
    });

    return res.json({ success: true, message: 'Module deleted successfully.' });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}
