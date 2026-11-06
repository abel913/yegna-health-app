import { Request, Response } from 'express';
import { z } from 'zod';
import { prisma } from '../config/index.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

const baseQuestionSchema = z.object({
  moduleId: z.string().min(1),
  type: z.enum(['MULTIPLE_CHOICE', 'TRUE_FALSE']).default('MULTIPLE_CHOICE'),
  questionEn: z.string().min(3),
  questionAm: z.string().min(3),
  optionsEn: z.array(z.string()).min(2).max(4),
  optionsAm: z.array(z.string()).min(2).max(4),
  correctIndex: z.number().min(0).max(3),
  explanationEn: z.string().min(5),
  explanationAm: z.string().min(5),
});

const questionSchema = baseQuestionSchema.refine((data) => {
  if (data.type === 'TRUE_FALSE') {
    return data.optionsEn.length === 2 && data.optionsAm.length === 2 && data.correctIndex <= 1;
  }
  return data.optionsEn.length === 4 && data.optionsAm.length === 4 && data.correctIndex <= 3;
}, {
  message: 'True/False questions must have exactly 2 options with correct index 0 or 1. Multiple Choice must have 4 options with index 0-3.',
});

const updateQuestionSchema = baseQuestionSchema.partial().refine((data) => {
  if (data.type === 'TRUE_FALSE') {
    if (data.optionsEn && data.optionsEn.length !== 2) return false;
    if (data.optionsAm && data.optionsAm.length !== 2) return false;
    if (data.correctIndex !== undefined && data.correctIndex > 1) return false;
  }
  if (data.type === 'MULTIPLE_CHOICE') {
    if (data.optionsEn && data.optionsEn.length !== 4) return false;
    if (data.optionsAm && data.optionsAm.length !== 4) return false;
    if (data.correctIndex !== undefined && data.correctIndex > 3) return false;
  }
  return true;
}, {
  message: 'True/False questions must have exactly 2 options with correct index 0 or 1. Multiple Choice must have 4 options with index 0-3.',
});

export async function getAllQuestions(req: Request, res: Response) {
  try {
    const { moduleId } = req.query;
    const where = moduleId ? { moduleId: String(moduleId) } : {};
    const questions = await prisma.quizQuestion.findMany({
      where,
      orderBy: { createdAt: 'asc' },
      include: {
        module: {
          select: { titleEn: true, titleAm: true, category: true },
        },
      },
    });

    const parsed = questions.map((q) => ({
      ...q,
      optionsEn: JSON.parse(q.optionsEn || '[]'),
      optionsAm: JSON.parse(q.optionsAm || '[]'),
    }));

    return res.json({ questions: parsed });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function createQuestion(req: AuthRequest, res: Response) {
  try {
    const data = questionSchema.parse(req.body);
    const question = await prisma.quizQuestion.create({
      data: {
        moduleId: data.moduleId,
        type: data.type || 'MULTIPLE_CHOICE',
        questionEn: data.questionEn,
        questionAm: data.questionAm,
        optionsEn: JSON.stringify(data.optionsEn),
        optionsAm: JSON.stringify(data.optionsAm),
        correctIndex: data.correctIndex,
        explanationEn: data.explanationEn,
        explanationAm: data.explanationAm,
      },
    });

    await prisma.auditLog.create({
      data: {
        action: 'QUESTION_CREATED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Created quiz question for module ${data.moduleId}`,
      },
    });

    return res.status(201).json({
      question: {
        ...question,
        optionsEn: data.optionsEn,
        optionsAm: data.optionsAm,
      },
    });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: err.errors });
    }
    return res.status(500).json({ error: err.message });
  }
}

export async function updateQuestion(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const data = updateQuestionSchema.parse(req.body);

    const updateData: any = { ...data };
    if (data.optionsEn !== undefined) {
      updateData.optionsEn = JSON.stringify(data.optionsEn);
    }
    if (data.optionsAm !== undefined) {
      updateData.optionsAm = JSON.stringify(data.optionsAm);
    }

    const question = await prisma.quizQuestion.update({
      where: { id },
      data: updateData,
    });

    await prisma.auditLog.create({
      data: {
        action: 'QUESTION_UPDATED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Updated quiz question: ${question.id}`,
      },
    });

    return res.json({
      question: {
        ...question,
        optionsEn: JSON.parse(question.optionsEn || '[]'),
        optionsAm: JSON.parse(question.optionsAm || '[]'),
      },
    });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: err.errors });
    }
    return res.status(500).json({ error: err.message });
  }
}

export async function deleteQuestion(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    await prisma.quizQuestion.delete({ where: { id } });

    await prisma.auditLog.create({
      data: {
        action: 'QUESTION_DELETED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Deleted quiz question: ${id}`,
      },
    });

    return res.json({ success: true, message: 'Question deleted successfully.' });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}
