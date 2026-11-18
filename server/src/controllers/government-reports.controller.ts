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
  const [snapshot] = await source.$queryRaw<GovernmentReportSnapshot[]>`
    WITH monthly_registrations AS (
      SELECT
        to_char(date_trunc('month', "createdAt"), 'YYYY-MM') AS month,
        count(*) FILTER (WHERE role = 'STUDENT')::int AS students,
        count(*) FILTER (WHERE role = 'MENTOR')::int AS mentors
      FROM yegna."User"
      WHERE role IN ('STUDENT', 'MENTOR') AND "createdAt" >= ${trendStart}
      GROUP BY date_trunc('month', "createdAt")
    )
    SELECT
      (SELECT count(*)::int FROM yegna."User" WHERE role = 'STUDENT') AS "registeredStudents",
      (SELECT count(*)::int FROM yegna."User" WHERE role = 'MENTOR') AS "registeredMentors",
      (SELECT count(*)::int FROM yegna."Mentor") AS "mentorProfiles",
      (SELECT count(*)::int FROM yegna."Facility") AS facilities,
      (SELECT count(*)::int FROM yegna."Facility" WHERE "isVerified" = true) AS "verifiedFacilities",
      (SELECT count(*)::int FROM yegna."StudentClub") AS clubs,
      (SELECT count(*)::int FROM yegna."StudentClub" WHERE "isApproved" = true) AS "approvedClubs",
      (SELECT count(*)::int FROM yegna."Module") AS "learningModules",
      (SELECT count(*)::int FROM yegna."Module" WHERE "isPublished" = true) AS "publishedModules",
      (SELECT count(*)::int FROM yegna."QuizQuestion") AS "quizQuestions",
      (SELECT count(*)::int FROM yegna."LearningAssessment") AS "moduleAssessments",
      (SELECT count(*)::int FROM yegna."LearningAssessmentQuestion") AS "assessmentQuestions",
      coalesce(
        (SELECT json_agg(json_build_object('month', month, 'students', students, 'mentors', mentors) ORDER BY month)
         FROM monthly_registrations),
        '[]'::json
      ) AS "registrationTrend"
  `;

  if (!snapshot) throw new Error('Government report aggregate returned no row.');

  return {
    ...snapshot,
    registrationTrend: buildRegistrationTrend(snapshot.registrationTrend, now),
  };
}

export function buildRegistrationTrend(
  monthlyTotals: Array<{ month: string; students: number; mentors: number }>,
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
  for (const total of monthlyTotals) {
    const point = pointByMonth.get(total.month);
    if (!point) continue;
    point.students = total.students;
    point.mentors = total.mentors;
  }

  return points;
}

export async function getGovernmentReports(_req: AuthRequest, res: Response) {
  try {
    const report = await loadGovernmentReportSnapshot();
    return res.json({ report });
  } catch (error) {
    const errorCode = typeof error === 'object' && error !== null && 'code' in error
      ? (error as { code?: unknown }).code
      : undefined;
    console.error(JSON.stringify({
      event: 'government_report_load_failed',
      errorName: error instanceof Error ? error.name : 'UnknownError',
      errorCode: typeof errorCode === 'string' ? errorCode : undefined,
    }));
    return res.status(500).json({ error: 'Failed to load government reports.' });
  }
}
