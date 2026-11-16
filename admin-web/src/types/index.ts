export interface AdminUser {
  id: string;
  email: string;
  displayName: string;
  role: string;
}

export interface Facility {
  id: string;
  nameEn: string;
  nameAm: string;
  subCity: string;
  woreda?: string;
  addressEn: string;
  addressAm: string;
  phone: string;
  latitude: number;
  longitude: number;
  operatingHours: string;
  isVerified: boolean;
  services: string[];
  createdAt: string;
}

export interface Mentor {
  id: string;
  name: string;
  organization: string;
  campus?: string;
  roleTitleEn?: string;
  roleTitleAm?: string;
  phone: string;
  whatsapp?: string;
  telegramHandle?: string;
  email?: string;
  experienceYears?: number;
  sessionsCount?: number;
  workingHoursEn?: string;
  workingHoursAm?: string;
  bioEn?: string;
  bioAm?: string;
  languages: string[];
  specialties: string[];
  isAvailable: boolean;
  isVerified: boolean;
  createdAt: string;
}

export interface Module {
  id: string;
  category: string;
  titleEn: string;
  titleAm: string;
  summaryEn: string;
  summaryAm: string;
  contentEn: string;
  contentAm: string;
  imageUrl?: string;
  doctorNoteEn?: string;
  doctorNoteAm?: string;
  readTimeMin: number;
  isPublished: boolean;
  authorName?: string;
  orderIndex: number;
  createdAt: string;
  _count?: {
    quizzes: number;
  };
}

export interface QuizQuestion {
  id: string;
  moduleId: string;
  type?: 'MULTIPLE_CHOICE' | 'TRUE_FALSE';
  questionEn: string;
  questionAm: string;
  optionsEn: string[];
  optionsAm: string[];
  correctIndex: number;
  explanationEn: string;
  explanationAm: string;
  module?: {
    titleEn: string;
    titleAm: string;
    category: string;
  };
}

export interface LearningAssessment {
  id: string;
  moduleId: string;
  module: { titleEn: string; titleAm: string; category: string };
  questions: { id: string; position: number; promptEn: string; promptAm: string; choices: { id: string; position: number; labelEn: string; labelAm: string; score: number }[] }[];
}

export interface StudentClub {
  id: string;
  name: string;
  description: string;
  category: string;
  venue?: string;
  meetingTime?: string;
  isApproved: boolean;
  memberCount?: number;
  createdAt: string;
}

export interface ManagedUser {
  id: string;
  email: string;
  displayName: string;
  role: string;
  isSuspended: boolean;
  isEmailVerified?: boolean;
  createdAt: string;
  joinedClubCount: number;
}

export interface AuditLog {
  id: string;
  action: string;
  adminEmail: string;
  details: string;
  timestamp: string;
}

export interface DashboardTimelinePoint {
  labelEn: string;
  labelAm: string;
  signups: number;
  actions: number;
  date: string;
}

export interface DashboardMetrics {
  activeArticles: number;
  learningModules: number;
  quizQuestions: number;
  verifiedFacilities: number;
  counselorMentors: number;
  studentClubs: number;
  registeredUsers: number;
  usersByRole?: {
    students: number;
    mentors: number;
    admins: number;
    authors: number;
  };
  facilitiesByRegion?: {
    addis: number;
    gondar: number;
    other: number;
  };
  timeline?: {
    '7D': DashboardTimelinePoint[];
    '30D': DashboardTimelinePoint[];
    '12M': DashboardTimelinePoint[];
  };
}

export interface SystemTelemetry {
  status: 'ok' | 'degraded' | 'offline';
  service: string;
  version: string;
  environment: string;
  uptimeSeconds: number;
  database: {
    type: string;
    status: string;
    latencyMs: number;
  };
  privacyVault: string;
  timestamp: string;
  clientRoundtripMs: number;
}

export interface SurveyQuestionOption {
  id?: string;
  position?: number;
  value: string;
  labelEn: string;
  labelAm: string;
}

export interface SurveyQuestion {
  id: string;
  position: number;
  sectionNumber?: number;
  sectionKey?: string;
  sectionTitleEn?: string;
  sectionTitleAm?: string;
  moduleKey?: string | null;
  key: string;
  titleEn: string;
  titleAm: string;
  descriptionEn?: string | null;
  descriptionAm?: string | null;
  type: 'SINGLE_CHOICE' | 'MULTI_CHOICE';
  isRequired: boolean;
  isActive: boolean;
  options: SurveyQuestionOption[];
  createdAt?: string;
  updatedAt?: string;
}

export interface DynamicSurveyStatOption {
  id?: string;
  value: string;
  labelEn: string;
  labelAm: string;
  count: number;
  percentage: number;
}

export interface DynamicSurveyStatQuestion {
  id: string;
  key: string;
  titleEn: string;
  titleAm: string;
  type: string;
  options: DynamicSurveyStatOption[];
}

export interface BaselineSurveySubmission {
  id: string;
  ageGroup: string;
  yearOfStudy: string;
  disabilityNeed: string;
  knowsGondarSrh: string;
  answers?: Record<string, any>;
  submittedAt: string;
}

export interface BaselineSurveyStats {
  totalResponses: number;
  questions?: DynamicSurveyStatQuestion[];
  breakdown: {
    byAge: Array<{ ageGroup: string; count: number; percentage: number }>;
    byYearOfStudy: Array<{ yearOfStudy: string; count: number; percentage: number }>;
    byDisabilityNeed: Array<{ disabilityNeed: string; count: number; percentage: number }>;
    byGondarSrhAwareness: Array<{ knowsGondarSrh: string; count: number; percentage: number }>;
  };
  recentSubmissions?: BaselineSurveySubmission[];
}
