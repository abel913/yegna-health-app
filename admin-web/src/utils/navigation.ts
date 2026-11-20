export interface AdminRoute {
  tab: string;
  subTab?: string;
}

/**
 * Parses the browser's current window.location.pathname into an internal tab and subtab.
 */
export function parseCurrentRoute(pathname: string): AdminRoute {
  // Normalize path by stripping trailing slashes and making lowercase
  const clean = pathname.replace(/\/+$/, '').trim().toLowerCase();

  if (!clean || clean === '/dashboard') {
    return { tab: 'dashboard' };
  }

  if (clean === '/facilities') {
    return { tab: 'facilities' };
  }

  if (clean === '/mentors') {
    return { tab: 'mentors' };
  }

  if (clean === '/modules' || clean === '/learning') {
    return { tab: 'modules' };
  }

  if (clean === '/quizzes') {
    return { tab: 'quizzes' };
  }

  if (clean.startsWith('/assessments')) {
    const parts = clean.split('/').filter(Boolean);
    const sub = parts[1];
    if (sub === 'questions') {
      return { tab: 'assessments', subTab: 'questions' };
    }
    if (sub === 'modules' || sub === 'module-tests') {
      return { tab: 'assessments', subTab: 'modules' };
    }
    return { tab: 'assessments', subTab: 'baseline' };
  }

  if (clean === '/learning-assessments') {
    return { tab: 'assessments', subTab: 'modules' };
  }

  if (clean === '/clubs') {
    return { tab: 'clubs' };
  }

  if (clean === '/notifications' || clean === '/broadcasts') {
    return { tab: 'notifications' };
  }

  if (clean === '/users') {
    return { tab: 'users' };
  }

  if (clean === '/audit' || clean === '/audit-logs') {
    return { tab: 'audit' };
  }

  if (clean === '/reports' || clean === '/government') {
    return { tab: 'reports' };
  }

  // Fallback to dashboard for unknown routes
  return { tab: 'dashboard' };
}

/**
 * Formats an internal tab and subtab into a canonical URL path.
 */
export function formatRouteUrl(tab: string, subTab?: string): string {
  if (tab === 'dashboard') {
    return '/dashboard';
  }

  if (tab === 'assessments') {
    if (subTab && subTab !== 'baseline') {
      return `/assessments/${subTab}`;
    }
    return '/assessments';
  }

  if (tab === 'learning-assessments') {
    return '/assessments/modules';
  }

  return `/${tab}`;
}

/**
 * Returns a human-friendly document title for the current route and language.
 */
export function getRouteTitle(tab: string, subTab?: string, lang: 'en' | 'am' = 'en'): string {
  const isAm = lang === 'am';
  let title = 'Admin Portal';

  switch (tab) {
    case 'dashboard':
      title = isAm ? 'ዳሽቦርድ' : 'Dashboard';
      break;
    case 'facilities':
      title = isAm ? 'የጤና ተቋማት' : 'Campus Facilities';
      break;
    case 'mentors':
      title = isAm ? 'የአቻ አማካሪዎች' : 'Peer Mentors';
      break;
    case 'modules':
      title = isAm ? 'የትምህርት ሞጁሎች' : 'Learning CMS';
      break;
    case 'quizzes':
      title = isAm ? 'የፈተና ጥያቄዎች' : 'Interactive Quizzes';
      break;
    case 'assessments':
      if (subTab === 'questions') {
        title = isAm ? 'ጥያቄዎች አስተዳድር • ምዘና' : 'Survey Questions • Assessments';
      } else if (subTab === 'modules') {
        title = isAm ? 'የሞጁል ፈተናዎች • ምዘና' : 'Module Tests • Assessments';
      } else {
        title = isAm ? 'የመግቢያ ቅኝት • ምዘና' : 'Survey Insights • Assessments';
      }
      break;
    case 'clubs':
      title = isAm ? 'የተማሪዎች ክለቦች' : 'Student Clubs';
      break;
    case 'notifications':
      title = isAm ? 'ማሳወቂያዎች' : 'Broadcast Center';
      break;
    case 'users':
      title = isAm ? 'የተጠቃሚዎች አስተዳደር' : 'User Management';
      break;
    case 'audit':
      title = isAm ? 'የቁጥጥር መዝገብ' : 'Audit Logs';
      break;
    case 'reports':
      title = isAm ? 'የመንግስት ሪፖርቶች' : 'Government Platform Reports';
      break;
  }

  return `${title} • Yegna Health`;
}
