import { Response } from 'express';
import { prisma } from '../config/index.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

export async function getDashboardMetrics(req: AuthRequest, res: Response) {
  try {
    const [
      activeArticles,
      learningModules,
      quizQuestions,
      verifiedFacilities,
      counselorMentors,
      studentClubs,
      registeredUsers,
      allUsers,
      allFacilities,
      allAudits,
    ] = await Promise.all([
      prisma.module.count({ where: { isPublished: true } }),
      prisma.module.count(),
      prisma.quizQuestion.count(),
      prisma.facility.count({ where: { isVerified: true } }),
      prisma.mentor.count(),
      prisma.studentClub.count({ where: { isApproved: true } }),
      prisma.user.count(),
      prisma.user.findMany({ select: { id: true, role: true, createdAt: true } }),
      prisma.facility.findMany({ select: { id: true, subCity: true, isVerified: true } }),
      prisma.auditLog.findMany({ select: { id: true, timestamp: true } }),
    ]);

    const recentAuditLogs = await prisma.auditLog.findMany({
      take: 8,
      orderBy: { timestamp: 'desc' },
    });

    // 1. Real Role Breakdown
    const usersByRole = {
      students: allUsers.filter((u) => u.role === 'STUDENT').length,
      mentors: allUsers.filter((u) => u.role === 'MENTOR').length,
      admins: allUsers.filter((u) => u.role === 'ADMIN' || u.role === 'SUPER_ADMIN').length,
      authors: allUsers.filter((u) => u.role === 'CONTENT_AUTHOR').length,
    };

    // 2. Real Facility Geographic Breakdown
    let addis = 0;
    let gondar = 0;
    let other = 0;
    allFacilities.forEach((f) => {
      const sc = f.subCity.toLowerCase();
      if (sc.includes('gondar') || sc.includes('uog') || sc.includes('maraki') || sc.includes('gcms')) {
        gondar++;
      } else if (['arada', 'kirkos', 'bole', 'lideta', 'addis'].some((k) => sc.includes(k))) {
        addis++;
      } else {
        other++;
      }
    });

    const facilitiesByRegion = { addis, gondar, other };

    // 3. Real Timeline Aggregation (7D, 30D, 12M)
    const now = new Date();

    // 7 Days
    const dayNamesEn = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const dayNamesAm = ['እሑድ', 'ሰኞ', 'ማክሰኞ', 'ረቡዕ', 'ሐሙስ', 'አርብ', 'ቅዳሜ'];
    const timeline7D = [];

    for (let i = 6; i >= 0; i--) {
      const d = new Date(now);
      d.setDate(d.getDate() - i);
      const start = new Date(d.getFullYear(), d.getMonth(), d.getDate(), 0, 0, 0);
      const end = new Date(d.getFullYear(), d.getMonth(), d.getDate(), 23, 59, 59, 999);

      const signups = allUsers.filter((u) => {
        const uDate = new Date(u.createdAt);
        return uDate >= start && uDate <= end;
      }).length;

      const actions = allAudits.filter((a) => {
        const aDate = new Date(a.timestamp);
        return aDate >= start && aDate <= end;
      }).length;

      timeline7D.push({
        labelEn: dayNamesEn[d.getDay()],
        labelAm: dayNamesAm[d.getDay()],
        signups,
        actions,
        date: d.toISOString().split('T')[0],
      });
    }

    // 30 Days (4 Weeks)
    const timeline30D = [];
    for (let w = 3; w >= 0; w--) {
      const start = new Date(now);
      start.setDate(start.getDate() - (w + 1) * 7);
      const end = new Date(now);
      end.setDate(end.getDate() - w * 7);

      const signups = allUsers.filter((u) => {
        const uDate = new Date(u.createdAt);
        return uDate >= start && uDate <= end;
      }).length;

      const actions = allAudits.filter((a) => {
        const aDate = new Date(a.timestamp);
        return aDate >= start && aDate <= end;
      }).length;

      const weekNum = 4 - w;
      timeline30D.push({
        labelEn: `Week ${weekNum}`,
        labelAm: `ሳምንት ${weekNum}`,
        signups,
        actions,
        date: `${start.toISOString().split('T')[0]} to ${end.toISOString().split('T')[0]}`,
      });
    }

    // 12 Months
    const monthNamesEn = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const monthNamesAm = ['ጥር', 'የካቲት', 'መጋቢት', 'ሚያዝያ', 'ግንቦት', 'ሰኔ', 'ሐምሌ', 'ነሐሴ', 'መስከረም', 'ጥቅምት', 'ኅዳር', 'ታኅሣሥ'];
    const timeline12M = [];

    for (let m = 5; m >= 0; m--) {
      const d = new Date(now.getFullYear(), now.getMonth() - m, 1);
      const start = new Date(d.getFullYear(), d.getMonth(), 1, 0, 0, 0);
      const end = new Date(d.getFullYear(), d.getMonth() + 1, 0, 23, 59, 59, 999);

      const signups = allUsers.filter((u) => {
        const uDate = new Date(u.createdAt);
        return uDate >= start && uDate <= end;
      }).length;

      const actions = allAudits.filter((a) => {
        const aDate = new Date(a.timestamp);
        return aDate >= start && aDate <= end;
      }).length;

      timeline12M.push({
        labelEn: monthNamesEn[d.getMonth()],
        labelAm: monthNamesAm[d.getMonth()],
        signups,
        actions,
        date: `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`,
      });
    }

    return res.json({
      metrics: {
        activeArticles,
        learningModules,
        quizQuestions,
        verifiedFacilities,
        counselorMentors,
        studentClubs,
        registeredUsers,
        usersByRole,
        facilitiesByRegion,
        timeline: {
          '7D': timeline7D,
          '30D': timeline30D,
          '12M': timeline12M,
        },
      },
      recentActivity: recentAuditLogs,
    });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function getAuditLogs(req: AuthRequest, res: Response) {
  try {
    const logs = await prisma.auditLog.findMany({
      take: 50,
      orderBy: { timestamp: 'desc' },
    });

    return res.json({ logs });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}
