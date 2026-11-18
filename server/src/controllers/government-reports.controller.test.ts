import assert from 'node:assert/strict';
import test from 'node:test';
import { buildRegistrationTrend, loadGovernmentReportSnapshot } from './government-reports.controller.js';
import { prisma } from '../config/index.js';

test('government registration trend exposes monthly counts without user attributes', () => {
  const now = new Date('2026-11-18T12:00:00.000Z');
  const trend = buildRegistrationTrend([
    { role: 'STUDENT', createdAt: new Date('2026-11-04T10:00:00.000Z') },
    { role: 'MENTOR', createdAt: new Date('2026-11-08T10:00:00.000Z') },
    { role: 'ADMIN', createdAt: new Date('2026-11-10T10:00:00.000Z') },
    { role: 'STUDENT', createdAt: new Date('2025-01-10T10:00:00.000Z') },
  ], now);

  assert.equal(trend.length, 12);
  assert.deepEqual(trend.at(-1), { month: '2026-11', students: 1, mentors: 1 });
  assert.deepEqual(Object.keys(trend[0]!), ['month', 'students', 'mentors']);
  assert.equal(trend[0]?.month, '2025-12');
});

test('government report snapshot contains only approved aggregate metrics', async () => {
  const source = {
    user: {
      count: async ({ where }: { where?: { role?: string } }) => where?.role === 'STUDENT' ? 41 : 8,
      findMany: async () => [{ role: 'STUDENT', createdAt: new Date('2026-11-07T12:00:00.000Z') }],
    },
    mentor: { count: async (_args?: object) => 6 },
    facility: { count: async (args?: { where?: { isVerified?: boolean } }) => args?.where?.isVerified ? 5 : 7 },
    studentClub: { count: async (args?: { where?: { isApproved?: boolean } }) => args?.where?.isApproved ? 3 : 4 },
    module: { count: async (args?: { where?: { isPublished?: boolean } }) => args?.where?.isPublished ? 5 : 8 },
    quizQuestion: { count: async (_args?: object) => 14 },
    learningAssessment: { count: async (_args?: object) => 8 },
    learningAssessmentQuestion: { count: async (_args?: object) => 23 },
  } as unknown as typeof prisma;

  const report = await loadGovernmentReportSnapshot(source, new Date('2026-11-18T12:00:00.000Z'));
  assert.equal(report.registeredStudents, 41);
  assert.equal(report.registeredMentors, 8);
  assert.equal(report.mentorProfiles, 6);
  assert.equal(report.facilities, 7);
  assert.equal(report.approvedClubs, 3);
  assert.equal(report.publishedModules, 5);
  assert.equal(report.assessmentQuestions, 23);
  assert.ok(!('users' in report));
  assert.ok(!('auditLogs' in report));
  assert.equal(report.registrationTrend.at(-1)?.students, 1);
});
