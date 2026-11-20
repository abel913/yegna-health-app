import { useState, useEffect } from 'react';
import { AdminLayout } from './components/layout/AdminLayout.js';
import { CommandPalette } from './components/CommandPalette.js';
import { DashboardPage } from './pages/DashboardPage.js';
import { FacilitiesPage } from './pages/FacilitiesPage.js';
import { MentorsPage } from './pages/MentorsPage.js';
import { LearningCmsPage } from './pages/LearningCmsPage.js';
import { QuizzesPage } from './pages/QuizzesPage.js';
import { AssessmentsPage } from './pages/AssessmentsPage.js';
import { ClubsPage } from './pages/ClubsPage.js';
import { NotificationsPage } from './pages/NotificationsPage.js';
import { UsersPage } from './pages/UsersPage.js';
import { AuditLogsPage } from './pages/AuditLogsPage.js';
import { GovernmentReportsPage } from './pages/GovernmentReportsPage.js';
import { LoginPage } from './pages/LoginPage.js';
import { api } from './services/api.js';
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
  GovernmentReport,
  BroadcastNotification,
} from './types/index.js';
import { useToast } from './context/ToastContext.js';
import { exportToCsv } from './utils/csvExport.js';
import { parseCurrentRoute, formatRouteUrl, getRouteTitle } from './utils/navigation.js';

export function App() {
  const { toast } = useToast();
  const [user, setUser] = useState<AdminUser | null>(() => api.getCurrentUser());
  const initialRoute = parseCurrentRoute(typeof window !== 'undefined' ? window.location.pathname : '/');
  const [currentTab, setCurrentTab] = useState(initialRoute.tab);
  const [activeSubTab, setActiveSubTab] = useState(initialRoute.subTab || 'baseline');
  const [lang, setLang] = useState<'en' | 'am'>('en');
  const [isCommandPaletteOpen, setIsCommandPaletteOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(Boolean(user));
  const [isRefreshing, setIsRefreshing] = useState(false);

  // App Data State
  const [metrics, setMetrics] = useState<DashboardMetrics | null>(null);
  const [activity, setActivity] = useState<AuditLog[]>([]);
  const [facilities, setFacilities] = useState<Facility[]>([]);
  const [mentors, setMentors] = useState<Mentor[]>([]);
  const [modules, setModules] = useState<Module[]>([]);
  const [questions, setQuestions] = useState<QuizQuestion[]>([]);
  const [learningAssessments, setLearningAssessments] = useState<LearningAssessment[]>([]);
  const [clubs, setClubs] = useState<StudentClub[]>([]);
  const [broadcasts, setBroadcasts] = useState<BroadcastNotification[]>([]);
  const [users, setUsers] = useState<ManagedUser[]>([]);
  const [logs, setLogs] = useState<AuditLog[]>([]);
  const [governmentReport, setGovernmentReport] = useState<GovernmentReport | null>(null);
  const [governmentReportLoading, setGovernmentReportLoading] = useState(false);
  const [governmentReportError, setGovernmentReportError] = useState<string | null>(null);

  const loadGovernmentReport = async () => {
    setGovernmentReportLoading(true);
    setGovernmentReportError(null);
    try {
      setGovernmentReport(await api.getGovernmentReport());
    } catch (err) {
      setGovernmentReportError(err instanceof Error ? err.message : 'Report request failed');
    } finally {
      setGovernmentReportLoading(false);
    }
  };

  const loadAllData = async (isManualRefresh = false) => {
    if (!user) return;
    if (isManualRefresh) {
      setIsRefreshing(true);
    } else {
      setIsLoading(true);
    }
    try {
      const [dashData, facData, menData, modData, qData, clubData, userData, logData, assessmentData, broadcastData] =
        await Promise.all([
          api.getDashboard().catch(() => ({ metrics: null, recentActivity: [] })),
          api.getFacilities().catch(() => ({ facilities: [] })),
          api.getMentors().catch(() => ({ mentors: [] })),
          api.getModules().catch(() => ({ modules: [] })),
          api.getQuestions().catch(() => ({ questions: [] })),
          api.getClubs().catch(() => ({ clubs: [] })),
          api.getUsers().catch(() => ({ users: [] })),
          api.getAuditLogs().catch(() => ({ logs: [] })),
          api.getLearningAssessments().catch(() => ({ assessments: [] })),
          api.getBroadcastNotifications().catch(() => ({ broadcasts: [] })),
        ]);

      if (dashData.metrics) {
        setMetrics(dashData.metrics);
        setActivity(dashData.recentActivity);
      }
      setFacilities(facData.facilities || []);
      setMentors(menData.mentors || []);
      setModules(modData.modules || []);
      setQuestions(qData.questions || []);
      setLearningAssessments(assessmentData.assessments || []);
      setClubs(clubData.clubs || []);
      setBroadcasts(broadcastData.broadcasts || []);
      setUsers(userData.users || []);
      setLogs(logData.logs || []);

      if (isManualRefresh) {
        toast.success(
          lang === 'am' ? 'መረጃዎች በተሳካ ሁኔታ ተዘምነዋል' : 'Portal data refreshed successfully',
          'Live Sync'
        );
      }
    } catch (err) {
      console.error('Failed to load portal data:', err);
    } finally {
      setIsLoading(false);
      setIsRefreshing(false);
    }
  };

  // Targeted Refetchers for Fast Mutations
  const refreshFacilities = async () => {
    try {
      const [facData, dashData] = await Promise.all([
        api.getFacilities().catch(() => ({ facilities: [] })),
        api.getDashboard().catch(() => ({ metrics: null, recentActivity: [] })),
      ]);
      setFacilities(facData.facilities || []);
      if (dashData.metrics) {
        setMetrics(dashData.metrics);
        setActivity(dashData.recentActivity);
      }
    } catch (err) {
      console.error('Failed to refresh facilities:', err);
    }
  };

  const refreshMentors = async () => {
    try {
      const [menData, dashData] = await Promise.all([
        api.getMentors().catch(() => ({ mentors: [] })),
        api.getDashboard().catch(() => ({ metrics: null, recentActivity: [] })),
      ]);
      setMentors(menData.mentors || []);
      if (dashData.metrics) {
        setMetrics(dashData.metrics);
        setActivity(dashData.recentActivity);
      }
    } catch (err) {
      console.error('Failed to refresh mentors:', err);
    }
  };

  const refreshClubs = async () => {
    try {
      const [clubData, dashData] = await Promise.all([
        api.getClubs().catch(() => ({ clubs: [] })),
        api.getDashboard().catch(() => ({ metrics: null, recentActivity: [] })),
      ]);
      setClubs(clubData.clubs || []);
      if (dashData.metrics) {
        setMetrics(dashData.metrics);
        setActivity(dashData.recentActivity);
      }
    } catch (err) {
      console.error('Failed to refresh clubs:', err);
    }
  };

  const refreshBroadcasts = async () => {
    try {
      const [broadcastData, dashData] = await Promise.all([
        api.getBroadcastNotifications().catch(() => ({ broadcasts: [] })),
        api.getDashboard().catch(() => ({ metrics: null, recentActivity: [] })),
      ]);
      setBroadcasts(broadcastData.broadcasts || []);
      if (dashData.metrics) {
        setMetrics(dashData.metrics);
        setActivity(dashData.recentActivity);
      }
    } catch (err) {
      console.error('Failed to refresh broadcasts:', err);
    }
  };

  const refreshModulesAndQuizzes = async () => {
    try {
      const [modData, qData, assessmentData, dashData] = await Promise.all([
        api.getModules().catch(() => ({ modules: [] })),
        api.getQuestions().catch(() => ({ questions: [] })),
        api.getLearningAssessments().catch(() => ({ assessments: [] })),
        api.getDashboard().catch(() => ({ metrics: null, recentActivity: [] })),
      ]);
      setModules(modData.modules || []);
      setQuestions(qData.questions || []);
      setLearningAssessments(assessmentData.assessments || []);
      if (dashData.metrics) {
        setMetrics(dashData.metrics);
        setActivity(dashData.recentActivity);
      }
    } catch (err) {
      console.error('Failed to refresh modules & quizzes:', err);
    }
  };

  const refreshUsers = async () => {
    try {
      const [userData, dashData] = await Promise.all([
        api.getUsers().catch(() => ({ users: [] })),
        api.getDashboard().catch(() => ({ metrics: null, recentActivity: [] })),
      ]);
      setUsers(userData.users || []);
      if (dashData.metrics) {
        setMetrics(dashData.metrics);
        setActivity(dashData.recentActivity);
      }
    } catch (err) {
      console.error('Failed to refresh users:', err);
    }
  };

  useEffect(() => {
    if (user) {
      if (user.role.toUpperCase() === 'GOVERNMENT_VIEWER') {
        if (user.mustChangePassword) {
          setGovernmentReport(null);
          setGovernmentReportLoading(false);
        } else {
          void loadGovernmentReport();
        }
      } else {
        void loadAllData();
      }
    }
  }, [user]);

  // Global 401 Session Expiration Listener
  useEffect(() => {
    const handleSessionExpired = () => {
      setUser(null);
      toast.error(
        lang === 'am'
          ? 'የአገልግሎት ጊዜዎ አልቋል። እባክዎ እንደገና ይግቡ።'
          : 'Your session has expired. Please sign in again.',
        'Session Expired'
      );
      if (typeof window !== 'undefined') {
        window.history.replaceState({}, '', '/');
      }
    };

    window.addEventListener('yegna:session-expired', handleSessionExpired);
    return () => window.removeEventListener('yegna:session-expired', handleSessionExpired);
  }, [lang]);

  const handleLogout = () => {
    api.logout();
    setUser(null);
    if (typeof window !== 'undefined') {
      window.history.replaceState({}, '', '/');
    }
  };

  // Unified navigation with browser URL & history stack sync
  const handleNavigate = (id: string, sub?: string, replace = false) => {
    let targetTab = id;
    let targetSub = sub;

    if (id.startsWith('assessments-')) {
      targetTab = 'assessments';
      targetSub = id.split('-')[1];
    } else if (id === 'learning-assessments') {
      targetTab = 'assessments';
      targetSub = 'modules';
    }

    setCurrentTab(targetTab);
    if (targetSub) {
      setActiveSubTab(targetSub);
    }

    if (typeof window !== 'undefined') {
      const targetUrl = formatRouteUrl(targetTab, targetSub);
      if (window.location.pathname !== targetUrl) {
        if (replace) {
          window.history.replaceState({ tab: targetTab, subTab: targetSub }, '', targetUrl);
        } else {
          window.history.pushState({ tab: targetTab, subTab: targetSub }, '', targetUrl);
        }
      }
      document.title = getRouteTitle(targetTab, targetSub, lang);
    }
  };

  // Browser Back / Forward button navigation (popstate)
  useEffect(() => {
    const handlePopState = () => {
      const route = parseCurrentRoute(window.location.pathname);
      setCurrentTab(route.tab);
      if (route.subTab) {
        setActiveSubTab(route.subTab);
      }
      document.title = getRouteTitle(route.tab, route.subTab, lang);
    };

    window.addEventListener('popstate', handlePopState);
    return () => window.removeEventListener('popstate', handlePopState);
  }, [lang]);

  // Sync route and canonical URL on initial mount or lang change
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const route = parseCurrentRoute(window.location.pathname);
      const canonical = formatRouteUrl(route.tab, route.subTab);
      if (window.location.pathname !== canonical) {
        window.history.replaceState({ tab: route.tab, subTab: route.subTab }, '', canonical);
      }
      document.title = getRouteTitle(route.tab, route.subTab, lang);
    }
  }, [lang]);

  // Global Command Palette (Ctrl+K / Cmd+K) Listener
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault();
        setIsCommandPaletteOpen((prev) => !prev);
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

  const handleExportKpiCsv = () => {
    const rows = [
      { category: 'Platform Metric', item: 'Registered Students (Zero-Knowledge)', value: metrics?.registeredUsers ?? users.length, details: 'End-to-end confidential accounts' },
      { category: 'Platform Metric', item: 'Verified Campus Facilities', value: metrics?.verifiedFacilities || facilities.length, details: 'University of Gondar campus facilities' },
      { category: 'Platform Metric', item: 'Peer Mentors & Counselors', value: metrics?.counselorMentors || mentors.length, details: 'Active adolescent counselors' },
      { category: 'Platform Metric', item: 'Bilingual Health Modules', value: metrics?.learningModules || modules.length, details: 'Puberty, SRH, STI, Substance prevention' },
      { category: 'Platform Metric', item: 'Interactive Quiz Questions', value: metrics?.quizQuestions || questions.length, details: 'Clinical assessments' },
      { category: 'Platform Metric', item: 'Student Health Clubs', value: metrics?.studentClubs || clubs.length, details: 'Active student peer chapters' },
    ];

    exportToCsv(
      'Yegna_Health_Executive_KPI_Report',
      [
        { header: 'Category', accessor: (r) => r.category },
        { header: 'Indicator / Metric', accessor: (r) => r.item },
        { header: 'Current Value / Count', accessor: (r) => r.value },
        { header: 'Notes & Scope', accessor: (r) => r.details },
      ],
      rows
    );
    toast.success(
      lang === 'am' ? 'የአመራር ሪፖርት በተሳካ ሁኔታ ወርዷል' : 'Executive KPI report exported successfully',
      'Institutional Report'
    );
  };

  // Facility Actions
  const handleSaveFacility = async (data: Partial<Facility>, id?: string) => {
    try {
      if (id) {
        await api.updateFacility(id, data);
        toast.success(lang === 'am' ? 'የተቋሙ መረጃ ተዘምኗል' : 'Facility updated successfully', 'Facilities CMS');
      } else {
        await api.createFacility(data);
        toast.success(lang === 'am' ? 'አዲስ ተቋም ተመዝግቧል' : 'New facility added', 'Facilities CMS');
      }
      await refreshFacilities();
    } catch (err: any) {
      toast.error(err.message || 'Failed to save facility', 'Error');
    }
  };

  const handleDeleteFacility = async (id: string) => {
    try {
      await api.deleteFacility(id);
      toast.info(lang === 'am' ? 'ተቋሙ ተሰርዟል' : 'Facility removed from directory', 'Removed');
      await refreshFacilities();
    } catch (err: any) {
      toast.error(err.message || 'Failed to delete facility', 'Error');
    }
  };

  // Mentor Actions
  const handleSaveMentor = async (data: Partial<Mentor>, id?: string) => {
    try {
      if (id) {
        await api.updateMentor(id, data);
        toast.success(lang === 'am' ? 'የአማካሪ መረጃ ተዘምኗል' : 'Counselor profile updated', 'Peer Mentors');
      } else {
        await api.createMentor(data);
        toast.success(lang === 'am' ? 'አዲስ አማካሪ ተመዝግቧል' : 'New peer mentor registered', 'Peer Mentors');
      }
      await refreshMentors();
    } catch (err: any) {
      toast.error(err.message || 'Failed to save mentor', 'Error');
    }
  };

  const handleDeleteMentor = async (id: string) => {
    try {
      await api.deleteMentor(id);
      toast.info(lang === 'am' ? 'አማካሪው ተሰርዟል' : 'Mentor removed from network', 'Removed');
      await refreshMentors();
    } catch (err: any) {
      toast.error(err.message || 'Failed to delete mentor', 'Error');
    }
  };

  // Module Actions
  const handleSaveModule = async (
    data: Partial<Module>,
    id?: string,
    extraQuizzes?: Array<Partial<QuizQuestion>>
  ) => {
    try {
      let targetModuleId = id;
      if (id) {
        await api.updateModule(id, data);
        toast.success(lang === 'am' ? 'ሞጁሉ ተዘምኗል' : 'Learning module updated', 'Learning CMS');
      } else {
        const res = await api.createModule(data);
        targetModuleId = res.module.id;
        toast.success(lang === 'am' ? 'አዲስ ሞጁል ታትሟል' : 'New health module published', 'Learning CMS');
      }

      // If extra quiz questions were authored directly inside the module form
      if (extraQuizzes && extraQuizzes.length > 0 && targetModuleId) {
        for (const q of extraQuizzes) {
          try {
            if (q.id && !q.id.startsWith('temp-')) {
              await api.updateQuestion(q.id, { ...q, moduleId: targetModuleId });
            } else {
              const { id: _tempId, ...createPayload } = q;
              await api.createQuestion({ ...createPayload, moduleId: targetModuleId });
            }
          } catch (qErr) {
            console.error('Failed to sync module question:', qErr);
          }
        }
      }

      await refreshModulesAndQuizzes();
    } catch (err: any) {
      toast.error(err.message || 'Failed to save module', 'Error');
    }
  };

  const handleDeleteModule = async (id: string) => {
    try {
      await api.deleteModule(id);
      toast.info(lang === 'am' ? 'ሞጁሉ ተሰርዟል' : 'Curriculum module deleted', 'Removed');
      await refreshModulesAndQuizzes();
    } catch (err: any) {
      toast.error(err.message || 'Failed to delete module', 'Error');
    }
  };

  // Quiz Question Actions
  const handleSaveQuestion = async (data: Partial<QuizQuestion>, id?: string) => {
    try {
      if (id) {
        await api.updateQuestion(id, data);
        toast.success(lang === 'am' ? 'የፈተና ጥያቄው ተዘምኗል' : 'Quiz question updated', 'Assessment Bank');
      } else {
        await api.createQuestion(data);
        toast.success(lang === 'am' ? 'አዲስ ጥያቄ ተፈጥሯል' : 'New quiz question created', 'Assessment Bank');
      }
      await refreshModulesAndQuizzes();
    } catch (err: any) {
      toast.error(err.message || 'Failed to save question', 'Error');
    }
  };

  const handleDeleteQuestion = async (id: string) => {
    try {
      await api.deleteQuestion(id);
      toast.info(lang === 'am' ? 'ጥያቄው ተሰርዟል' : 'Quiz question deleted', 'Removed');
      await refreshModulesAndQuizzes();
    } catch (err: any) {
      toast.error(err.message || 'Failed to delete question', 'Error');
    }
  };

  const saveLearningAssessment = async (data: { moduleId: string; questions: { promptEn: string; promptAm: string; choices: { labelEn: string; labelAm: string; score: number }[] }[] }) => {
    try { await api.saveLearningAssessment(data); toast.success(lang === 'am' ? 'ምዘናው ተቀምጧል' : 'Learning assessment saved', 'Learning Assessments'); await refreshModulesAndQuizzes(); }
    catch (err: any) { toast.error(err.message || 'Failed to save assessment', 'Error'); }
  };
  const deleteLearningAssessment = async (id: string) => {
    try { await api.deleteLearningAssessment(id); toast.info(lang === 'am' ? 'ምዘናው ተሰርዟል' : 'Learning assessment deleted', 'Removed'); await refreshModulesAndQuizzes(); }
    catch (err: any) { toast.error(err.message || 'Failed to delete assessment', 'Error'); }
  };

  // Club Actions
  const handleSaveClub = async (data: Partial<StudentClub>, id?: string) => {
    try {
      if (id) {
        await api.updateClub(id, data);
        toast.success(lang === 'am' ? 'የክለብ መረጃ ተዘምኗል' : 'Student club updated', 'Student Chapters');
      } else {
        await api.createClub(data);
        toast.success(lang === 'am' ? 'አዲስ ክለብ ተመዝግቧል' : 'New student club chapter created', 'Student Chapters');
      }
      await refreshClubs();
    } catch (err: any) {
      toast.error(err.message || 'Failed to save club', 'Error');
    }
  };

  const handleToggleClubApproval = async (club: StudentClub) => {
    try {
      await api.updateClub(club.id, { isApproved: !club.isApproved });
      toast.success(
        club.isApproved
          ? (lang === 'am' ? 'ክለቡ ወደ መጠባበቂያ ተቀይሯል' : 'Club set to Pending approval')
          : (lang === 'am' ? 'ክለቡ በይፋ ጸድቋል' : 'Club officially Approved & Activated!'),
        'Club Moderation'
      );
      await refreshClubs();
    } catch (err: any) {
      toast.error(err.message || 'Failed to update approval status', 'Error');
    }
  };

  const handleDeleteClub = async (id: string) => {
    try {
      await api.deleteClub(id);
      toast.info(lang === 'am' ? 'ክለቡ ተሰርዟል' : 'Student club deleted', 'Removed');
      await refreshClubs();
    } catch (err: any) {
      toast.error(err.message || 'Failed to delete club', 'Error');
    }
  };

  // Broadcast Notification Actions
  const handleSendBroadcast = async (data: Partial<BroadcastNotification>) => {
    try {
      await api.createBroadcastNotification(data);
      toast.success(
        lang === 'am' ? 'ይፋዊ ማሳወቂያው ለተማሪዎች ተላልፏል' : 'Broadcast dispatched to students',
        'Notification Center'
      );
      await refreshBroadcasts();
    } catch (err: any) {
      toast.error(err.message || 'Failed to send broadcast', 'Error');
    }
  };

  const handleDeleteBroadcast = async (id: string) => {
    try {
      await api.deleteBroadcastNotification(id);
      toast.info(
        lang === 'am' ? 'ማሳወቂያው ተሰርዟል' : 'Broadcast removed from student feed',
        'Notification Center'
      );
      await refreshBroadcasts();
    } catch (err: any) {
      toast.error(err.message || 'Failed to delete broadcast', 'Error');
    }
  };

  // User Actions
  const handleUpdateRole = async (id: string, role: string) => {
    try {
      await api.updateUserRole(id, role);
      toast.success(
        lang === 'am' ? `የተጠቃሚው ሚና ወደ ${role} ተቀይሯል` : `User role changed to ${role}`,
        'Role Governance'
      );
      await refreshUsers();
    } catch (err: any) {
      toast.error(err.message || 'Failed to update user role', 'Error');
    }
  };

  const handleToggleSuspension = async (id: string) => {
    try {
      await api.toggleUserSuspension(id);
      toast.warning(
        lang === 'am' ? 'የተጠቃሚው እገዳ ሁኔታ ተቀይሯል' : 'User account suspension toggled',
        'Safety Moderation'
      );
      await refreshUsers();
    } catch (err: any) {
      toast.error(err.message || 'Failed to toggle suspension', 'Error');
    }
  };

  const handleResetPassword = async (id: string, newPassword: string) => {
    try {
      await api.resetUserPassword(id, newPassword);
      toast.success(
        lang === 'am' ? 'የተጠቃሚው የይለፍ ቃል ተቀይሯል' : 'User password reset successfully',
        'Security'
      );
    } catch (err: any) {
      toast.error(err.message || 'Failed to reset password', 'Error');
    }
  };

  const handleDeleteUser = async (id: string) => {
    try {
      await api.deleteUser(id);
      toast.info(
        lang === 'am' ? 'የተጠቃሚ አካውንት ተሰርዟል' : 'User account deleted',
        'User Management'
      );
      await refreshUsers();
    } catch (err: any) {
      toast.error(err.message || 'Failed to delete user', 'Error');
    }
  };

  const handleVerifyEmail = async (id: string) => {
    try {
      await api.verifyUserEmail(id);
      setUsers((prev) =>
        prev.map((u) => (u.id === id ? { ...u, isEmailVerified: true } : u))
      );
      toast.success(
        lang === 'am' ? 'የተጠቃሚው ኢሜይል ተረጋግጧል' : 'User email verified successfully',
        'Verification'
      );
    } catch (err: any) {
      toast.error(err.message || 'Failed to verify email', 'Error');
    }
  };

  const handleCreateUser = async (data: {
    email: string;
    displayName: string;
    password?: string;
    role?: string;
    isEmailVerified?: boolean;
  }) => {
    try {
      await api.createUser(data);
      toast.success(
        lang === 'am'
          ? 'አዲስ ተጠቃሚ በተሳካ ሁኔታ ተፈጥሯል'
          : `User "${data.displayName || data.email}" created successfully`,
        'User Management'
      );
      await refreshUsers();
    } catch (err: any) {
      toast.error(err.message || 'Failed to create user', 'Error');
      throw err;
    }
  };

  if (!user) {
    return (
      <LoginPage
        onLoginSuccess={setUser}
        lang={lang}
        onToggleLang={() => setLang(lang === 'en' ? 'am' : 'en')}
      />
    );
  }

  if (user.role.toUpperCase() === 'GOVERNMENT_VIEWER') {
    return (
      <GovernmentReportsPage
        user={user}
        report={governmentReport}
        isLoading={governmentReportLoading}
        error={governmentReportError}
        onRetry={() => void loadGovernmentReport()}
        lang={lang}
        onToggleLang={() => setLang((current) => (current === 'en' ? 'am' : 'en'))}
        onLogout={handleLogout}
        onPasswordChanged={setUser}
      />
    );
  }

  return (
    <>
      <AdminLayout
        currentTab={currentTab}
        activeSubTab={activeSubTab}
        onTabChange={handleNavigate}
        user={user}
        onLogout={handleLogout}
        lang={lang}
        onToggleLang={() => setLang(lang === 'en' ? 'am' : 'en')}
        onOpenCommandPalette={() => setIsCommandPaletteOpen(true)}
        onRefresh={() => loadAllData(true)}
        isRefreshing={isRefreshing}
        isLoading={isLoading}
        userCount={users.length}
      >
        {currentTab === 'dashboard' && (
          <DashboardPage
            metrics={metrics}
            facilities={facilities}
            mentors={mentors}
            modules={modules}
            questions={questions}
            clubs={clubs}
            users={users}
            activity={activity}
            lang={lang}
            onNavigate={(tab) => handleNavigate(tab)}
          />
        )}
        {currentTab === 'facilities' && (
          <FacilitiesPage
            facilities={facilities}
            lang={lang}
            isLoading={isLoading}
            onSave={handleSaveFacility}
            onDelete={handleDeleteFacility}
          />
        )}
        {currentTab === 'mentors' && (
          <MentorsPage
            mentors={mentors}
            lang={lang}
            isLoading={isLoading}
            onSave={handleSaveMentor}
            onDelete={handleDeleteMentor}
          />
        )}
        {currentTab === 'modules' && (
          <LearningCmsPage
            modules={modules}
            questions={questions}
            lang={lang}
            isLoading={isLoading}
            onSave={handleSaveModule}
            onDelete={handleDeleteModule}
            onSaveQuestion={handleSaveQuestion}
            onDeleteQuestion={handleDeleteQuestion}
          />
        )}
        {currentTab === 'quizzes' && (
          <QuizzesPage
            questions={questions}
            modules={modules}
            lang={lang}
            isLoading={isLoading}
            onSaveQuestion={handleSaveQuestion}
            onDeleteQuestion={handleDeleteQuestion}
          />
        )}
        {(currentTab === 'assessments' || currentTab === 'learning-assessments') && (
          <AssessmentsPage
            modules={modules}
            assessments={learningAssessments}
            lang={lang}
            activeSubTab={activeSubTab as any}
            onSubTabChange={(sub) => handleNavigate('assessments', sub)}
            onSaveAssessment={saveLearningAssessment}
            onDeleteAssessment={deleteLearningAssessment}
          />
        )}
        {currentTab === 'clubs' && (
          <ClubsPage
            clubs={clubs}
            lang={lang}
            isLoading={isLoading}
            onSaveClub={handleSaveClub}
            onDeleteClub={handleDeleteClub}
            onToggleApproval={handleToggleClubApproval}
          />
        )}
        {currentTab === 'notifications' && (
          <NotificationsPage
            broadcasts={broadcasts}
            lang={lang}
            isLoading={isLoading}
            onBroadcast={handleSendBroadcast}
            onDelete={handleDeleteBroadcast}
          />
        )}
        {currentTab === 'users' && (
          <UsersPage
            users={users}
            lang={lang}
            isLoading={isLoading}
            onCreateUser={handleCreateUser}
            onUpdateRole={handleUpdateRole}
            onToggleSuspension={handleToggleSuspension}
            onResetPassword={handleResetPassword}
            onDeleteUser={handleDeleteUser}
            onVerifyEmail={handleVerifyEmail}
          />
        )}
        {currentTab === 'audit' && <AuditLogsPage logs={logs} lang={lang} />}
      </AdminLayout>

      {/* Global Command Palette (Ctrl+K) */}
      <CommandPalette
        isOpen={isCommandPaletteOpen}
        onClose={() => setIsCommandPaletteOpen(false)}
        currentTab={currentTab}
        onNavigate={(tab) => handleNavigate(tab)}
        lang={lang}
        onToggleLang={() => setLang((l) => (l === 'en' ? 'am' : 'en'))}
        onLogout={handleLogout}
        facilities={facilities}
        mentors={mentors}
        modules={modules}
        clubs={clubs}
        onOpenAddFacility={() => handleNavigate('facilities')}
        onExportCsv={handleExportKpiCsv}
      />
    </>
  );
}
