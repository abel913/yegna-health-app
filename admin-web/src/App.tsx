import { useState, useEffect } from 'react';
import { AdminLayout } from './components/layout/AdminLayout.js';
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

export function App() {
  const [user, setUser] = useState<AdminUser | null>(() => api.getCurrentUser());
  const [currentTab, setCurrentTab] = useState('dashboard');
  const [lang, setLang] = useState<'en' | 'am'>('en');

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

  // Facility Actions
  const handleSaveFacility = async (data: Partial<Facility>, id?: string) => {
    if (id) {
      await api.updateFacility(id, data);
    } else {
      await api.createFacility(data);
    }
    await loadAllData();
  };

  const handleDeleteFacility = async (id: string) => {
    await api.deleteFacility(id);
    await loadAllData();
  };

  // Mentor Actions
  const handleSaveMentor = async (data: Partial<Mentor>, id?: string) => {
    if (id) {
      await api.updateMentor(id, data);
    } else {
      await api.createMentor(data);
    }
    await loadAllData();
  };

  const handleDeleteMentor = async (id: string) => {
    await api.deleteMentor(id);
    await loadAllData();
  };

  // Module Actions
  const handleSaveModule = async (data: Partial<Module>, id?: string) => {
    if (id) {
      await api.updateModule(id, data);
    } else {
      await api.createModule(data);
    }
    await loadAllData();
  };

  const handleDeleteModule = async (id: string) => {
    await api.deleteModule(id);
    await loadAllData();
  };

  // Quiz Question Actions
  const handleSaveQuestion = async (data: Partial<QuizQuestion>, id?: string) => {
    if (id) {
      await api.updateQuestion(id, data);
    } else {
      await api.createQuestion(data);
    }
    await loadAllData();
  };

  const handleDeleteQuestion = async (id: string) => {
    await api.deleteQuestion(id);
    await loadAllData();
  };

  // Club Actions
  const handleSaveClub = async (data: Partial<StudentClub>, id?: string) => {
    if (id) {
      await api.updateClub(id, data);
    } else {
      await api.createClub(data);
    }
    await loadAllData();
  };

  const handleToggleClubApproval = async (club: StudentClub) => {
    await api.updateClub(club.id, { isApproved: !club.isApproved });
    await loadAllData();
  };

  const handleDeleteClub = async (id: string) => {
    await api.deleteClub(id);
    await loadAllData();
  };

  // User Actions
  const handleUpdateRole = async (id: string, role: string) => {
    await api.updateUserRole(id, role);
    await loadAllData();
  };

  const handleToggleSuspension = async (id: string) => {
    await api.toggleUserSuspension(id);
    await loadAllData();
  };

  if (!user) {
    return <LoginPage onLoginSuccess={setUser} lang={lang} />;
  }

  return (
    <AdminLayout
      currentTab={currentTab}
      onTabChange={setCurrentTab}
      user={user}
      onLogout={handleLogout}
      lang={lang}
      onToggleLang={() => setLang(lang === 'en' ? 'am' : 'en')}
      onQuickAction={() => setCurrentTab('facilities')}
    >
      {currentTab === 'dashboard' && (
        <DashboardPage
          metrics={metrics}
          facilities={facilities}
          mentors={mentors}
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
          onUpdateRole={handleUpdateRole}
          onToggleSuspension={handleToggleSuspension}
        />
      )}
      {currentTab === 'audit' && <AuditLogsPage logs={logs} lang={lang} />}
    </AdminLayout>
  );
}
