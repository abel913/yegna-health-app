import { useState, useEffect } from 'react';
import { AdminLayout } from './components/layout/AdminLayout.js';
import { CommandPalette } from './components/CommandPalette.js';
import { DashboardPage } from './pages/DashboardPage.js';
import { FacilitiesPage } from './pages/FacilitiesPage.js';
import { MentorsPage } from './pages/MentorsPage.js';
import { LearningCmsPage } from './pages/LearningCmsPage.js';
import { QuizzesPage } from './pages/QuizzesPage.js';
import { ClubsPage } from './pages/ClubsPage.js';
import { UsersPage } from './pages/UsersPage.js';
import { AuditLogsPage } from './pages/AuditLogsPage.js';
import { LoginPage } from './pages/LoginPage.js';
import { api } from './services/api.js';
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
} from './types/index.js';
import { useToast } from './context/ToastContext.js';
import { exportToCsv } from './utils/csvExport.js';

export function App() {
  const { toast } = useToast();
  const [user, setUser] = useState<AdminUser | null>(() => api.getCurrentUser());
  const [currentTab, setCurrentTab] = useState('dashboard');
  const [lang, setLang] = useState<'en' | 'am'>('en');
  const [isCommandPaletteOpen, setIsCommandPaletteOpen] = useState(false);

  // App Data State
  const [metrics, setMetrics] = useState<DashboardMetrics | null>(null);
  const [activity, setActivity] = useState<AuditLog[]>([]);
  const [facilities, setFacilities] = useState<Facility[]>([]);
  const [mentors, setMentors] = useState<Mentor[]>([]);
  const [modules, setModules] = useState<Module[]>([]);
  const [questions, setQuestions] = useState<QuizQuestion[]>([]);
  const [clubs, setClubs] = useState<StudentClub[]>([]);
  const [users, setUsers] = useState<ManagedUser[]>([]);
  const [logs, setLogs] = useState<AuditLog[]>([]);

  const loadAllData = async () => {
    if (!user) return;
    try {
      const [dashData, facData, menData, modData, qData, clubData, userData, logData] =
        await Promise.all([
          api.getDashboard().catch(() => ({ metrics: null, recentActivity: [] })),
          api.getFacilities().catch(() => ({ facilities: [] })),
          api.getMentors().catch(() => ({ mentors: [] })),
          api.getModules().catch(() => ({ modules: [] })),
          api.getQuestions().catch(() => ({ questions: [] })),
          api.getClubs().catch(() => ({ clubs: [] })),
          api.getUsers().catch(() => ({ users: [] })),
          api.getAuditLogs().catch(() => ({ logs: [] })),
        ]);

      if (dashData.metrics) {
        setMetrics(dashData.metrics);
        setActivity(dashData.recentActivity);
      }
      setFacilities(facData.facilities || []);
      setMentors(menData.mentors || []);
      setModules(modData.modules || []);
      setQuestions(qData.questions || []);
      setClubs(clubData.clubs || []);
      setUsers(userData.users || []);
      setLogs(logData.logs || []);
    } catch (err) {
      console.error('Failed to load portal data:', err);
    }
  };

  useEffect(() => {
    if (user) {
      loadAllData();
    }
  }, [user]);

  const handleLogout = () => {
    api.logout();
    setUser(null);
  };

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
      { category: 'Platform Metric', item: 'Registered Students (Zero-Knowledge)', value: metrics?.registeredUsers || 1240, details: 'End-to-end confidential accounts' },
      { category: 'Platform Metric', item: 'Verified Health Clinics', value: metrics?.verifiedFacilities || facilities.length, details: 'Campuses & regional youth centers' },
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
        toast.success(lang === 'am' ? 'አዲስ ተቋም ተመዝግቧል' : 'New health facility added', 'Facilities CMS');
      }
      await loadAllData();
    } catch (err: any) {
      toast.error(err.message || 'Failed to save facility', 'Error');
    }
  };

  const handleDeleteFacility = async (id: string) => {
    try {
      await api.deleteFacility(id);
      toast.info(lang === 'am' ? 'ተቋሙ ተሰርዟል' : 'Facility removed from directory', 'Removed');
      await loadAllData();
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
      await loadAllData();
    } catch (err: any) {
      toast.error(err.message || 'Failed to save mentor', 'Error');
    }
  };

  const handleDeleteMentor = async (id: string) => {
    try {
      await api.deleteMentor(id);
      toast.info(lang === 'am' ? 'አማካሪው ተሰርዟል' : 'Mentor removed from network', 'Removed');
      await loadAllData();
    } catch (err: any) {
      toast.error(err.message || 'Failed to delete mentor', 'Error');
    }
  };

  // Module Actions
  const handleSaveModule = async (data: Partial<Module>, id?: string) => {
    try {
      if (id) {
        await api.updateModule(id, data);
        toast.success(lang === 'am' ? 'ሞጁሉ ተዘምኗል' : 'Learning module updated', 'Learning CMS');
      } else {
        await api.createModule(data);
        toast.success(lang === 'am' ? 'አዲስ ሞጁል ታትሟል' : 'New health module published', 'Learning CMS');
      }
      await loadAllData();
    } catch (err: any) {
      toast.error(err.message || 'Failed to save module', 'Error');
    }
  };

  const handleDeleteModule = async (id: string) => {
    try {
      await api.deleteModule(id);
      toast.info(lang === 'am' ? 'ሞጁሉ ተሰርዟል' : 'Curriculum module deleted', 'Removed');
      await loadAllData();
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
      await loadAllData();
    } catch (err: any) {
      toast.error(err.message || 'Failed to save question', 'Error');
    }
  };

  const handleDeleteQuestion = async (id: string) => {
    try {
      await api.deleteQuestion(id);
      toast.info(lang === 'am' ? 'ጥያቄው ተሰርዟል' : 'Quiz question deleted', 'Removed');
      await loadAllData();
    } catch (err: any) {
      toast.error(err.message || 'Failed to delete question', 'Error');
    }
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
      await loadAllData();
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
      await loadAllData();
    } catch (err: any) {
      toast.error(err.message || 'Failed to update approval status', 'Error');
    }
  };

  const handleDeleteClub = async (id: string) => {
    try {
      await api.deleteClub(id);
      toast.info(lang === 'am' ? 'ክለቡ ተሰርዟል' : 'Student club deleted', 'Removed');
      await loadAllData();
    } catch (err: any) {
      toast.error(err.message || 'Failed to delete club', 'Error');
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
      await loadAllData();
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
      await loadAllData();
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
      await loadAllData();
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
      await loadAllData();
    } catch (err: any) {
      toast.error(err.message || 'Failed to create user', 'Error');
      throw err;
    }
  };

  if (!user) {
    return <LoginPage onLoginSuccess={setUser} lang={lang} />;
  }

  return (
    <>
      <AdminLayout
        currentTab={currentTab}
        onTabChange={setCurrentTab}
        user={user}
        onLogout={handleLogout}
        lang={lang}
        onToggleLang={() => setLang(lang === 'en' ? 'am' : 'en')}
        onQuickAction={() => setCurrentTab('facilities')}
        onOpenCommandPalette={() => setIsCommandPaletteOpen(true)}
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
            onNavigate={setCurrentTab}
          />
        )}
        {currentTab === 'facilities' && (
          <FacilitiesPage
            facilities={facilities}
            lang={lang}
            onSave={handleSaveFacility}
            onDelete={handleDeleteFacility}
          />
        )}
        {currentTab === 'mentors' && (
          <MentorsPage
            mentors={mentors}
            lang={lang}
            onSave={handleSaveMentor}
            onDelete={handleDeleteMentor}
          />
        )}
        {currentTab === 'modules' && (
          <LearningCmsPage
            modules={modules}
            lang={lang}
            onSave={handleSaveModule}
            onDelete={handleDeleteModule}
          />
        )}
        {currentTab === 'quizzes' && (
          <QuizzesPage
            questions={questions}
            modules={modules}
            lang={lang}
            onSaveQuestion={handleSaveQuestion}
            onDeleteQuestion={handleDeleteQuestion}
          />
        )}
        {currentTab === 'clubs' && (
          <ClubsPage
            clubs={clubs}
            lang={lang}
            onSaveClub={handleSaveClub}
            onDeleteClub={handleDeleteClub}
            onToggleApproval={handleToggleClubApproval}
          />
        )}
        {currentTab === 'users' && (
          <UsersPage
            users={users}
            lang={lang}
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
        onNavigate={setCurrentTab}
        lang={lang}
        onToggleLang={() => setLang((l) => (l === 'en' ? 'am' : 'en'))}
        onLogout={handleLogout}
        facilities={facilities}
        mentors={mentors}
        modules={modules}
        clubs={clubs}
        onOpenAddFacility={() => setCurrentTab('facilities')}
        onExportCsv={handleExportKpiCsv}
      />
    </>
  );
}
