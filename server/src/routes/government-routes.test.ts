import assert from 'node:assert/strict';
import { createServer, Server } from 'node:http';
import express from 'express';
import bcrypt from 'bcryptjs';
import { randomUUID } from 'node:crypto';
import jwt from 'jsonwebtoken';
import test from 'node:test';
import { runWithRequestRuntime } from '../config/index.js';
import { router } from './index.js';

const testSecret = 'government-viewer-route-test-secret-000000000';

function token(role: string, mustChangePassword = false): string {
  const id = role === 'ADMIN' ? 'admin-id' : 'viewer-id';
  return jwt.sign({ id, email: 'viewer@example.org', role, displayName: 'Viewer', mustChangePassword }, testSecret);
}

function createFakePrisma(accounts: Map<string, Record<string, unknown>>) {
  return {
    user: {
      findUnique: async ({ where }: { where: { id?: string; email?: string } }) => {
        return [...accounts.values()].find((account) =>
          (where.id !== undefined && account.id === where.id) ||
          (where.email !== undefined && account.email === where.email)
        ) ?? null;
      },
      update: async ({ where, data }: { where: { id: string }; data: Record<string, unknown> }) => {
        const account = accounts.get(where.id);
        if (!account) throw new Error('missing account');
        Object.assign(account, data);
        return account;
      },
      count: async ({ where }: { where?: { role?: string } }) => where?.role === 'STUDENT' ? 9 : 2,
      findMany: async () => [{ role: 'STUDENT', createdAt: new Date('2026-11-07T12:00:00.000Z') }],
    },
    mentor: { count: async (_args?: object) => 3 },
    facility: { count: async (args?: { where?: { isVerified?: boolean } }) => args?.where?.isVerified ? 4 : 5 },
    studentClub: { count: async (args?: { where?: { isApproved?: boolean } }) => args?.where?.isApproved ? 6 : 7 },
    module: { count: async (args?: { where?: { isPublished?: boolean } }) => args?.where?.isPublished ? 8 : 10 },
    quizQuestion: { count: async (_args?: object) => 11 },
    learningAssessment: { count: async (_args?: object) => 12 },
    learningAssessmentQuestion: { count: async (_args?: object) => 13 },
  };
}

async function startTestServer(): Promise<{ server: Server; baseUrl: string; temporaryPassword: string }> {
  const app = express();
  app.use(express.json());
  const environment = { JWT_SECRET: testSecret, NODE_ENV: 'test' };
  const temporaryPassword = `Tmp-${randomUUID()}!`;
  const accounts = new Map<string, Record<string, unknown>>([
    ['admin-id', {
      id: 'admin-id', email: 'admin@example.org', role: 'ADMIN', displayName: 'Admin',
      isSuspended: false, mustChangePassword: false, isEmailVerified: true, passwordHash: await bcrypt.hash(temporaryPassword, 10),
    }],
    ['viewer-id', {
      id: 'viewer-id', email: 'viewer@example.org', role: 'GOVERNMENT_VIEWER', displayName: 'Viewer',
      isSuspended: false, mustChangePassword: false, isEmailVerified: true, passwordHash: await bcrypt.hash(temporaryPassword, 10),
    }],
  ]);
  accounts.get('viewer-id')!.mustChangePassword = true;
  app.use((req, res, next) => runWithRequestRuntime(environment, createFakePrisma(accounts) as never, () => next()));
  app.use('/api', router);

  const server = createServer(app);
  await new Promise<void>((resolve) => server.listen(0, '127.0.0.1', resolve));
  const address = server.address();
  assert.ok(address && typeof address !== 'string');
  return { server, baseUrl: `http://127.0.0.1:${address.port}/api`, temporaryPassword };
}

test('government viewer cannot reach admin management routes or bypass password change', async (context) => {
  const { server, baseUrl, temporaryPassword } = await startTestServer();
  context.after(() => new Promise<void>((resolve, reject) => server.close((error) => error ? reject(error) : resolve())));

  const loginResponse = await fetch(`${baseUrl}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: 'viewer@example.org', password: temporaryPassword }),
  });
  assert.equal(loginResponse.status, 200);
  const loggedIn = await loginResponse.json() as { token: string; user: { role: string; mustChangePassword: boolean } };
  assert.equal(loggedIn.user.role, 'GOVERNMENT_VIEWER');
  assert.equal(loggedIn.user.mustChangePassword, true);
  const headers = { Authorization: `Bearer ${loggedIn.token}` };

  const blockedReport = await fetch(`${baseUrl}/government/reports`, { headers });
  assert.equal(blockedReport.status, 403);
  assert.deepEqual(await blockedReport.json(), { error: 'PASSWORD_CHANGE_REQUIRED' });

  const weakPasswordResponse = await fetch(`${baseUrl}/auth/password`, {
    method: 'PUT',
    headers: { ...headers, 'Content-Type': 'application/json' },
    body: JSON.stringify({ newPassword: 'too-short' }),
  });
  assert.equal(weakPasswordResponse.status, 400);

  const passwordChangeResponse = await fetch(`${baseUrl}/auth/password`, {
    method: 'PUT',
    headers: { ...headers, 'Content-Type': 'application/json' },
    body: JSON.stringify({ newPassword: `New-${randomUUID()}!` }),
  });
  assert.equal(passwordChangeResponse.status, 200);
  const changedPassword = await passwordChangeResponse.json() as { token: string; user: { mustChangePassword: boolean } };
  assert.equal(changedPassword.user.mustChangePassword, false);
  const newHeaders = { Authorization: `Bearer ${changedPassword.token}` };

  const reportResponse = await fetch(`${baseUrl}/government/reports`, { headers: newHeaders });
  assert.equal(reportResponse.status, 200);
  const reportBody = await reportResponse.json() as { report: Record<string, unknown> };
  assert.equal(reportBody.report.registeredStudents, 9);
  assert.equal(reportBody.report.facilities, 5);
  assert.equal(reportBody.report.moduleAssessments, 12);
  assert.ok(Array.isArray(reportBody.report.registrationTrend));
  assert.equal('email' in reportBody.report, false);
  assert.equal('recentActivity' in reportBody.report, false);

  const oldTemporaryToken = await fetch(`${baseUrl}/government/reports`, { headers });
  assert.equal(oldTemporaryToken.status, 403, 'old temporary tokens remain restricted after password update');

  const deniedRequests: Array<[string, string]> = [
    ['GET', '/auth/me'],
    ['PUT', '/auth/profile'],
    ['POST', '/clubs/club-id/join'],
    ['GET', '/admin/users'],
    ['GET', '/admin/audit-logs'],
    ['POST', '/admin/facilities'],
    ['POST', '/admin/mentors'],
    ['POST', '/admin/clubs'],
    ['POST', '/admin/modules'],
    ['POST', '/admin/quizzes'],
    ['POST', '/admin/learning-assessments'],
  ];
  for (const [method, path] of deniedRequests) {
    const result = await fetch(`${baseUrl}${path}`, { method, headers });
    assert.equal(result.status, 403, `${method} ${path} should be forbidden`);
  }

  const staleAdminToken = jwt.sign({
    id: 'viewer-id',
    email: 'viewer@example.org',
    role: 'ADMIN',
    displayName: 'Viewer',
  }, testSecret);
  const staleRoleRequest = await fetch(`${baseUrl}/admin/users`, {
    headers: { Authorization: `Bearer ${staleAdminToken}` },
  });
  assert.equal(staleRoleRequest.status, 403, 'database role must override a stale signed role claim');

  const adminOnGovernmentPath = await fetch(`${baseUrl}/government/reports`, {
    headers: { Authorization: `Bearer ${token('ADMIN')}` },
  });
  assert.equal(adminOnGovernmentPath.status, 403);

  const tempViewerOnReportPath = await fetch(`${baseUrl}/government/reports`, {
    headers: { Authorization: `Bearer ${token('GOVERNMENT_VIEWER', true)}` },
  });
  assert.equal(tempViewerOnReportPath.status, 403);
  assert.deepEqual(await tempViewerOnReportPath.json(), { error: 'PASSWORD_CHANGE_REQUIRED' });
});
