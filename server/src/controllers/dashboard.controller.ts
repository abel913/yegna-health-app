import { Response } from 'express';
import { prisma } from '../config/index.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

export async function getDashboardMetrics(req: AuthRequest, res: Response) {
  try {
    const [
      activeArticles,
      learningModules,
      quizQuestions,
      verifiedFacilities,
      counselorMentors,
      studentClubs,
      registeredUsers,
    ] = await Promise.all([
      prisma.module.count({ where: { isPublished: true } }),
      prisma.module.count(),
      prisma.quizQuestion.count(),
      prisma.facility.count({ where: { isVerified: true } }),
      prisma.mentor.count(),
      prisma.studentClub.count({ where: { isApproved: true } }),
      prisma.user.count(),
    ]);

    const recentAuditLogs = await prisma.auditLog.findMany({
      take: 8,
      orderBy: { timestamp: 'desc' },
    });

    return res.json({
      metrics: {
        activeArticles,
        learningModules,
        quizQuestions,
        verifiedFacilities,
        counselorMentors,
        studentClubs,
        registeredUsers,
      },
      recentActivity: recentAuditLogs,
    });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function getAuditLogs(req: AuthRequest, res: Response) {
  try {
    const logs = await prisma.auditLog.findMany({
      take: 50,
      orderBy: { timestamp: 'desc' },
    });

    return res.json({ logs });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}
