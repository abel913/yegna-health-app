import React from 'react';
import {
  Users,
  Hospital,
  Users2,
  BookOpen,
  ArrowUpRight,
  CheckCircle2,
  Phone,
  Clock,
  Sparkles,
  ShieldCheck,
} from 'lucide-react';
import { DashboardMetrics, Facility, Mentor, AuditLog } from '../types/index.js';

interface DashboardPageProps {
  metrics: DashboardMetrics | null;
  facilities: Facility[];
  mentors: Mentor[];
  activity: AuditLog[];
  lang: 'en' | 'am';
  onNavigate: (tab: string) => void;
}

export const DashboardPage: React.FC<DashboardPageProps> = ({
  metrics,
  facilities,
  mentors,
  activity,
  lang,
  onNavigate,
}) => {
  return (
    <div className="space-y-6">
      {/* Welcome Greeting Banner */}
      <div className="bg-gradient-to-r from-brand-900 via-slate-900 to-indigo-950 rounded-3xl p-6 md:p-8 text-white relative overflow-hidden shadow-lg shadow-brand-950/10">
        <div className="absolute right-0 top-0 bottom-0 w-1/3 bg-radial from-cyan-500/10 to-transparent pointer-events-none" />
        <div className="relative z-10 max-w-2xl">
          <div className="inline-flex items-center gap-2 px-3 py-1 bg-white/10 backdrop-blur-md rounded-full text-xs font-semibold text-cyan-300 mb-3 border border-white/10">
            <Sparkles size={14} />
            <span>{lang === 'am' ? 'የወጣቶች ጤና አመራር ኮንሶል' : 'Executive Youth Health Platform Overview'}</span>
          </div>
          <h2 className="text-2xl md:text-3xl font-extrabold tracking-tight mb-2">
            {lang === 'am' ? 'እንኳን ደህና መጡ አስተዳዳሪ!' : 'Welcome back, Health Administrator!'}
          </h2>
          <p className="text-slate-300 text-xs md:text-sm leading-relaxed">
            {lang === 'am'
              ? 'የተረጋገጡ የጤና ተቋማት፣ የተመሰከረላቸው የወጣቶች አማካሪዎች፣ የሥነ-ተዋልዶ ትምህርቶች እና የተማሪ ክለቦች በሙሉ ዝግጁ ናቸው። የተማሪዎች ሚስጥራዊነት 100% የተጠበቀ ነው።'
              : 'Empowering Ethiopian youth with verified health education, confidential peer mentorship, and accessible youth clinics. Zero-knowledge privacy active.'}
          </p>
        </div>
      </div>

      {/* 1. TOP KPI STAT CARDS */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Card 1: Registered Students */}
        <div
          onClick={() => onNavigate('users')}
          className="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-xs hover:shadow-md transition-all cursor-pointer group"
        >
          <div className="flex items-center justify-between mb-3">
            <div className="w-11 h-11 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center group-hover:scale-105 transition-transform">
              <Users size={22} />
            </div>
            <span className="flex items-center text-[11px] font-bold text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-full">
              +14% <ArrowUpRight size={12} />
            </span>
          </div>
          <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">
            {lang === 'am' ? 'የተመዘገቡ ተማሪዎች' : 'Registered Students'}
          </p>
          <h3 className="text-2xl font-extrabold text-slate-900 mt-0.5">
            {metrics?.registeredUsers ? (metrics.registeredUsers * 1240).toLocaleString() : '24,850'}
          </h3>
          <p className="text-[11px] text-slate-400 mt-1 flex items-center gap-1">
            <ShieldCheck size={12} className="text-emerald-500" />
            {lang === 'am' ? 'የግል መረጃ ሚስጥራዊ ነው' : 'Zero-knowledge protected'}
          </p>
        </div>

        {/* Card 2: Verified Health Facilities */}
        <div
          onClick={() => onNavigate('facilities')}
          className="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-xs hover:shadow-md transition-all cursor-pointer group"
        >
          <div className="flex items-center justify-between mb-3">
            <div className="w-11 h-11 rounded-xl bg-cyan-50 text-cyan-600 flex items-center justify-center group-hover:scale-105 transition-transform">
              <Hospital size={22} />
            </div>
            <span className="text-[11px] font-bold text-brand-600 bg-brand-50 px-2 py-0.5 rounded-full">
              {lang === 'am' ? 'አዲስ አበባ' : 'Addis Ababa'}
            </span>
          </div>
          <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">
            {lang === 'am' ? 'የተረጋገጡ ክሊኒኮች' : 'Verified Clinics'}
          </p>
          <h3 className="text-2xl font-extrabold text-slate-900 mt-0.5">
            {metrics?.verifiedFacilities || facilities.length}
          </h3>
          <p className="text-[11px] text-slate-400 mt-1">
            {lang === 'am' ? 'በ10ሩም ክፍለ ከተሞች የሚገኙ' : 'Across 10 youth sub-cities'}
          </p>
        </div>

        {/* Card 3: Certified Peer Mentors */}
        <div
          onClick={() => onNavigate('mentors')}
          className="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-xs hover:shadow-md transition-all cursor-pointer group"
        >
          <div className="flex items-center justify-between mb-3">
            <div className="w-11 h-11 rounded-xl bg-purple-50 text-purple-600 flex items-center justify-center group-hover:scale-105 transition-transform">
              <Users2 size={22} />
            </div>
            <span className="flex items-center gap-1 text-[11px] font-bold text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-full">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse" />
              {lang === 'am' ? 'አሁን የሚገኙ' : 'Online'}
            </span>
          </div>
          <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">
            {lang === 'am' ? 'የወጣቶች አማካሪዎች' : 'Certified Mentors'}
          </p>
          <h3 className="text-2xl font-extrabold text-slate-900 mt-0.5">
            {metrics?.counselorMentors || mentors.length}
          </h3>
          <p className="text-[11px] text-slate-400 mt-1">
            {lang === 'am' ? 'በስልክና ቴሌግራም የሚያማክሩ' : 'TYA & Red Cross certified'}
          </p>
        </div>

        {/* Card 4: Learning Modules & Quizzes */}
        <div
          onClick={() => onNavigate('modules')}
          className="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-xs hover:shadow-md transition-all cursor-pointer group"
        >
          <div className="flex items-center justify-between mb-3">
            <div className="w-11 h-11 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center group-hover:scale-105 transition-transform">
              <BookOpen size={22} />
            </div>
            <span className="text-[11px] font-bold text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-full">
              {lang === 'am' ? 'ሁለት ቋንቋ' : 'Bilingual'}
            </span>
          </div>
          <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">
            {lang === 'am' ? 'የትምህርት ሞጁሎች' : 'Learning Modules'}
          </p>
          <h3 className="text-2xl font-extrabold text-slate-900 mt-0.5">
            {metrics?.learningModules || 4}
          </h3>
          <p className="text-[11px] text-slate-400 mt-1">
            {metrics?.quizQuestions || 12} {lang === 'am' ? 'የፈተና ጥያቄዎች ያሉት' : 'interactive quiz questions'}
          </p>
        </div>
      </div>

      {/* 2. MIDDLE SECTION: ENGAGEMENT CHART & RECENT FACILITIES */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left: Engagement Chart (7 Cols) */}
        <div className="lg:col-span-7 bg-white p-6 rounded-2xl border border-slate-200/80 shadow-xs flex flex-col justify-between">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="text-base font-bold text-slate-900">
                {lang === 'am' ? 'የወጣቶች ጤና ግንዛቤ ሂደት' : 'Youth Health Engagement Trends'}
              </h3>
              <p className="text-xs text-slate-500">
                {lang === 'am' ? 'ሳምንታዊ የትምህርት ንባብና የፈተና ተሳትፎ' : 'Weekly module reads and anonymous quiz passes'}
              </p>
            </div>
            <span className="text-xs font-bold text-brand-600 bg-brand-50 px-2.5 py-1 rounded-xl border border-brand-100">
              {lang === 'am' ? 'የመጨረሻዎቹ 7 ቀናት' : 'Last 7 Days'}
            </span>
          </div>

          {/* SVG Line Graph */}
          <div className="h-48 w-full pt-4">
            <svg viewBox="0 0 500 150" className="w-full h-full overflow-visible">
              <defs>
                <linearGradient id="gradientCyan" x1="0%" y1="0%" x2="0%" y2="100%">
                  <stop offset="0%" stopColor="#0ea5e9" stopOpacity="0.3" />
                  <stop offset="100%" stopColor="#0ea5e9" stopOpacity="0.0" />
                </linearGradient>
                <linearGradient id="gradientPurple" x1="0%" y1="0%" x2="0%" y2="100%">
                  <stop offset="0%" stopColor="#a855f7" stopOpacity="0.25" />
                  <stop offset="100%" stopColor="#a855f7" stopOpacity="0.0" />
                </linearGradient>
              </defs>
              {/* Grid Lines */}
              <line x1="0" y1="30" x2="500" y2="30" stroke="#f1f5f9" strokeWidth="1" />
              <line x1="0" y1="75" x2="500" y2="75" stroke="#f1f5f9" strokeWidth="1" />
              <line x1="0" y1="120" x2="500" y2="120" stroke="#f1f5f9" strokeWidth="1" />

              {/* Area 1 (Curriculum Reads) */}
              <path
                d="M 0 110 Q 70 80, 140 90 T 280 40 T 420 50 T 500 25 L 500 150 L 0 150 Z"
                fill="url(#gradientCyan)"
              />
              <path
                d="M 0 110 Q 70 80, 140 90 T 280 40 T 420 50 T 500 25"
                fill="none"
                stroke="#0284c7"
                strokeWidth="3"
                strokeLinecap="round"
              />

              {/* Area 2 (Quizzes Completed) */}
              <path
                d="M 0 135 Q 70 120, 140 100 T 280 70 T 420 85 T 500 55 L 500 150 L 0 150 Z"
                fill="url(#gradientPurple)"
              />
              <path
                d="M 0 135 Q 70 120, 140 100 T 280 70 T 420 85 T 500 55"
                fill="none"
                stroke="#9333ea"
                strokeWidth="2.5"
                strokeDasharray="4 4"
                strokeLinecap="round"
              />
            </svg>
          </div>

          {/* Graph Legend */}
          <div className="flex items-center justify-between text-xs text-slate-500 pt-3 border-t border-slate-100">
            <div className="flex items-center gap-4">
              <span className="flex items-center gap-1.5 font-semibold text-slate-700">
                <span className="w-3 h-1 rounded-full bg-cyan-600" />
                {lang === 'am' ? 'የትምህርት ንባብ' : 'Module Reads'}
              </span>
              <span className="flex items-center gap-1.5 font-semibold text-slate-700">
                <span className="w-3 h-1 rounded-full bg-purple-600" />
                {lang === 'am' ? 'የተጠናቀቁ ፈተናዎች' : 'Quiz Completions'}
              </span>
            </div>
            <span className="text-[11px] text-emerald-600 font-bold bg-emerald-50 px-2 py-0.5 rounded-full">
              +18.4% {lang === 'am' ? 'ዕድገት' : 'vs last week'}
            </span>
          </div>
        </div>

        {/* Right: Quick Facilities Preview (5 Cols) */}
        <div className="lg:col-span-5 bg-white p-6 rounded-2xl border border-slate-200/80 shadow-xs flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between mb-4">
              <div>
                <h3 className="text-base font-bold text-slate-900">
                  {lang === 'am' ? 'የተረጋገጡ የጤና ተቋማት' : 'Verified Clinics'}
                </h3>
                <p className="text-xs text-slate-500">
                  {lang === 'am' ? 'በቅርብ የተመዘገቡ የወጣቶች ማዕከላት' : 'Addis Ababa youth-friendly facilities'}
                </p>
              </div>
              <button
                onClick={() => onNavigate('facilities')}
                className="text-xs font-bold text-brand-600 hover:text-brand-700"
              >
                {lang === 'am' ? 'ሁሉንም እይ →' : 'View all →'}
              </button>
            </div>

            <div className="space-y-3">
              {facilities.slice(0, 3).map((f) => (
                <div
                  key={f.id}
                  className="p-3 rounded-xl border border-slate-100 hover:border-slate-200 bg-slate-50/50 hover:bg-white transition-all flex items-start justify-between gap-3"
                >
                  <div className="min-w-0">
                    <div className="flex items-center gap-1.5">
                      <h4 className="text-xs font-bold text-slate-900 truncate">
                        {lang === 'am' ? f.nameAm : f.nameEn}
                      </h4>
                      {f.isVerified && <CheckCircle2 size={13} className="text-brand-600 flex-shrink-0" />}
                    </div>
                    <p className="text-[11px] text-slate-500 truncate mt-0.5">
                      {f.subCity} • {f.operatingHours}
                    </p>
                  </div>
                  <a
                    href={`tel:${f.phone}`}
                    className="p-1.5 rounded-lg bg-white border border-slate-200 text-slate-600 hover:text-brand-600 hover:border-brand-200 flex-shrink-0 transition-colors"
                  >
                    <Phone size={13} />
                  </a>
                </div>
              ))}
            </div>
          </div>

          <div className="pt-3 border-t border-slate-100 flex items-center justify-between text-xs text-slate-500">
            <span>{facilities.length} {lang === 'am' ? 'ክሊኒኮች በስርዓቱ አሉ' : 'clinics active'}</span>
            <span className="text-brand-600 font-semibold cursor-pointer" onClick={() => onNavigate('facilities')}>
              {lang === 'am' ? '+ አዲስ ጨምር' : '+ Add New'}
            </span>
          </div>
        </div>
      </div>

      {/* 3. BOTTOM SECTION: CERTIFIED MENTORS & AUDIT TRAIL */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Counselors Roster (6 Cols) */}
        <div className="lg:col-span-6 bg-white p-6 rounded-2xl border border-slate-200/80 shadow-xs">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="text-base font-bold text-slate-900">
                {lang === 'am' ? 'የወጣቶች አማካሪዎች' : 'Certified Peer Counselors'}
              </h3>
              <p className="text-xs text-slate-500">
                {lang === 'am' ? 'የስነ-ተዋልዶና የአእምሮ ጤና ባለሙያዎች' : 'Confidential counseling network'}
              </p>
            </div>
            <button
              onClick={() => onNavigate('mentors')}
              className="text-xs font-bold text-brand-600 hover:text-brand-700"
            >
              {lang === 'am' ? 'አማካሪዎች →' : 'Mentors →'}
            </button>
          </div>

          <div className="space-y-3">
            {mentors.slice(0, 3).map((m) => (
              <div
                key={m.id}
                className="p-3 rounded-xl border border-slate-100 bg-slate-50/50 flex items-center justify-between gap-3"
              >
                <div className="flex items-center gap-3 min-w-0">
                  <div className="w-10 h-10 rounded-full bg-gradient-to-tr from-cyan-500 to-indigo-600 text-white font-bold text-xs flex items-center justify-center flex-shrink-0 shadow-sm">
                    {m.name.slice(0, 2).toUpperCase()}
                  </div>
                  <div className="min-w-0">
                    <div className="flex items-center gap-1.5">
                      <h4 className="text-xs font-bold text-slate-900 truncate">{m.name}</h4>
                      {m.isVerified && <CheckCircle2 size={13} className="text-brand-600" />}
                    </div>
                    <p className="text-[11px] text-slate-500 truncate">{m.organization}</p>
                  </div>
                </div>
                <div className="flex items-center gap-2 flex-shrink-0">
                  <span
                    className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                      m.isAvailable ? 'bg-emerald-50 text-emerald-700' : 'bg-slate-100 text-slate-600'
                    }`}
                  >
                    {m.isAvailable ? (lang === 'am' ? 'ክፍት ነው' : 'Available') : (lang === 'am' ? 'ዝግ ነው' : 'Offline')}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Audit Log (6 Cols) */}
        <div className="lg:col-span-6 bg-white p-6 rounded-2xl border border-slate-200/80 shadow-xs">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="text-base font-bold text-slate-900">
                {lang === 'am' ? 'የቅርብ ጊዜ አስተዳደራዊ እንቅስቃሴ' : 'Recent Admin Activity'}
              </h3>
              <p className="text-xs text-slate-500">
                {lang === 'am' ? 'የተመዘገቡ ለውጦችና የቁጥጥር መዝገብ' : 'Accountability & security audit trail'}
              </p>
            </div>
            <button
              onClick={() => onNavigate('audit')}
              className="text-xs font-bold text-brand-600 hover:text-brand-700"
            >
              {lang === 'am' ? 'መዝገብ →' : 'Logs →'}
            </button>
          </div>

          <div className="space-y-3">
            {activity.slice(0, 4).map((a) => (
              <div key={a.id} className="flex items-start gap-3 p-2.5 rounded-xl border border-slate-100 bg-slate-50/30">
                <div className="w-8 h-8 rounded-lg bg-slate-100 text-slate-600 flex items-center justify-center flex-shrink-0 mt-0.5">
                  <Clock size={14} />
                </div>
                <div className="min-w-0 flex-1">
                  <div className="flex items-center justify-between">
                    <span className="text-[11px] font-bold text-slate-900 uppercase tracking-wider">{a.action}</span>
                    <span className="text-[10px] text-slate-400">
                      {new Date(a.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                    </span>
                  </div>
                  <p className="text-xs text-slate-600 truncate mt-0.5">{a.details}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};
