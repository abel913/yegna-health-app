import {
  AdminUser,
  DashboardMetrics,
  Facility,
  Mentor,
  Module,
  QuizQuestion,
  StudentClub,
  ManagedUser,
  AuditLog,
  SystemTelemetry,
} from '../types/index.js';

const API_BASE = '/api';

function getAuthHeaders(): HeadersInit {
  const token = localStorage.getItem('yegna_admin_token');
  return {
    'Content-Type': 'application/json',
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
  };
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

  // Dashboard & Metrics
  async getDashboard(): Promise<{ metrics: DashboardMetrics; recentActivity: AuditLog[] }> {
    const res = await fetch(`${API_BASE}/admin/dashboard`, { headers: getAuthHeaders() });
    if (!res.ok) throw new Error('Failed to load dashboard metrics');
    return res.json();
  },

  async getSurveyStats(): Promise<{
    totalResponses: number;
    breakdown: {
      byAge: Array<{ ageGroup: string; count: number; percentage: number }>;
      byYearOfStudy: Array<{ yearOfStudy: string; count: number; percentage: number }>;
      byDisabilityNeed: Array<{ disabilityNeed: string; count: number; percentage: number }>;
      byGondarSrhAwareness: Array<{ knowsGondarSrh: string; count: number; percentage: number }>;
    };
  }> {
    const res = await fetch(`${API_BASE}/admin/survey/stats`, { headers: getAuthHeaders() });
    if (!res.ok) throw new Error('Failed to load baseline survey stats');
    return res.json();
  },

  async getAuditLogs(): Promise<{ logs: AuditLog[] }> {
    const res = await fetch(`${API_BASE}/admin/audit-logs`, { headers: getAuthHeaders() });
    if (!res.ok) throw new Error('Failed to load audit logs');
    return res.json();
  },

  // Facilities
  async getFacilities(subCity?: string): Promise<{ facilities: Facility[] }> {
    const url = subCity ? `${API_BASE}/facilities?subCity=${encodeURIComponent(subCity)}` : `${API_BASE}/facilities`;
    const res = await fetch(url, { headers: getAuthHeaders() });
    if (!res.ok) throw new Error('Failed to load facilities');
    return res.json();
  },

  async createFacility(data: Partial<Facility>): Promise<{ facility: Facility }> {
    const res = await fetch(`${API_BASE}/admin/facilities`, {
      method: 'POST',
      headers: getAuthHeaders(),
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to create facility');
    return res.json();
  },

  async updateFacility(id: string, data: Partial<Facility>): Promise<{ facility: Facility }> {
    const res = await fetch(`${API_BASE}/admin/facilities/${id}`, {
      method: 'PUT',
      headers: getAuthHeaders(),
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to update facility');
    return res.json();
  },

  async deleteFacility(id: string): Promise<void> {
    const res = await fetch(`${API_BASE}/admin/facilities/${id}`, {
      method: 'DELETE',
      headers: getAuthHeaders(),
    });
    if (!res.ok) throw new Error('Failed to delete facility');
  },

  // Mentors
  async getMentors(): Promise<{ mentors: Mentor[] }> {
    const res = await fetch(`${API_BASE}/mentors`, { headers: getAuthHeaders() });
    if (!res.ok) throw new Error('Failed to load mentors');
    return res.json();
  },

  async createMentor(data: Partial<Mentor>): Promise<{ mentor: Mentor }> {
    const res = await fetch(`${API_BASE}/admin/mentors`, {
      method: 'POST',
      headers: getAuthHeaders(),
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to create mentor');
    return res.json();
  },

  async updateMentor(id: string, data: Partial<Mentor>): Promise<{ mentor: Mentor }> {
    const res = await fetch(`${API_BASE}/admin/mentors/${id}`, {
      method: 'PUT',
      headers: getAuthHeaders(),
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to update mentor');
    return res.json();
  },

  async deleteMentor(id: string): Promise<void> {
    const res = await fetch(`${API_BASE}/admin/mentors/${id}`, {
      method: 'DELETE',
      headers: getAuthHeaders(),
    });
    if (!res.ok) throw new Error('Failed to delete mentor');
  },

  // Modules & Articles CMS
  async getModules(category?: string): Promise<{ modules: Module[] }> {
    const url = category ? `${API_BASE}/modules?category=${encodeURIComponent(category)}` : `${API_BASE}/modules`;
    const res = await fetch(url, { headers: getAuthHeaders() });
    if (!res.ok) throw new Error('Failed to load modules');
    return res.json();
  },

  async createModule(data: Partial<Module>): Promise<{ module: Module }> {
    const res = await fetch(`${API_BASE}/admin/modules`, {
      method: 'POST',
      headers: getAuthHeaders(),
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to create module');
    return res.json();
  },

  async updateModule(id: string, data: Partial<Module>): Promise<{ module: Module }> {
    const res = await fetch(`${API_BASE}/admin/modules/${id}`, {
      method: 'PUT',
      headers: getAuthHeaders(),
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to update module');
    return res.json();
  },

  async deleteModule(id: string): Promise<void> {
    const res = await fetch(`${API_BASE}/admin/modules/${id}`, {
      method: 'DELETE',
      headers: getAuthHeaders(),
    });
    if (!res.ok) throw new Error('Failed to delete module');
  },

  // Quizzes
  async getQuestions(moduleId?: string): Promise<{ questions: QuizQuestion[] }> {
    const url = moduleId ? `${API_BASE}/quizzes?moduleId=${encodeURIComponent(moduleId)}` : `${API_BASE}/quizzes`;
    const res = await fetch(url, { headers: getAuthHeaders() });
    if (!res.ok) throw new Error('Failed to load quiz questions');
    return res.json();
  },

  async createQuestion(data: Partial<QuizQuestion>): Promise<{ question: QuizQuestion }> {
    const res = await fetch(`${API_BASE}/admin/quizzes`, {
      method: 'POST',
      headers: getAuthHeaders(),
      body: JSON.stringify(data),
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.message || err.error || 'Failed to create question');
    }
    return res.json();
  },

  async updateQuestion(id: string, data: Partial<QuizQuestion>): Promise<{ question: QuizQuestion }> {
    const res = await fetch(`${API_BASE}/admin/quizzes/${id}`, {
      method: 'PUT',
      headers: getAuthHeaders(),
      body: JSON.stringify(data),
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.message || err.error || 'Failed to update question');
    }
    return res.json();
  },

  async deleteQuestion(id: string): Promise<void> {
    const res = await fetch(`${API_BASE}/admin/quizzes/${id}`, {
      method: 'DELETE',
      headers: getAuthHeaders(),
    });
    if (!res.ok) throw new Error('Failed to delete question');
  },

  // Clubs
  async getClubs(): Promise<{ clubs: StudentClub[] }> {
    const res = await fetch(`${API_BASE}/clubs`, { headers: getAuthHeaders() });
    if (!res.ok) throw new Error('Failed to load clubs');
    return res.json();
  },

  async createClub(data: Partial<StudentClub>): Promise<{ club: StudentClub }> {
    const res = await fetch(`${API_BASE}/admin/clubs`, {
      method: 'POST',
      headers: getAuthHeaders(),
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to create club');
    return res.json();
  },

  async updateClub(id: string, data: Partial<StudentClub>): Promise<{ club: StudentClub }> {
    const res = await fetch(`${API_BASE}/admin/clubs/${id}`, {
      method: 'PUT',
      headers: getAuthHeaders(),
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Failed to update club');
    return res.json();
  },

  async deleteClub(id: string): Promise<void> {
    const res = await fetch(`${API_BASE}/admin/clubs/${id}`, {
      method: 'DELETE',
      headers: getAuthHeaders(),
    });
    if (!res.ok) throw new Error('Failed to delete club');
  },

  async getClubRoster(id: string): Promise<{ clubName: string; roster: any[] }> {
    const res = await fetch(`${API_BASE}/admin/clubs/${id}/roster`, { headers: getAuthHeaders() });
    if (!res.ok) throw new Error('Failed to load club roster');
    return res.json();
  },

  // Users
  async getUsers(): Promise<{ users: ManagedUser[] }> {
    const res = await fetch(`${API_BASE}/admin/users`, { headers: getAuthHeaders() });
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
    const res = await fetch(`${API_BASE}/admin/users`, {
      method: 'POST',
      headers: getAuthHeaders(),
      body: JSON.stringify(data),
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.message || err.error || 'Failed to create user');
    }
    return res.json();
  },

  async updateUserRole(id: string, role: string): Promise<void> {
    const res = await fetch(`${API_BASE}/admin/users/${id}/role`, {
      method: 'PUT',
      headers: getAuthHeaders(),
      body: JSON.stringify({ role }),
    });
    if (!res.ok) throw new Error('Failed to update user role');
  },

  async toggleUserSuspension(id: string): Promise<void> {
    const res = await fetch(`${API_BASE}/admin/users/${id}/suspend`, {
      method: 'PUT',
      headers: getAuthHeaders(),
    });
    if (!res.ok) throw new Error('Failed to toggle suspension');
  },

  async verifyUserEmail(id: string): Promise<void> {
    const res = await fetch(`${API_BASE}/admin/users/${id}/verify-email`, {
      method: 'PUT',
      headers: getAuthHeaders(),
    });
    if (!res.ok) throw new Error('Failed to verify user email');
  },

  async resetUserPassword(id: string, newPassword: string): Promise<void> {
    const res = await fetch(`${API_BASE}/admin/users/${id}/reset-password`, {
      method: 'POST',
      headers: getAuthHeaders(),
      body: JSON.stringify({ newPassword }),
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.error || 'Failed to reset user password');
    }
  },

  async deleteUser(id: string): Promise<void> {
    const res = await fetch(`${API_BASE}/admin/users/${id}`, {
      method: 'DELETE',
      headers: getAuthHeaders(),
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
        type: data.database?.type || 'SQLite (Prisma ORM)',
        status: data.database?.status || 'connected',
        latencyMs: data.database?.latencyMs ?? 5,
      },
      privacyVault: data.privacyVault || 'Zero-Knowledge Active',
      timestamp: data.timestamp || new Date().toISOString(),
      clientRoundtripMs,
    };
  },
};
