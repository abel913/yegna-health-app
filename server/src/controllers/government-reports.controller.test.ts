import assert from 'node:assert/strict';
import test from 'node:test';
import { buildRegistrationTrend, loadGovernmentReportSnapshot } from './government-reports.controller.js';
import { prisma } from '../config/index.js';

test('government registration trend exposes monthly counts without user attributes', () => {
  const now = new Date('2026-11-18T12:00:00.000Z');
  const trend = buildRegistrationTrend([
    { month: '2026-11', students: 1, mentors: 1 },
    { month: '2025-01', students: 1, mentors: 0 },
  ], now);

  assert.equal(trend.length, 12);
  assert.deepEqual(trend.at(-1), { month: '2026-11', students: 1, mentors: 1 });
  assert.deepEqual(Object.keys(trend[0]!), ['month', 'students', 'mentors']);
  assert.equal(trend[0]?.month, '2025-12');
});

test('government report snapshot contains only approved aggregate metrics', async () => {
  const source = {
    $queryRaw: async () => [{
      registeredStudents: 41,
      registeredMentors: 8,
      mentorProfiles: 6,
      facilities: 7,
      verifiedFacilities: 5,
      clubs: 4,
      approvedClubs: 3,
      learningModules: 8,
      publishedModules: 5,
      quizQuestions: 14,
      moduleAssessments: 8,
      assessmentQuestions: 23,
      registrationTrend: [{ month: '2026-11', students: 1, mentors: 0 }],
    }],
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
