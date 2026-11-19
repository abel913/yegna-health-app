import {
  AdminUser,
  DashboardMetrics,
  Facility,
  Mentor,
  Module,
  QuizQuestion,
  LearningAssessment,
  StudentClub,
  ManagedUser,
  AuditLog,
  SystemTelemetry,
  BaselineSurveyStats,
  SurveyQuestion,
  GovernmentReport,
} from '../types/index.js';

const API_BASE = '/api';

function getAuthHeaders(): HeadersInit {
  const token = localStorage.getItem('yegna_admin_token');
  return {
    'Content-Type': 'application/json',
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
  };
}

/**
 * Authenticated fetch wrapper that attaches auth headers and detects 401 Session Expiration.
 */
async function authFetch(input: RequestInfo | URL, init: RequestInit = {}): Promise<Response> {
  const headers: HeadersInit = {
    ...getAuthHeaders(),
    ...(init.headers || {}),
  };

  const res = await fetch(input, { ...init, headers });

  if (res.status === 401 && typeof window !== 'undefined') {
    if (localStorage.getItem('yegna_admin_token')) {
      localStorage.removeItem('yegna_admin_token');
      localStorage.removeItem('yegna_admin_user');
      window.dispatchEvent(new CustomEvent('yegna:session-expired'));
    }
  }

  return res;
}

export const api = {
  // Auth
  async login(email: string, password: string): Promise<{ token: string; user: AdminUser }> {
    const res = await fetch(`${API_BASE}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.error || 'Failed to sign in');
    }
    const data = await res.json();
    localStorage.setItem('yegna_admin_token', data.token);
    localStorage.setItem('yegna_admin_user', JSON.stringify(data.user));
    return data;
  },

  logout() {
    localStorage.removeItem('yegna_admin_token');
    localStorage.removeItem('yegna_admin_user');
  },

  getCurrentUser(): AdminUser | null {
    const u = localStorage.getItem('yegna_admin_user');
    return u ? JSON.parse(u) : null;
  },

  async getGovernmentReport(): Promise<GovernmentReport> {
    const res = await authFetch(`${API_BASE}/government/reports`);
    const data = await res.json().catch(() => ({}));
    if (!res.ok) throw new Error(data.message || data.error || 'Failed to load government reports');
    return data.report;
  },

  async updatePassword(newPassword: string): Promise<{ token: string; user: AdminUser }> {
    const res = await authFetch(`${API_BASE}/auth/password`, {
      method: 'PUT',
      body: JSON.stringify({ newPassword }),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) throw new Error(data.message || data.error || 'Failed to update password');
    localStorage.setItem('yegna_admin_token', data.token);
    localStorage.setItem('yegna_admin_user', JSON.stringify(data.user));
    return data;
  },

  // Dashboard & Metrics
  async getDashboard(): Promise<{ metrics: DashboardMetrics; recentActivity: AuditLog[] }> {
    const res = await authFetch(`${API_BASE}/admin/dashboard`);
    if (!res.ok) throw new Error('Failed to load dashboard metrics');
    return res.json();
  },

  async getSurveyStats(): Promise<BaselineSurveyStats> {
    const res = await authFetch(`${API_BASE}/admin/survey/stats`);
    if (!res.ok) throw new Error('Failed to load baseline survey stats');
    return res.json();
  },

  async deleteSurveyResponse(id: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/survey/responses/${id}`, {
      method: 'DELETE',
    });
    if (!res.ok) throw new Error('Failed to delete survey response');
  },

  async clearSurveyResponses(): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/survey/responses`, {
      method: 'DELETE',
    });
    if (!res.ok) throw new Error('Failed to clear survey responses');
  },

  async getSurveyQuestions(params?: { section?: number | string; moduleKey?: string }): Promise<{ questions: SurveyQuestion[] }> {
    const query = new URLSearchParams();
    if (params?.section !== undefined && params.section !== 'ALL') {
      query.append('section', params.section.toString());
    }
    if (params?.moduleKey && params.moduleKey !== 'ALL') {
      query.append('moduleKey', params.moduleKey);
    }
    const qStr = query.toString();
    const url = qStr ? `${API_BASE}/admin/survey/questions?${qStr}` : `${API_BASE}/admin/survey/questions`;
    const res = await authFetch(url);
    if (!res.ok) throw new Error('Failed to load survey questions');
    return res.json();
  },

  async createSurveyQuestion(data: Partial<SurveyQuestion>): Promise<{ success: boolean; question: SurveyQuestion }> {
    const res = await authFetch(`${API_BASE}/admin/survey/questions`, {
      method: 'POST',
      body: JSON.stringify(data),
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.message || err.error || 'Failed to create question');
    }
    return res.json();
  },

  async updateSurveyQuestion(id: string, data: Partial<SurveyQuestion>): Promise<{ success: boolean; question: SurveyQuestion }> {
    const res = await authFetch(`${API_BASE}/admin/survey/questions/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.message || err.error || 'Failed to update question');
    }
    return res.json();
  },

  async deleteSurveyQuestion(id: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/survey/questions/${id}`, {
      method: 'DELETE',
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.message || err.error || 'Failed to delete question');
    }
  },

  async getAuditLogs(): Promise<{ logs: AuditLog[] }> {
    const res = await authFetch(`${API_BASE}/admin/audit-logs`);
    if (!res.ok) throw new Error('Failed to load audit logs');
    return res.json();
  },

  // Facilities
  async getFacilities(subCity?: string): Promise<{ facilities: Facility[] }> {
    const url = subCity ? `${API_BASE}/facilities?subCity=${encodeURIComponent(subCity)}` : `${API_BASE}/facilities`;
    const res = await authFetch(url);
    if (!res.ok) throw new Error('Failed to load facilities');
    return res.json();
  },

  async createFacility(data: Partial<Facility>): Promise<{ facility: Facility }> {
    const res = await authFetch(`${API_BASE}/admin/facilities`, {
      method: 'POST',
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to create facility');
    return res.json();
  },

  async updateFacility(id: string, data: Partial<Facility>): Promise<{ facility: Facility }> {
    const res = await authFetch(`${API_BASE}/admin/facilities/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to update facility');
    return res.json();
  },

  async deleteFacility(id: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/facilities/${id}`, {
      method: 'DELETE',
    });
    if (!res.ok) throw new Error('Failed to delete facility');
  },

  // Mentors
  async getMentors(): Promise<{ mentors: Mentor[] }> {
    const res = await authFetch(`${API_BASE}/mentors`);
    if (!res.ok) throw new Error('Failed to load mentors');
    return res.json();
  },

  async createMentor(data: Partial<Mentor>): Promise<{ mentor: Mentor }> {
    const res = await authFetch(`${API_BASE}/admin/mentors`, {
      method: 'POST',
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to create mentor');
    return res.json();
  },

  async updateMentor(id: string, data: Partial<Mentor>): Promise<{ mentor: Mentor }> {
    const res = await authFetch(`${API_BASE}/admin/mentors/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to update mentor');
    return res.json();
  },

  async deleteMentor(id: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/mentors/${id}`, {
      method: 'DELETE',
    });
    if (!res.ok) throw new Error('Failed to delete mentor');
  },

  // Modules & Articles CMS
  async getModules(category?: string): Promise<{ modules: Module[] }> {
    const url = category ? `${API_BASE}/modules?category=${encodeURIComponent(category)}` : `${API_BASE}/modules`;
    const res = await authFetch(url);
    if (!res.ok) throw new Error('Failed to load modules');
    return res.json();
  },

  async createModule(data: Partial<Module>): Promise<{ module: Module }> {
    const res = await authFetch(`${API_BASE}/admin/modules`, {
      method: 'POST',
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to create module');
    return res.json();
  },

  async updateModule(id: string, data: Partial<Module>): Promise<{ module: Module }> {
    const res = await authFetch(`${API_BASE}/admin/modules/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to update module');
    return res.json();
  },

  async deleteModule(id: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/modules/${id}`, {
      method: 'DELETE',
    });
    if (!res.ok) throw new Error('Failed to delete module');
  },

  // Quizzes
  async getQuestions(moduleId?: string): Promise<{ questions: QuizQuestion[] }> {
    const url = moduleId ? `${API_BASE}/quizzes?moduleId=${encodeURIComponent(moduleId)}` : `${API_BASE}/quizzes`;
    const res = await authFetch(url);
    if (!res.ok) throw new Error('Failed to load quiz questions');
    return res.json();
  },

  async createQuestion(data: Partial<QuizQuestion>): Promise<{ question: QuizQuestion }> {
    const res = await authFetch(`${API_BASE}/admin/quizzes`, {
      method: 'POST',
      body: JSON.stringify(data),
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.message || err.error || 'Failed to create question');
    }
    return res.json();
  },

  async updateQuestion(id: string, data: Partial<QuizQuestion>): Promise<{ question: QuizQuestion }> {
    const res = await authFetch(`${API_BASE}/admin/quizzes/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.message || err.error || 'Failed to update question');
    }
    return res.json();
  },

  async deleteQuestion(id: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/quizzes/${id}`, {
      method: 'DELETE',
    });
    if (!res.ok) throw new Error('Failed to delete question');
  },

  async getLearningAssessments(): Promise<{ assessments: LearningAssessment[] }> {
    const res = await authFetch(`${API_BASE}/learning-assessments`);
    if (!res.ok) throw new Error('Failed to load learning assessments');
    return res.json();
  },
  async saveLearningAssessment(data: { moduleId: string; questions: { promptEn: string; promptAm: string; choices: { labelEn: string; labelAm: string; score: number }[] }[] }): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/learning-assessments`, { method: 'POST', body: JSON.stringify(data) });
    if (!res.ok) { const body = await res.json().catch(() => ({})); throw new Error(body.error || 'Failed to save learning assessment'); }
  },
  async deleteLearningAssessment(id: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/learning-assessments/${id}`, { method: 'DELETE' });
    if (!res.ok) throw new Error('Failed to delete learning assessment');
  },

  // Clubs
  async getClubs(): Promise<{ clubs: StudentClub[] }> {
    const res = await authFetch(`${API_BASE}/clubs`);
    if (!res.ok) throw new Error('Failed to load clubs');
    return res.json();
  },

  async createClub(data: Partial<StudentClub>): Promise<{ club: StudentClub }> {
    const res = await authFetch(`${API_BASE}/admin/clubs`, {
      method: 'POST',
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to create club');
    return res.json();
  },

  async updateClub(id: string, data: Partial<StudentClub>): Promise<{ club: StudentClub }> {
    const res = await authFetch(`${API_BASE}/admin/clubs/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to update club');
    return res.json();
  },

  async deleteClub(id: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/clubs/${id}`, {
      method: 'DELETE',
    });
    if (!res.ok) throw new Error('Failed to delete club');
  },

  async getClubRoster(id: string): Promise<{ clubName: string; memberCount: number; roster: any[] }> {
    const res = await authFetch(`${API_BASE}/admin/clubs/${id}/roster`);
    if (!res.ok) throw new Error('Failed to load club roster');
    return res.json();
  },

  async removeClubMember(clubId: string, userId: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/clubs/${clubId}/members/${userId}`, {
      method: 'DELETE',
    });
    if (!res.ok) throw new Error('Failed to remove club member');
  },

  // Users
  async getUsers(): Promise<{ users: ManagedUser[] }> {
    const res = await authFetch(`${API_BASE}/admin/users`);
    if (!res.ok) throw new Error('Failed to load users');
    return res.json();
  },

  async createUser(data: {
    email: string;
    displayName: string;
    password?: string;
    role?: string;
    isEmailVerified?: boolean;
  }): Promise<{ user: ManagedUser }> {
    const res = await authFetch(`${API_BASE}/admin/users`, {
      method: 'POST',
      body: JSON.stringify(data),
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.message || err.error || 'Failed to create user');
    }
    return res.json();
  },

  async updateUserRole(id: string, role: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/users/${id}/role`, {
      method: 'PUT',
      body: JSON.stringify({ role }),
    });
    if (!res.ok) throw new Error('Failed to update user role');
  },

  async toggleUserSuspension(id: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/users/${id}/suspend`, {
      method: 'PUT',
    });
    if (!res.ok) throw new Error('Failed to toggle suspension');
  },

  async verifyUserEmail(id: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/users/${id}/verify-email`, {
      method: 'PUT',
    });
    if (!res.ok) throw new Error('Failed to verify user email');
  },

  async resetUserPassword(id: string, newPassword: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/users/${id}/reset-password`, {
      method: 'POST',
      body: JSON.stringify({ newPassword }),
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.message || err.error || 'Failed to reset user password');
    }
  },

  async deleteUser(id: string): Promise<void> {
    const res = await authFetch(`${API_BASE}/admin/users/${id}`, {
      method: 'DELETE',
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.error || 'Failed to delete user');
    }
  },

  // Live System Telemetry & Health
  async getHealth(): Promise<SystemTelemetry> {
    const start = performance.now();
    const res = await fetch(`${API_BASE}/health`, { cache: 'no-store' });
    if (!res.ok) throw new Error(`API returned HTTP ${res.status}`);
    const data = await res.json();
    const clientRoundtripMs = Math.round(performance.now() - start);
    return {
      status: data.status === 'ok' ? 'ok' : 'degraded',
      service: data.service || 'Yegna Health API',
      version: data.version || '1.0.0',
      environment: data.environment || 'development',
      uptimeSeconds: data.uptimeSeconds || 0,
      database: {
        type: data.database?.type || 'Supabase PostgreSQL (Prisma ORM)',
        status: data.database?.status || 'connected',
        latencyMs: data.database?.latencyMs ?? 5,
      },
      privacyVault: data.privacyVault || 'Zero-Knowledge Active',
      timestamp: data.timestamp || new Date().toISOString(),
      clientRoundtripMs,
    };
  },
};
