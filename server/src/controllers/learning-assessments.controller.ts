import { Request, Response } from 'express';
import { z } from 'zod';
import { prisma } from '../config/index.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

const schema = z.object({
  moduleId: z.string().min(1),
  questions: z.array(z.object({
    promptEn: z.string().min(3),
    promptAm: z.string().min(2),
    choices: z.array(z.object({ labelEn: z.string().min(1), labelAm: z.string().min(1), score: z.number().int().min(-100).max(100) })).length(5),
  })).min(1),
});

export async function getAll(_req: Request, res: Response) {
  try {
    const assessments = await prisma.learningAssessment.findMany({
      include: { module: { select: { titleEn: true, titleAm: true, category: true } }, questions: { orderBy: { position: 'asc' }, include: { choices: { orderBy: { position: 'asc' } } } } },
      orderBy: { createdAt: 'asc' },
    });
    return res.json({ assessments });
  } catch (error) { return res.status(500).json({ error: 'Failed to load learning assessments.' }); }
}

export async function save(req: AuthRequest, res: Response) {
  const parsed = schema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: 'Assessment needs a module, at least one question and five bilingual scored choices per question.' });
  try {
    const data = parsed.data;
    const saved = await prisma.$transaction(async (tx) => {
      const assessment = await tx.learningAssessment.upsert({ where: { moduleId: data.moduleId }, create: { moduleId: data.moduleId }, update: {} });
      await tx.learningAssessmentQuestion.deleteMany({ where: { assessmentId: assessment.id } });
      for (const [position, question] of data.questions.entries()) {
        await tx.learningAssessmentQuestion.create({ data: { assessmentId: assessment.id, position, promptEn: question.promptEn, promptAm: question.promptAm, choices: { create: question.choices.map((choice, choicePosition) => ({ ...choice, position: choicePosition })) } } });
      }
      return tx.learningAssessment.findUniqueOrThrow({ where: { id: assessment.id }, include: { module: { select: { titleEn: true, titleAm: true, category: true } }, questions: { orderBy: { position: 'asc' }, include: { choices: { orderBy: { position: 'asc' } } } } } });
    });
    await prisma.auditLog.create({ data: { action: 'LEARNING_ASSESSMENT_SAVED', adminEmail: req.user?.email ?? 'admin', details: `Saved learning assessment for module ${data.moduleId}` } });
    return res.json({ assessment: saved });
  } catch (error) { return res.status(500).json({ error: 'Failed to save learning assessment.' }); }
}

export async function remove(req: AuthRequest, res: Response) {
  try {
    await prisma.learningAssessment.delete({ where: { id: req.params.id } });
    await prisma.auditLog.create({ data: { action: 'LEARNING_ASSESSMENT_DELETED', adminEmail: req.user?.email ?? 'admin', details: `Deleted learning assessment ${req.params.id}` } });
    return res.json({ success: true });
  } catch (error) { return res.status(404).json({ error: 'Learning assessment not found.' }); }
}
