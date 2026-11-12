import { Request, Response } from 'express';
import { prisma } from '../config/index.js';
import { z } from 'zod';

const surveySubmissionSchema = z.object({
  ageGroup: z.string().min(1),
  yearOfStudy: z.string().min(1),
  disabilityNeed: z.string().min(1),
  knowsGondarSrh: z.string().min(1),
});

/**
 * Anonymously submits baseline survey responses.
 * Strictly avoids recording any user ID, name, email, or device identifier.
 */
export async function submitSurvey(req: Request, res: Response): Promise<void> {
  try {
    const parsed = surveySubmissionSchema.safeParse(req.body);
    if (!parsed.success) {
      res.status(400).json({
        error: 'Invalid survey submission data',
        details: parsed.error.issues,
      });
      return;
    }

    const { ageGroup, yearOfStudy, disabilityNeed, knowsGondarSrh } = parsed.data;

    const record = await prisma.baselineSurveyResponse.create({
      data: {
        ageGroup,
        yearOfStudy,
        disabilityNeed,
        knowsGondarSrh,
      },
    });

    res.status(201).json({
      success: true,
      message: 'Anonymous baseline survey submitted successfully.',
      id: record.id,
      submittedAt: record.submittedAt,
    });
  } catch (err: any) {
    console.error('Error submitting anonymous baseline survey:', err);
    res.status(500).json({
      error: 'Failed to record anonymous survey response',
      message: err.message,
    });
  }
}

/**
 * Returns aggregated statistics for admin analytics.
 * Admin can see total responses and categorical breakdown per question.
 */
export async function getSurveyStats(req: Request, res: Response): Promise<void> {
  try {
    const totalResponses = await prisma.baselineSurveyResponse.count();

    const [byAge, byYear, byDisability, byGondarSrh] = await Promise.all([
      prisma.baselineSurveyResponse.groupBy({
        by: ['ageGroup'],
        _count: { _all: true },
        orderBy: { _count: { ageGroup: 'desc' } },
      }),
      prisma.baselineSurveyResponse.groupBy({
        by: ['yearOfStudy'],
        _count: { _all: true },
        orderBy: { _count: { yearOfStudy: 'desc' } },
      }),
      prisma.baselineSurveyResponse.groupBy({
        by: ['disabilityNeed'],
        _count: { _all: true },
        orderBy: { _count: { disabilityNeed: 'desc' } },
      }),
      prisma.baselineSurveyResponse.groupBy({
        by: ['knowsGondarSrh'],
        _count: { _all: true },
        orderBy: { _count: { knowsGondarSrh: 'desc' } },
      }),
    ]);

    res.json({
      totalResponses,
      breakdown: {
        byAge: byAge.map((item) => ({
          ageGroup: item.ageGroup,
          count: item._count._all,
          percentage: totalResponses > 0 ? Math.round((item._count._all / totalResponses) * 100) : 0,
        })),
        byYearOfStudy: byYear.map((item) => ({
          yearOfStudy: item.yearOfStudy,
          count: item._count._all,
          percentage: totalResponses > 0 ? Math.round((item._count._all / totalResponses) * 100) : 0,
        })),
        byDisabilityNeed: byDisability.map((item) => ({
          disabilityNeed: item.disabilityNeed,
          count: item._count._all,
          percentage: totalResponses > 0 ? Math.round((item._count._all / totalResponses) * 100) : 0,
        })),
        byGondarSrhAwareness: byGondarSrh.map((item) => ({
          knowsGondarSrh: item.knowsGondarSrh,
          count: item._count._all,
          percentage: totalResponses > 0 ? Math.round((item._count._all / totalResponses) * 100) : 0,
        })),
      },
    });
  } catch (err: any) {
    console.error('Error fetching baseline survey statistics:', err);
    res.status(500).json({
      error: 'Failed to retrieve survey statistics',
      message: err.message,
    });
  }
}
