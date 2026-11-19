import { Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { prisma, config } from '../config/index.js';
import { z } from 'zod';

const optionSchema = z.object({
  id: z.string().optional(),
  value: z.string().min(1),
  labelEn: z.string().min(1),
  labelAm: z.string().min(1),
  position: z.number().int().optional(),
});

const createQuestionSchema = z.object({
  key: z.string().optional(),
  sectionNumber: z.number().int().optional(),
  sectionKey: z.string().optional(),
  sectionTitleEn: z.string().optional(),
  sectionTitleAm: z.string().optional(),
  moduleKey: z.string().optional().nullable(),
  titleEn: z.string().min(1),
  titleAm: z.string().min(1),
  descriptionEn: z.string().optional().nullable(),
  descriptionAm: z.string().optional().nullable(),
  type: z.enum(['SINGLE_CHOICE', 'MULTI_CHOICE']).default('SINGLE_CHOICE'),
  position: z.number().int().optional(),
  isRequired: z.boolean().default(true),
  isActive: z.boolean().default(true),
  options: z.array(optionSchema).min(1),
});

const updateQuestionSchema = z.object({
  key: z.string().optional(),
  sectionNumber: z.number().int().optional(),
  sectionKey: z.string().optional(),
  sectionTitleEn: z.string().optional(),
  sectionTitleAm: z.string().optional(),
  moduleKey: z.string().optional().nullable(),
  titleEn: z.string().min(1).optional(),
  titleAm: z.string().min(1).optional(),
  descriptionEn: z.string().optional().nullable(),
  descriptionAm: z.string().optional().nullable(),
  type: z.enum(['SINGLE_CHOICE', 'MULTI_CHOICE']).optional(),
  position: z.number().int().optional(),
  isRequired: z.boolean().optional(),
  isActive: z.boolean().optional(),
  options: z.array(optionSchema).optional(),
});

/**
 * Public: Returns active survey questions for the mobile app and student clients.
 * Supports optional filtering by `section` (number 1..8) and `moduleKey`.
 */
export async function getPublicQuestions(req: Request, res: Response): Promise<void> {
  try {
    const { section, moduleKey } = req.query;
    const where: any = { isActive: true };

    if (section !== undefined && section !== '') {
      const parsedSec = parseInt(section as string, 10);
      if (!isNaN(parsedSec)) {
        where.sectionNumber = parsedSec;
      }
    }

    if (moduleKey && typeof moduleKey === 'string' && moduleKey.trim() !== '') {
      where.moduleKey = moduleKey.trim();
    }

    const questions = await prisma.surveyQuestion.findMany({
      where,
      orderBy: [{ sectionNumber: 'asc' }, { position: 'asc' }],
      include: {
        options: {
          orderBy: { position: 'asc' },
        },
      },
    });
    res.json({ questions });
  } catch (err: any) {
    console.error('Error fetching public survey questions:', err);
    res.status(500).json({ error: 'Failed to retrieve questions', message: err.message });
  }
}

/**
 * Admin: Returns questions (both active and inactive) with their options.
 * Supports optional filtering by `section` and `moduleKey`.
 */
export async function getAdminQuestions(req: Request, res: Response): Promise<void> {
  try {
    const { section, moduleKey } = req.query;
    const where: any = {};

    if (section !== undefined && section !== '' && section !== 'ALL') {
      const parsedSec = parseInt(section as string, 10);
      if (!isNaN(parsedSec)) {
        where.sectionNumber = parsedSec;
      }
    }

    if (moduleKey && typeof moduleKey === 'string' && moduleKey.trim() !== '' && moduleKey !== 'ALL') {
      where.moduleKey = moduleKey.trim();
    }

    const questions = await prisma.surveyQuestion.findMany({
      where,
      orderBy: [{ sectionNumber: 'asc' }, { position: 'asc' }],
      include: {
        options: {
          orderBy: { position: 'asc' },
        },
      },
    });
    res.json({ questions });
  } catch (err: any) {
    console.error('Error fetching admin survey questions:', err);
    res.status(500).json({ error: 'Failed to retrieve questions', message: err.message });
  }
}

/**
 * Admin: Creates a new survey question with options.
 */
export async function createQuestionAdmin(req: Request, res: Response): Promise<void> {
  try {
    const parsed = createQuestionSchema.safeParse(req.body);
    if (!parsed.success) {
      res.status(400).json({ error: 'Validation failed', details: parsed.error.issues });
      return;
    }

    const data = parsed.data;
    const count = await prisma.surveyQuestion.count();
    const position = data.position ?? count + 1;
    const generatedKey = data.key?.trim() || `q_${Date.now()}_${Math.random().toString(36).substring(2, 6)}`;

    const question = await prisma.surveyQuestion.create({
      data: {
        key: generatedKey,
        sectionNumber: data.sectionNumber ?? 1,
        sectionKey: data.sectionKey ?? `section_${data.sectionNumber ?? 1}`,
        sectionTitleEn: data.sectionTitleEn ?? 'Personal and General Information',
        sectionTitleAm: data.sectionTitleAm ?? 'ክፍል 1፡ አጠቃላይ የግል መረጃ',
        moduleKey: data.moduleKey,
        titleEn: data.titleEn.trim(),
        titleAm: data.titleAm.trim(),
        descriptionEn: data.descriptionEn?.trim() || null,
        descriptionAm: data.descriptionAm?.trim() || null,
        type: data.type,
        position,
        isRequired: data.isRequired,
        isActive: data.isActive,
        options: {
          create: data.options.map((opt, idx) => ({
            position: opt.position ?? idx + 1,
            value: opt.value.trim(),
            labelEn: opt.labelEn.trim(),
            labelAm: opt.labelAm.trim(),
          })),
        },
      },
      include: {
        options: {
          orderBy: { position: 'asc' },
        },
      },
    });

    await prisma.auditLog.create({
      data: {
        action: 'SURVEY_QUESTION_CREATED',
        adminEmail: (req as any).user?.email || 'admin@yegnahealth.org',
        details: `Created survey question: "${question.titleEn}" (${question.id}) with ${question.options.length} options`,
      },
    });

    res.status(201).json({ success: true, question });
  } catch (err: any) {
    console.error('Error creating survey question:', err);
    res.status(500).json({ error: 'Failed to create question', message: err.message });
  }
}

/**
 * Admin: Updates an existing question and its options.
 */
export async function updateQuestionAdmin(req: Request, res: Response): Promise<void> {
  try {
    const { id } = req.params;
    const parsed = updateQuestionSchema.safeParse(req.body);
    if (!parsed.success) {
      res.status(400).json({ error: 'Validation failed', details: parsed.error.issues });
      return;
    }

    const data = parsed.data;
    const existing = await prisma.surveyQuestion.findUnique({
      where: { id },
      include: { options: true },
    });

    if (!existing) {
      res.status(404).json({ error: 'Question not found' });
      return;
    }

    // Execute update in a transaction
    const updated = await prisma.$transaction(async (tx) => {
      if (data.options) {
        // Delete previous options and recreate
        await tx.surveyQuestionOption.deleteMany({
          where: { questionId: id },
        });

        await tx.surveyQuestionOption.createMany({
          data: data.options.map((opt, idx) => ({
            questionId: id,
            position: opt.position ?? idx + 1,
            value: opt.value.trim(),
            labelEn: opt.labelEn.trim(),
            labelAm: opt.labelAm.trim(),
          })),
        });
      }

      return tx.surveyQuestion.update({
        where: { id },
        data: {
          sectionNumber: data.sectionNumber,
          sectionKey: data.sectionKey,
          sectionTitleEn: data.sectionTitleEn,
          sectionTitleAm: data.sectionTitleAm,
          moduleKey: data.moduleKey !== undefined ? data.moduleKey : undefined,
          titleEn: data.titleEn?.trim(),
          titleAm: data.titleAm?.trim(),
          descriptionEn: data.descriptionEn !== undefined ? data.descriptionEn?.trim() || null : undefined,
          descriptionAm: data.descriptionAm !== undefined ? data.descriptionAm?.trim() || null : undefined,
          type: data.type,
          position: data.position,
          isRequired: data.isRequired,
          isActive: data.isActive,
        },
        include: {
          options: {
            orderBy: { position: 'asc' },
          },
        },
      });
    });

    await prisma.auditLog.create({
      data: {
        action: 'SURVEY_QUESTION_UPDATED',
        adminEmail: (req as any).user?.email || 'admin@yegnahealth.org',
        details: `Updated survey question: "${updated.titleEn}" (${updated.id})`,
      },
    });

    res.json({ success: true, question: updated });
  } catch (err: any) {
    console.error('Error updating survey question:', err);
    res.status(500).json({ error: 'Failed to update question', message: err.message });
  }
}

/**
 * Admin: Deletes a survey question.
 */
export async function deleteQuestionAdmin(req: Request, res: Response): Promise<void> {
  try {
    const { id } = req.params;
    const question = await prisma.surveyQuestion.findUnique({
      where: { id },
      select: { titleEn: true },
    });

    if (!question) {
      res.status(404).json({ error: 'Question not found' });
      return;
    }

    await prisma.surveyQuestion.delete({
      where: { id },
    });

    await prisma.auditLog.create({
      data: {
        action: 'SURVEY_QUESTION_DELETED',
        adminEmail: (req as any).user?.email || 'admin@yegnahealth.org',
        details: `Deleted survey question: "${question.titleEn}" (${id})`,
      },
    });

    res.json({ success: true, message: 'Question deleted successfully' });
  } catch (err: any) {
    console.error('Error deleting survey question:', err);
    res.status(500).json({ error: 'Failed to delete question', message: err.message });
  }
}

/**
 * Anonymously submits baseline survey responses.
 * Supports both dynamic answer maps ({ [key]: value }) and legacy fields.
 * Strictly avoids recording any personal identifiable information (Zero-PII).
 */
export async function submitSurvey(req: Request, res: Response): Promise<void> {
  try {
    const body = req.body || {};
    const dynamicAnswers: Record<string, string> = body.answers || {};

    // Extract values either from dynamic answers map or from legacy fields
    const ageGroup = body.ageGroup || dynamicAnswers['age_group'] || dynamicAnswers['q1'] || null;
    const yearOfStudy = body.yearOfStudy || dynamicAnswers['year_of_study'] || dynamicAnswers['q2'] || null;
    const disabilityNeed = body.disabilityNeed || dynamicAnswers['disability_need'] || dynamicAnswers['q3'] || null;
    const knowsGondarSrh = body.knowsGondarSrh || dynamicAnswers['gondar_srh'] || dynamicAnswers['q4'] || null;

    // Build the consolidated answers JSON object
    const finalAnswers: Record<string, any> = { ...dynamicAnswers };
    if (ageGroup && !finalAnswers['age_group']) finalAnswers['age_group'] = ageGroup;
    if (yearOfStudy && !finalAnswers['year_of_study']) finalAnswers['year_of_study'] = yearOfStudy;
    if (disabilityNeed && !finalAnswers['disability_need']) finalAnswers['disability_need'] = disabilityNeed;
    if (knowsGondarSrh && !finalAnswers['gondar_srh']) finalAnswers['gondar_srh'] = knowsGondarSrh;

    // 1. Check if authenticated student has already submitted previously
    let markedForUser = false;
    let userId: string | null = null;
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.substring(7);
      try {
        const decoded = jwt.verify(token, config.jwtSecret) as any;
        if (decoded && decoded.id) {
          userId = decoded.id;
          const user = await prisma.user.findUnique({
            where: { id: decoded.id },
            select: { id: true, hasCompletedSurvey: true },
          });
          if (user?.hasCompletedSurvey) {
            res.status(200).json({
              success: true,
              message: 'Baseline survey already completed for this student account.',
              alreadyCompleted: true,
            });
            return;
          }
        }
      } catch {
        // Token verification failed or expired; anonymous submission is still preserved
      }
    }

    // 2. Rapid double-tap deduplication shield (5-second window for identical submissions)
    const fiveSecondsAgo = new Date(Date.now() - 5000);
    const recentDuplicate = await prisma.baselineSurveyResponse.findFirst({
      where: {
        ageGroup: ageGroup || undefined,
        yearOfStudy: yearOfStudy || undefined,
        submittedAt: { gte: fiveSecondsAgo },
      },
    });

    if (recentDuplicate) {
      if (userId) {
        await prisma.user.update({
          where: { id: userId },
          data: { hasCompletedSurvey: true },
        });
      }
      res.status(200).json({
        success: true,
        message: 'Duplicate survey submission absorbed safely.',
        id: recentDuplicate.id,
        submittedAt: recentDuplicate.submittedAt,
        duplicateIgnored: true,
      });
      return;
    }

    // 3. Create the single anonymous record (Zero-PII)
    const record = await prisma.baselineSurveyResponse.create({
      data: {
        ageGroup,
        yearOfStudy,
        disabilityNeed,
        knowsGondarSrh,
        answers: typeof finalAnswers === 'string' ? finalAnswers : JSON.stringify(finalAnswers),
      },
    });

    if (userId) {
      await prisma.user.update({
        where: { id: userId },
        data: { hasCompletedSurvey: true },
      });
      markedForUser = true;
    }

    res.status(201).json({
      success: true,
      message: 'Anonymous baseline survey submitted successfully.',
      id: record.id,
      submittedAt: record.submittedAt,
      userSurveyCompleted: markedForUser,
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
 * Dynamically aggregates counts for every active question as well as legacy groupings.
 */
export async function getSurveyStats(_req: Request, res: Response): Promise<void> {
  try {
    const [totalResponses, questions, allSubmissions] = await Promise.all([
      prisma.baselineSurveyResponse.count(),
      prisma.surveyQuestion.findMany({
        where: { isActive: true },
        orderBy: { position: 'asc' },
        include: {
          options: {
            orderBy: { position: 'asc' },
          },
        },
      }),
      prisma.baselineSurveyResponse.findMany({
        take: 100,
        orderBy: { submittedAt: 'desc' },
      }),
    ]);

    // Build dynamic breakdowns per question
    const dynamicBreakdowns = questions.map((q) => {
      const countsByValue: Record<string, number> = {};
      q.options.forEach((opt) => {
        countsByValue[opt.value] = 0;
      });

      // Count across all responses
      allSubmissions.forEach((sub) => {
        let answerVal: string | undefined;

        // Check dynamic JSON answers
        if (sub.answers && typeof sub.answers === 'object') {
          const ansMap = sub.answers as Record<string, any>;
          answerVal = ansMap[q.key] || ansMap[q.id];
        }

        // Fallback to legacy column mapping if key matches
        if (!answerVal) {
          if (q.key === 'age_group') answerVal = sub.ageGroup ?? undefined;
          else if (q.key === 'year_of_study') answerVal = sub.yearOfStudy ?? undefined;
          else if (q.key === 'disability_need') answerVal = sub.disabilityNeed ?? undefined;
          else if (q.key === 'gondar_srh') answerVal = sub.knowsGondarSrh ?? undefined;
        }

        if (answerVal && countsByValue[answerVal] !== undefined) {
          countsByValue[answerVal]++;
        }
      });

      return {
        id: q.id,
        key: q.key,
        sectionNumber: q.sectionNumber ?? 1,
        sectionKey: q.sectionKey ?? `section_${q.sectionNumber ?? 1}`,
        sectionTitleEn: q.sectionTitleEn ?? null,
        sectionTitleAm: q.sectionTitleAm ?? null,
        moduleKey: q.moduleKey ?? null,
        position: q.position ?? 0,
        titleEn: q.titleEn,
        titleAm: q.titleAm,
        type: q.type,
        options: q.options.map((opt) => {
          const count = countsByValue[opt.value] || 0;
          const percentage = totalResponses > 0 ? Math.round((count / totalResponses) * 100) : 0;
          return {
            id: opt.id,
            value: opt.value,
            labelEn: opt.labelEn,
            labelAm: opt.labelAm,
            count,
            percentage,
          };
        }),
      };
    });

    // Legacy breakdown arrays for existing UI widgets
    const [byAge, byYear, byDisability, byGondarSrh] = await Promise.all([
      prisma.baselineSurveyResponse.groupBy({
        by: ['ageGroup'],
        _count: { _all: true },
        where: { ageGroup: { not: null } },
      }),
      prisma.baselineSurveyResponse.groupBy({
        by: ['yearOfStudy'],
        _count: { _all: true },
        where: { yearOfStudy: { not: null } },
      }),
      prisma.baselineSurveyResponse.groupBy({
        by: ['disabilityNeed'],
        _count: { _all: true },
        where: { disabilityNeed: { not: null } },
      }),
      prisma.baselineSurveyResponse.groupBy({
        by: ['knowsGondarSrh'],
        _count: { _all: true },
        where: { knowsGondarSrh: { not: null } },
      }),
    ]);

    res.json({
      totalResponses,
      questions: dynamicBreakdowns,
      breakdown: {
        byAge: byAge.map((item) => ({
          ageGroup: item.ageGroup || 'Unknown',
          count: item._count._all,
          percentage: totalResponses > 0 ? Math.round((item._count._all / totalResponses) * 100) : 0,
        })),
        byYearOfStudy: byYear.map((item) => ({
          yearOfStudy: item.yearOfStudy || 'Unknown',
          count: item._count._all,
          percentage: totalResponses > 0 ? Math.round((item._count._all / totalResponses) * 100) : 0,
        })),
        byDisabilityNeed: byDisability.map((item) => ({
          disabilityNeed: item.disabilityNeed || 'NONE',
          count: item._count._all,
          percentage: totalResponses > 0 ? Math.round((item._count._all / totalResponses) * 100) : 0,
        })),
        byGondarSrhAwareness: byGondarSrh.map((item) => ({
          knowsGondarSrh: item.knowsGondarSrh || 'NOT_SURE',
          count: item._count._all,
          percentage: totalResponses > 0 ? Math.round((item._count._all / totalResponses) * 100) : 0,
        })),
      },
      recentSubmissions: allSubmissions.map((s) => ({
        id: s.id,
        ageGroup: s.ageGroup || 'N/A',
        yearOfStudy: s.yearOfStudy || 'N/A',
        disabilityNeed: s.disabilityNeed || 'NONE',
        knowsGondarSrh: s.knowsGondarSrh || 'NOT_SURE',
        answers: typeof s.answers === 'string' ? (() => { try { return JSON.parse(s.answers); } catch { return s.answers; } })() : s.answers,
        submittedAt: s.submittedAt,
      })),
    });
  } catch (err: any) {
    console.error('Error fetching baseline survey statistics:', err);
    res.status(500).json({
      error: 'Failed to retrieve survey statistics',
      message: err.message,
    });
  }
}

/**
 * Deletes a single survey response by ID (for admin maintenance).
 */
export async function deleteSurveyResponse(req: Request, res: Response): Promise<void> {
  try {
    const { id } = req.params;
    await prisma.baselineSurveyResponse.delete({
      where: { id },
    });
    res.json({ success: true, message: 'Survey response deleted' });
  } catch (err: any) {
    res.status(500).json({ error: 'Failed to delete survey response', message: err.message });
  }
}

/**
 * Clears all baseline survey test responses.
 */
export async function clearSurveyResponses(_req: Request, res: Response): Promise<void> {
  try {
    const count = await prisma.baselineSurveyResponse.deleteMany();
    res.json({ success: true, message: `Cleared ${count.count} survey responses` });
  } catch (err: any) {
    res.status(500).json({ error: 'Failed to clear survey responses', message: err.message });
  }
}
