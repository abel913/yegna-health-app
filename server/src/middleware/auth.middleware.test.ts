import assert from 'node:assert/strict';
import test from 'node:test';
import { Response, NextFunction } from 'express';
import { AuthRequest, requireAdmin, requireGovernmentViewer, requirePasswordChangeComplete } from './auth.middleware.js';

function mockResponse() {
  let statusCode = 200;
  let body: unknown;
  const response = {
    status(code: number) {
      statusCode = code;
      return this;
    },
    json(value: unknown) {
      body = value;
      return this;
    },
  } as unknown as Response;
  return { response, get statusCode() { return statusCode; }, get body() { return body; } };
}

test('government viewer authorization allows the report role only', () => {
  const nextCalled: boolean[] = [];
  const response = mockResponse();
  requireGovernmentViewer(
    { user: { id: '1', email: 'viewer@example.org', role: 'GOVERNMENT_VIEWER', displayName: 'Viewer' } } as AuthRequest,
    response.response,
    (() => nextCalled.push(true)) as NextFunction,
  );
  assert.deepEqual(nextCalled, [true]);

  const denied = mockResponse();
  requireGovernmentViewer(
    { user: { id: '2', email: 'admin@example.org', role: 'ADMIN', displayName: 'Admin' } } as AuthRequest,
    denied.response,
    (() => nextCalled.push(true)) as NextFunction,
  );
  assert.equal(denied.statusCode, 403);
});

test('government viewer role is denied administrator management authorization', () => {
  const response = mockResponse();
  const nextCalled: boolean[] = [];
  requireAdmin(
    { user: { id: '1', email: 'viewer@example.org', role: 'GOVERNMENT_VIEWER', displayName: 'Viewer' } } as AuthRequest,
    response.response,
    (() => nextCalled.push(true)) as NextFunction,
  );
  assert.equal(response.statusCode, 403);
  assert.deepEqual(nextCalled, []);
});

test('existing administrator roles retain administrator authorization', () => {
  for (const role of ['ADMIN', 'SUPER_ADMIN']) {
    const response = mockResponse();
    const nextCalled: boolean[] = [];
    requireAdmin(
      { user: { id: role, email: 'admin@example.org', role, displayName: 'Admin' } } as AuthRequest,
      response.response,
      (() => nextCalled.push(true)) as NextFunction,
    );
    assert.deepEqual(nextCalled, [true]);
    assert.equal(response.statusCode, 200);
  }
});

test('temporary government credentials cannot access protected routes before password change', () => {
  const response = mockResponse();
  const nextCalled: boolean[] = [];
  requirePasswordChangeComplete(
    { user: { id: '1', email: 'viewer@example.org', role: 'GOVERNMENT_VIEWER', displayName: 'Viewer', mustChangePassword: true } } as AuthRequest,
    response.response,
    (() => nextCalled.push(true)) as NextFunction,
  );
  assert.equal(response.statusCode, 403);
  assert.deepEqual(response.body, { error: 'PASSWORD_CHANGE_REQUIRED' });
  assert.deepEqual(nextCalled, []);
});
