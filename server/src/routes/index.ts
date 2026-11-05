import { Router } from 'express';
import { authenticateToken, requireAdmin } from '../middleware/auth.middleware.js';

import * as auth from '../controllers/auth.controller.js';
import * as facilities from '../controllers/facilities.controller.js';
import * as mentors from '../controllers/mentors.controller.js';
import * as modules from '../controllers/modules.controller.js';
import * as quizzes from '../controllers/quizzes.controller.js';
import * as clubs from '../controllers/clubs.controller.js';
import * as users from '../controllers/users.controller.js';
import * as dashboard from '../controllers/dashboard.controller.js';

export const router = Router();

// --- 1. HEALTH CHECK ---
router.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    service: 'Yegna Health Custom Backend API',
    timestamp: new Date().toISOString(),
  });
});

// --- 2. AUTHENTICATION ---
router.post('/auth/login', auth.login);
router.post('/auth/register', auth.register);
router.get('/auth/me', authenticateToken as any, auth.me as any);

// --- 3. PUBLIC DIRECTORIES (FOR MOBILE APP & WEB) ---
router.get('/facilities', facilities.getAllFacilities);
router.get('/facilities/:id', facilities.getFacilityById);

router.get('/mentors', mentors.getAllMentors);

router.get('/modules', modules.getAllModules);
router.get('/modules/:id', modules.getModuleById);

router.get('/quizzes', quizzes.getAllQuestions);

router.get('/clubs', clubs.getAllClubs);
router.post('/clubs/:id/join', authenticateToken as any, clubs.joinClub as any);

// --- 4. PROTECTED ADMIN ROUTES (REQUIRE ADMIN ROLE) ---
const adminRouter = Router();
adminRouter.use(authenticateToken as any, requireAdmin as any);

// Dashboard & Auditing
adminRouter.get('/dashboard', dashboard.getDashboardMetrics as any);
adminRouter.get('/audit-logs', dashboard.getAuditLogs as any);

// Facilities Management
adminRouter.post('/facilities', facilities.createFacility as any);
adminRouter.put('/facilities/:id', facilities.updateFacility as any);
adminRouter.delete('/facilities/:id', facilities.deleteFacility as any);

// Mentors Management
adminRouter.post('/mentors', mentors.createMentor as any);
adminRouter.put('/mentors/:id', mentors.updateMentor as any);
adminRouter.delete('/mentors/:id', mentors.deleteMentor as any);

// Learning CMS
adminRouter.post('/modules', modules.createModule as any);
adminRouter.put('/modules/:id', modules.updateModule as any);
adminRouter.delete('/modules/:id', modules.deleteModule as any);

// Quizzes & Assessments
adminRouter.get('/quizzes', quizzes.getAllQuestions as any);
adminRouter.post('/quizzes', quizzes.createQuestion as any);
adminRouter.put('/quizzes/:id', quizzes.updateQuestion as any);
adminRouter.delete('/quizzes/:id', quizzes.deleteQuestion as any);

// Student Clubs
adminRouter.post('/clubs', clubs.createClub as any);
adminRouter.put('/clubs/:id', clubs.updateClub as any);
adminRouter.delete('/clubs/:id', clubs.deleteClub as any);
adminRouter.get('/clubs/:id/roster', clubs.getClubRoster as any);

// User Governance
adminRouter.get('/users', users.getAllUsers as any);
adminRouter.put('/users/:id/role', users.updateUserRole as any);
adminRouter.put('/users/:id/suspend', users.toggleUserSuspension as any);

router.use('/admin', adminRouter);
