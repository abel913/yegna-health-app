import { Response } from 'express';
import { prisma } from '../config/index.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

export interface GovernmentReportPoint {
  month: string;
  students: number;
  mentors: number;
}

export interface GovernmentReportSnapshot {
  registeredStudents: number;
  registeredMentors: number;
  mentorProfiles: number;
  facilities: number;
  verifiedFacilities: number;
  clubs: number;
  approvedClubs: number;
  learningModules: number;
  publishedModules: number;
  quizQuestions: number;
  moduleAssessments: number;
  assessmentQuestions: number;
  registrationTrend: GovernmentReportPoint[];
}

export async function loadGovernmentReportSnapshot(
  source: typeof prisma = prisma,
  now = new Date(),
): Promise<GovernmentReportSnapshot> {
  const trendStart = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - 11, 1));
  const [
    registeredStudents,
    registeredMentors,
    mentorProfiles,
    facilities,
    verifiedFacilities,
    clubs,
    approvedClubs,
    learningModules,
    publishedModules,
    quizQuestions,
    moduleAssessments,
    assessmentQuestions,
    trendUsers,
  ] = await Promise.all([
    source.user.count({ where: { role: 'STUDENT' } }),
    source.user.count({ where: { role: 'MENTOR' } }),
    source.mentor.count(),
    source.facility.count(),
    source.facility.count({ where: { isVerified: true } }),
    source.studentClub.count(),
    source.studentClub.count({ where: { isApproved: true } }),
    source.module.count(),
    source.module.count({ where: { isPublished: true } }),
    source.quizQuestion.count(),
    source.learningAssessment.count(),
    source.learningAssessmentQuestion.count(),
    source.user.findMany({
      where: {
        role: { in: ['STUDENT', 'MENTOR'] },
        createdAt: { gte: trendStart },
      },
      select: { role: true, createdAt: true },
    }),
  ]);

  return {
    registeredStudents,
    registeredMentors,
    mentorProfiles,
    facilities,
    verifiedFacilities,
    clubs,
    approvedClubs,
    learningModules,
    publishedModules,
    quizQuestions,
    moduleAssessments,
    assessmentQuestions,
    registrationTrend: buildRegistrationTrend(trendUsers, now),
  };
}

export function buildRegistrationTrend(
  users: Array<{ role: string; createdAt: Date }>,
  now = new Date(),
): GovernmentReportPoint[] {
  const points: GovernmentReportPoint[] = [];
  for (let offset = 11; offset >= 0; offset -= 1) {
    const monthDate = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - offset, 1));
    points.push({
      month: monthDate.toISOString().slice(0, 7),
      students: 0,
      mentors: 0,
    });
  }

  const pointByMonth = new Map(points.map((point) => [point.month, point]));
  for (const user of users) {
    const point = pointByMonth.get(user.createdAt.toISOString().slice(0, 7));
    if (!point) continue;
    if (user.role === 'STUDENT') point.students += 1;
    if (user.role === 'MENTOR') point.mentors += 1;
  }

  return points;
}

export async function getGovernmentReports(_req: AuthRequest, res: Response) {
  try {
    const report = await loadGovernmentReportSnapshot();
    return res.json({ report });
  } catch {
    return res.status(500).json({ error: 'Failed to load government reports.' });
  }
}
