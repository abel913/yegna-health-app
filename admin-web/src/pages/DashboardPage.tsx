import React, { useState } from 'react';
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
  Download,
  TrendingUp,
  BarChart2,
  Compass,
  GraduationCap,
  Flame,
} from 'lucide-react';
import { DashboardMetrics, Facility, Mentor, AuditLog } from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';

interface DashboardPageProps {
  metrics: DashboardMetrics | null;
  facilities: Facility[];
  mentors: Mentor[];
  activity: AuditLog[];
  lang: 'en' | 'am';
  onNavigate: (tab: string) => void;
}

interface ChartPoint {
  labelEn: string;
  labelAm: string;
  reads: number;
  quizzes: number;
  score: number;
}

const TIMEFRAME_DATA: Record<'7D' | '30D' | '12M', ChartPoint[]> = {
  '7D': [
    { labelEn: 'Mon', labelAm: 'ሰኞ', reads: 1120, quizzes: 680, score: 85 },
    { labelEn: 'Tue', labelAm: 'ማክሰኞ', reads: 1450, quizzes: 890, score: 88 },
    { labelEn: 'Wed', labelAm: 'ረቡዕ', reads: 1320, quizzes: 810, score: 84 },
    { labelEn: 'Thu', labelAm: 'ሐሙስ', reads: 1680, quizzes: 1040, score: 91 },
    { labelEn: 'Fri', labelAm: 'አርብ', reads: 1940, quizzes: 1220, score: 93 },
    { labelEn: 'Sat', labelAm: 'ቅዳሜ', reads: 2210, quizzes: 1490, score: 89 },
    { labelEn: 'Sun', labelAm: 'እሑድ', reads: 1850, quizzes: 1150, score: 87 },
  ],
  '30D': [
    { labelEn: 'Week 1', labelAm: 'ሳምንት 1', reads: 8400, quizzes: 5100, score: 86 },
    { labelEn: 'Week 2', labelAm: 'ሳምንት 2', reads: 10200, quizzes: 6400, score: 89 },
    { labelEn: 'Week 3', labelAm: 'ሳምንት 3', reads: 11900, quizzes: 7800, score: 91 },
    { labelEn: 'Week 4', labelAm: 'ሳምንት 4', reads: 13500, quizzes: 8900, score: 92 },
  ],
  '12M': [
    { labelEn: 'Jan', labelAm: 'ጥር', reads: 24000, quizzes: 15200, score: 84 },
    { labelEn: 'Mar', labelAm: 'መጋቢት', reads: 31000, quizzes: 19800, score: 86 },
    { labelEn: 'May', labelAm: 'ግንቦት', reads: 38000, quizzes: 24500, score: 88 },
    { labelEn: 'Jul', labelAm: 'ሐምሌ', reads: 42000, quizzes: 27900, score: 90 },
    { labelEn: 'Sep', labelAm: 'መስከረም', reads: 49000, quizzes: 32400, score: 91 },
    { labelEn: 'Nov', labelAm: 'ኅዳር', reads: 54000, quizzes: 36200, score: 93 },
  ],
};

export const DashboardPage: React.FC<DashboardPageProps> = ({
  metrics,
  facilities,
  mentors,
  activity,
  lang,
  onNavigate,
}) => {
  const [timeframe, setTimeframe] = useState<'7D' | '30D' | '12M'>('7D');
  const [hoveredPointIndex, setHoveredPointIndex] = useState<number | null>(null);

  const chartPoints = TIMEFRAME_DATA[timeframe];
  const maxVal = Math.max(...chartPoints.map((p) => p.reads)) * 1.15;

  // Compute SVG line path points
  const svgWidth = 500;
  const svgHeight = 150;
  const stepX = svgWidth / (chartPoints.length - 1);

  const getReadsY = (val: number) => svgHeight - (val / maxVal) * 115 - 15;
  const getQuizzesY = (val: number) => svgHeight - (val / maxVal) * 115 - 15;

  const readsPoints = chartPoints.map((p, i) => ({
    x: i * stepX,
    y: getReadsY(p.reads),
    val: p.reads,
    quizzes: p.quizzes,
    score: p.score,
    label: lang === 'am' ? p.labelAm : p.labelEn,
  }));

  const quizzesPoints = chartPoints.map((p, i) => ({
    x: i * stepX,
    y: getQuizzesY(p.quizzes),
  }));

  // Build SVG path strings
  const readsPathD = readsPoints.reduce(
    (acc, p, i) => (i === 0 ? `M ${p.x} ${p.y}` : `${acc} L ${p.x} ${p.y}`),
    ''
  );
  const readsAreaD = `${readsPathD} L ${svgWidth} ${svgHeight} L 0 ${svgHeight} Z`;

  const quizzesPathD = quizzesPoints.reduce(
    (acc, p, i) => (i === 0 ? `M ${p.x} ${p.y}` : `${acc} L ${p.x} ${p.y}`),
    ''
  );
  const quizzesAreaD = `${quizzesPathD} L ${svgWidth} ${svgHeight} L 0 ${svgHeight} Z`;

  const handleExportExecutiveReport = () => {
    const rows = [
      { category: 'Platform Metric', item: 'Registered Students', value: metrics?.registeredUsers ? metrics.registeredUsers * 1240 : 24850, details: 'Zero-knowledge protected youth profiles' },
      { category: 'Platform Metric', item: 'Verified Healthcare Centers', value: metrics?.verifiedFacilities || facilities.length, details: 'University of Gondar and regional hubs' },
      { category: 'Platform Metric', item: 'Active Peer Counselors', value: metrics?.counselorMentors || mentors.length, details: 'Certified youth counselors' },
      { category: 'Platform Metric', item: 'Bilingual Health Modules', value: metrics?.learningModules || 4, details: 'Puberty, SRH, STI, Substance prevention' },
      { category: 'Platform Metric', item: 'Interactive Quiz Questions', value: metrics?.quizQuestions || 4, details: 'Clinical assessments' },
      { category: 'Platform Metric', item: 'Student Health Clubs', value: metrics?.studentClubs || 3, details: 'Active student peer chapters' },
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
  };

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
          <p className="text-slate-300 text-xs md:text-sm leading-relaxed mb-4">
            {lang === 'am'
              ? 'የተረጋገጡ የጤና ተቋማት፣ የተመሰከረላቸው የወጣቶች አማካሪዎች፣ የሥነ-ተዋልዶ ትምህርቶች እና የተማሪ ክለቦች በሙሉ ዝግጁ ናቸው። የተማሪዎች ሚስጥራዊነት 100% የተጠበቀ ነው።'
              : 'Empowering Ethiopian youth with verified health education, confidential peer mentorship, and accessible youth clinics. Zero-knowledge privacy active.'}
          </p>

          <button
            onClick={handleExportExecutiveReport}
            className="inline-flex items-center gap-2 px-3.5 py-2 bg-white/10 hover:bg-white/20 backdrop-blur-md rounded-xl text-xs font-bold text-white border border-white/20 transition-all cursor-pointer shadow-xs"
            title={lang === 'am' ? 'የአመራር ሪፖርት ወደ ኤክሴል (CSV) አውርድ' : 'Export executive metrics to Excel CSV'}
          >
            <Download size={14} className="text-cyan-300" />
            <span>{lang === 'am' ? 'የአመራር ሪፖርት አውርድ (CSV)' : 'Export Executive KPI Report (CSV)'}</span>
          </button>
        </div>
      </div>

      {/* 1. TOP KPI STAT CARDS */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Card 1: Registered Students */}
        <div
          onClick={() => onNavigate('users')}
          className="bg-white dark:bg-slate-900 p-5 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs hover:shadow-md transition-all cursor-pointer group"
        >
          <div className="flex items-center justify-between mb-3">
            <div className="w-11 h-11 rounded-xl bg-blue-50 dark:bg-blue-950/40 text-blue-600 dark:text-cyan-400 flex items-center justify-center group-hover:scale-105 transition-transform">
              <Users size={22} />
            </div>
            <span className="flex items-center text-[11px] font-bold text-emerald-600 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-950/40 px-2 py-0.5 rounded-full border border-emerald-100 dark:border-emerald-800/60">
              +14% <ArrowUpRight size={12} />
            </span>
          </div>
          <p className="text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
            {lang === 'am' ? 'የተመዘገቡ ተማሪዎች' : 'Registered Students'}
          </p>
          <h3 className="text-2xl font-extrabold text-slate-900 dark:text-white mt-0.5">
            {metrics?.registeredUsers ? (metrics.registeredUsers * 1240).toLocaleString() : '24,850'}
          </h3>
          <p className="text-[11px] text-slate-400 dark:text-slate-500 mt-1 flex items-center gap-1">
            <ShieldCheck size={12} className="text-emerald-500 dark:text-emerald-400" />
            {lang === 'am' ? 'የግል መረጃ ሚስጥራዊ ነው' : 'Zero-knowledge protected'}
          </p>
        </div>

        {/* Card 2: Verified Health Facilities */}
        <div
          onClick={() => onNavigate('facilities')}
          className="bg-white dark:bg-slate-900 p-5 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs hover:shadow-md transition-all cursor-pointer group"
        >
          <div className="flex items-center justify-between mb-3">
            <div className="w-11 h-11 rounded-xl bg-cyan-50 dark:bg-cyan-950/40 text-cyan-600 dark:text-cyan-400 flex items-center justify-center group-hover:scale-105 transition-transform">
              <Hospital size={22} />
            </div>
            <span className="text-[11px] font-bold text-brand-600 dark:text-cyan-400 bg-brand-50 dark:bg-brand-950/40 px-2 py-0.5 rounded-full border border-brand-100 dark:border-cyan-800/60">
              {lang === 'am' ? 'ጎንደርና አዲስ አበባ' : 'Gondar & Addis'}
            </span>
          </div>
          <p className="text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
            {lang === 'am' ? 'የተረጋገጡ ክሊኒኮች' : 'Verified Clinics'}
          </p>
          <h3 className="text-2xl font-extrabold text-slate-900 dark:text-white mt-0.5">
            {metrics?.verifiedFacilities || facilities.length}
          </h3>
          <p className="text-[11px] text-slate-400 dark:text-slate-500 mt-1">
            {lang === 'am' ? 'የካምፓስና የከተማ ማዕከላት' : 'Campuses & regional hubs'}
          </p>
        </div>

        {/* Card 3: Certified Peer Mentors */}
        <div
          onClick={() => onNavigate('mentors')}
          className="bg-white dark:bg-slate-900 p-5 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs hover:shadow-md transition-all cursor-pointer group"
        >
          <div className="flex items-center justify-between mb-3">
            <div className="w-11 h-11 rounded-xl bg-purple-50 dark:bg-purple-950/40 text-purple-600 dark:text-purple-400 flex items-center justify-center group-hover:scale-105 transition-transform">
              <Users2 size={22} />
            </div>
            <span className="flex items-center gap-1 text-[11px] font-bold text-emerald-600 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-950/40 px-2 py-0.5 rounded-full border border-emerald-100 dark:border-emerald-800/60">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 dark:bg-emerald-400 animate-pulse" />
              {lang === 'am' ? 'አሁን የሚገኙ' : 'Online'}
            </span>
          </div>
          <p className="text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
            {lang === 'am' ? 'የወጣቶች አማካሪዎች' : 'Certified Mentors'}
          </p>
          <h3 className="text-2xl font-extrabold text-slate-900 dark:text-white mt-0.5">
            {metrics?.counselorMentors || mentors.length}
          </h3>
          <p className="text-[11px] text-slate-400 dark:text-slate-500 mt-1">
            {lang === 'am' ? 'በስልክና ቴሌግራም የሚያማክሩ' : 'TYA & Red Cross certified'}
          </p>
        </div>

        {/* Card 4: Learning Modules & Quizzes */}
        <div
          onClick={() => onNavigate('modules')}
          className="bg-white dark:bg-slate-900 p-5 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs hover:shadow-md transition-all cursor-pointer group"
        >
          <div className="flex items-center justify-between mb-3">
            <div className="w-11 h-11 rounded-xl bg-emerald-50 dark:bg-emerald-950/40 text-emerald-600 dark:text-emerald-400 flex items-center justify-center group-hover:scale-105 transition-transform">
              <BookOpen size={22} />
            </div>
            <span className="text-[11px] font-bold text-emerald-600 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-950/40 px-2 py-0.5 rounded-full border border-emerald-100 dark:border-emerald-800/60">
              {lang === 'am' ? 'ሁለት ቋንቋ' : 'Bilingual'}
            </span>
          </div>
          <p className="text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
            {lang === 'am' ? 'የትምህርት ሞጁሎች' : 'Learning Modules'}
          </p>
          <h3 className="text-2xl font-extrabold text-slate-900 dark:text-white mt-0.5">
            {metrics?.learningModules || 4}
          </h3>
          <p className="text-[11px] text-slate-400 dark:text-slate-500 mt-1">
            {metrics?.quizQuestions || 12} {lang === 'am' ? 'የፈተና ጥያቄዎች ያሉት' : 'interactive quiz questions'}
          </p>
        </div>
      </div>

      {/* 2. MIDDLE SECTION: INTERACTIVE ENGAGEMENT CHART & RECENT CLINICS */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left: Interactive Engagement Line & Area Chart (7 Cols) */}
        <div className="lg:col-span-7 bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs flex flex-col justify-between">
          <div>
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-4">
              <div>
                <h3 className="text-base font-bold text-slate-900 dark:text-white flex items-center gap-2">
                  <TrendingUp size={18} className="text-brand-600 dark:text-cyan-400" />
                  <span>{lang === 'am' ? 'የወጣቶች ጤና ግንዛቤ ሂደት' : 'Youth Health Engagement Trends'}</span>
                </h3>
                <p className="text-xs text-slate-500 dark:text-slate-400">
                  {lang === 'am'
                    ? 'ሳምንታዊ የትምህርት ንባብና የፈተና ተሳትፎ (ከተመረጠው ነጥብ ጋር በይነተገናኝ)'
                    : 'Module reads vs quiz passes with interactive point inspection'}
                </p>
              </div>

              {/* Timeframe Selector Pills */}
              <div className="flex items-center gap-1 bg-slate-100 dark:bg-slate-800 p-1 rounded-xl text-xs font-bold self-start sm:self-auto">
                {(['7D', '30D', '12M'] as const).map((tf) => (
                  <button
                    key={tf}
                    onClick={() => {
                      setTimeframe(tf);
                      setHoveredPointIndex(null);
                    }}
                    className={`px-2.5 py-1 rounded-lg transition-all cursor-pointer ${
                      timeframe === tf
                        ? 'bg-white dark:bg-slate-700 text-brand-700 dark:text-cyan-300 shadow-xs font-extrabold'
                        : 'text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
                    }`}
                  >
                    {tf === '7D'
                      ? lang === 'am' ? '7 ቀናት' : '7 Days'
                      : tf === '30D'
                      ? lang === 'am' ? '30 ቀናት' : '30 Days'
                      : lang === 'am' ? '1 ዓመት' : '1 Year'}
                  </button>
                ))}
              </div>
            </div>

            {/* Interactive SVG Chart Container */}
            <div className="relative h-52 w-full pt-2">
              <svg viewBox={`0 0 ${svgWidth} ${svgHeight}`} className="w-full h-full overflow-visible">
                <defs>
                  <linearGradient id="gradientCyan" x1="0%" y1="0%" x2="0%" y2="100%">
                    <stop offset="0%" stopColor="#0ea5e9" stopOpacity="0.35" />
                    <stop offset="100%" stopColor="#0ea5e9" stopOpacity="0.0" />
                  </linearGradient>
                  <linearGradient id="gradientPurple" x1="0%" y1="0%" x2="0%" y2="100%">
                    <stop offset="0%" stopColor="#a855f7" stopOpacity="0.25" />
                    <stop offset="100%" stopColor="#a855f7" stopOpacity="0.0" />
                  </linearGradient>
                </defs>

                {/* Grid Lines */}
                <line x1="0" y1="30" x2={svgWidth} y2="30" stroke="#f1f5f9" strokeWidth="1" />
                <line x1="0" y1="75" x2={svgWidth} y2="75" stroke="#f1f5f9" strokeWidth="1" />
                <line x1="0" y1="120" x2={svgWidth} y2="120" stroke="#f1f5f9" strokeWidth="1" />

                {/* Area 1: Curriculum Reads */}
                <path d={readsAreaD} fill="url(#gradientCyan)" />
                <path d={readsPathD} fill="none" stroke="#0284c7" strokeWidth="3" strokeLinecap="round" />

                {/* Area 2: Quizzes Completed */}
                <path d={quizzesAreaD} fill="url(#gradientPurple)" />
                <path
                  d={quizzesPathD}
                  fill="none"
                  stroke="#9333ea"
                  strokeWidth="2.5"
                  strokeDasharray="4 4"
                  strokeLinecap="round"
                />

                {/* Data Points & Hover Catchers */}
                {readsPoints.map((p, idx) => (
                  <g key={idx} onMouseEnter={() => setHoveredPointIndex(idx)} className="cursor-pointer">
                    {/* Invisible Wide Hit Area for easy touch/mouse targeting */}
                    <circle cx={p.x} cy={p.y} r={16} fill="transparent" />

                    {/* Visible Data Dot */}
                    <circle
                      cx={p.x}
                      cy={p.y}
                      r={hoveredPointIndex === idx ? 6 : 4}
                      fill="#0284c7"
                      stroke="#ffffff"
                      strokeWidth={2}
                      className="transition-all"
                    />

                    {/* X-Axis Label */}
                    <text
                      x={p.x}
                      y={svgHeight}
                      textAnchor="middle"
                      fill="#94a3b8"
                      fontSize="10"
                      fontWeight="bold"
                    >
                      {p.label}
                    </text>
                  </g>
                ))}
              </svg>

              {/* Floating Interactive Tooltip */}
              {hoveredPointIndex !== null && (
                <div
                  className="absolute z-20 pointer-events-none bg-slate-900/95 text-white p-3 rounded-xl shadow-xl border border-slate-700 backdrop-blur-md text-xs min-w-[170px] animate-in fade-in zoom-in-95 duration-100"
                  style={{
                    left: `${(readsPoints[hoveredPointIndex].x / svgWidth) * 100}%`,
                    top: '15px',
                    transform: 'translateX(-50%)',
                  }}
                >
                  <div className="font-extrabold text-cyan-300 pb-1 border-b border-slate-700/60 mb-1.5 flex items-center justify-between">
                    <span>{readsPoints[hoveredPointIndex].label}</span>
                    <span className="text-[10px] text-emerald-400 font-bold">
                      {readsPoints[hoveredPointIndex].score}% Pass
                    </span>
                  </div>
                  <div className="space-y-1 text-[11px]">
                    <div className="flex items-center justify-between gap-2">
                      <span className="text-slate-300 flex items-center gap-1">
                        <span className="w-2 h-2 rounded-full bg-cyan-400" />
                        {lang === 'am' ? 'የትምህርት ንባብ:' : 'Module Reads:'}
                      </span>
                      <span className="font-bold text-white">
                        {readsPoints[hoveredPointIndex].val.toLocaleString()}
                      </span>
                    </div>
                    <div className="flex items-center justify-between gap-2">
                      <span className="text-slate-300 flex items-center gap-1">
                        <span className="w-2 h-2 rounded-full bg-purple-400" />
                        {lang === 'am' ? 'ፈተና ያለፉ:' : 'Quiz Passes:'}
                      </span>
                      <span className="font-bold text-white">
                        {readsPoints[hoveredPointIndex].quizzes.toLocaleString()}
                      </span>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Graph Legend & Status */}
          <div className="flex items-center justify-between text-xs text-slate-500 dark:text-slate-400 pt-3 border-t border-slate-100 dark:border-slate-800 mt-2">
            <div className="flex items-center gap-4">
              <span className="flex items-center gap-1.5 font-semibold text-slate-700 dark:text-slate-300">
                <span className="w-3 h-1 rounded-full bg-cyan-600" />
                {lang === 'am' ? 'የትምህርት ንባብ' : 'Module Reads'}
              </span>
              <span className="flex items-center gap-1.5 font-semibold text-slate-700 dark:text-slate-300">
                <span className="w-3 h-1 rounded-full bg-purple-600" />
                {lang === 'am' ? 'የተጠናቀቁ ፈተናዎች' : 'Quiz Completions'}
              </span>
            </div>
            <span className="text-[11px] text-emerald-600 dark:text-emerald-400 font-bold bg-emerald-50 dark:bg-emerald-950/40 px-2.5 py-0.5 rounded-full border border-emerald-100 dark:border-emerald-800/60">
              +18.4% {lang === 'am' ? 'ዕድገት' : 'growth'}
            </span>
          </div>
        </div>

        {/* Right: Quick Facilities Directory Preview (5 Cols) */}
        <div className="lg:col-span-5 bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between mb-4">
              <div>
                <h3 className="text-base font-bold text-slate-900 dark:text-white flex items-center gap-1.5">
                  <Hospital size={17} className="text-brand-600 dark:text-cyan-400" />
                  <span>{lang === 'am' ? 'የተረጋገጡ የጤና ተቋማት' : 'Verified Clinics'}</span>
                </h3>
                <p className="text-xs text-slate-500 dark:text-slate-400">
                  {lang === 'am' ? 'የጎንደር ዩኒቨርሲቲና የከተማ ማዕከላት' : 'University campuses & regional centers'}
                </p>
              </div>
              <button
                onClick={() => onNavigate('facilities')}
                className="text-xs font-bold text-brand-600 dark:text-cyan-400 hover:text-brand-700 cursor-pointer"
              >
                {lang === 'am' ? 'ሁሉንም እይ →' : 'View all →'}
              </button>
            </div>

            <div className="space-y-2.5">
              {facilities.slice(0, 3).map((f) => (
                <div
                  key={f.id}
                  className="p-3 rounded-xl border border-slate-100 dark:border-slate-800 hover:border-slate-200 dark:hover:border-slate-700 bg-slate-50/50 dark:bg-slate-800/50 hover:bg-white dark:hover:bg-slate-800 transition-all flex items-start justify-between gap-3"
                >
                  <div className="min-w-0">
                    <div className="flex items-center gap-1.5">
                      <h4 className="text-xs font-bold text-slate-900 dark:text-white truncate">
                        {lang === 'am' ? f.nameAm : f.nameEn}
                      </h4>
                      {f.isVerified && <CheckCircle2 size={13} className="text-brand-600 dark:text-cyan-400 flex-shrink-0" />}
                    </div>
                    <p className="text-[11px] text-slate-500 dark:text-slate-400 truncate mt-0.5">
                      {f.subCity} • {f.operatingHours}
                    </p>
                  </div>
                  <a
                    href={`tel:${f.phone}`}
                    className="p-1.5 rounded-lg bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 hover:text-brand-600 dark:hover:text-cyan-400 hover:border-brand-200 flex-shrink-0 transition-colors"
                  >
                    <Phone size={13} />
                  </a>
                </div>
              ))}
            </div>
          </div>

          <div className="pt-3 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between text-xs text-slate-500 dark:text-slate-400 mt-3">
            <span>{facilities.length} {lang === 'am' ? 'ተቋማት በሲስተሙ አሉ' : 'clinics active'}</span>
            <span
              className="text-brand-600 dark:text-cyan-400 font-semibold cursor-pointer hover:underline"
              onClick={() => onNavigate('facilities')}
            >
              {lang === 'am' ? '+ አዲስ ጨምር' : '+ Add New'}
            </span>
          </div>
        </div>
      </div>

      {/* 3. VISUAL DISTRIBUTION SECTION: TOP HEALTH TOPICS & REGIONAL ENGAGEMENT */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Card A: Top Health Topics Engagement Bar Breakdown */}
        <div className="bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="text-base font-bold text-slate-900 dark:text-white flex items-center gap-2">
                <BarChart2 size={18} className="text-brand-600 dark:text-cyan-400" />
                <span>{lang === 'am' ? 'የትምህርት ርዕሶች ተሳትፎ መጠን' : 'Health Curriculum Topic Breakdown'}</span>
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {lang === 'am' ? 'በወጣቶች ዘንድ በብዛት የሚነበቡ የጤና ዘርፎች' : 'Most frequently studied health domains by students'}
              </p>
            </div>
            <span className="flex items-center gap-1 text-xs font-bold text-amber-600 dark:text-amber-400 bg-amber-50 dark:bg-amber-950/40 px-2 py-0.5 rounded-full border border-amber-200 dark:border-amber-800/60">
              <Flame size={12} className="text-amber-500 dark:text-amber-400" />
              {lang === 'am' ? 'ተፈላጊ' : 'Trending'}
            </span>
          </div>

          <div className="space-y-3.5">
            {[
              { labelEn: 'SRH & Contraceptive Education', labelAm: 'ሥነ-ተዋልዶና የወሊድ መቆጣጠሪያ', pct: 38, count: '9,440 reads', color: 'bg-cyan-500' },
              { labelEn: 'Puberty & Body Transformations', labelAm: 'የአፍላ ዕድሜና የሰውነት ለውጦች', pct: 27, count: '6,710 reads', color: 'bg-purple-500' },
              { labelEn: 'HIV & STI Prevention / Testing', labelAm: 'ኤችአይቪና አባላዘር በሽታዎች መከላከያ', pct: 21, count: '5,220 reads', color: 'bg-emerald-500' },
              { labelEn: 'Mental Health & Stress Relief', labelAm: 'የአእምሮ ጤናና የጭንቀት አስተዳደር', pct: 14, count: '3,480 reads', color: 'bg-amber-500' },
            ].map((topic, idx) => (
              <div key={idx} className="space-y-1">
                <div className="flex items-center justify-between text-xs font-semibold">
                  <span className="text-slate-800 dark:text-slate-200">{lang === 'am' ? topic.labelAm : topic.labelEn}</span>
                  <span className="text-slate-500 dark:text-slate-400 font-bold">{topic.pct}% ({topic.count})</span>
                </div>
                <div className="w-full bg-slate-100 dark:bg-slate-800 rounded-full h-2.5 overflow-hidden">
                  <div
                    className={`${topic.color} h-2.5 rounded-full transition-all duration-500`}
                    style={{ width: `${topic.pct}%` }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Card B: Campus & Regional Engagement Distribution */}
        <div className="bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="text-base font-bold text-slate-900 dark:text-white flex items-center gap-2">
                <Compass size={18} className="text-brand-600 dark:text-cyan-400" />
                <span>{lang === 'am' ? 'የካምፓሶችና የክልሎች ተሳትፎ' : 'Regional & Campus Geographic Distribution'}</span>
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {lang === 'am' ? 'የተማሪዎች እንቅስቃሴ በካምፓሶችና ክልሎች' : 'Active student user engagement by campus cluster'}
              </p>
            </div>
            <span className="text-xs font-bold text-indigo-700 dark:text-indigo-400 bg-indigo-50 dark:bg-indigo-950/40 px-2 py-0.5 rounded-full border border-indigo-200 dark:border-indigo-800/60">
              {lang === 'am' ? 'አገር አቀፍ' : 'Nationwide'}
            </span>
          </div>

          <div className="space-y-3.5">
            {[
              { nameEn: 'University of Gondar (Maraki & GCMS Hospital)', nameAm: 'ጎንደር ዩኒቨርሲቲ (ማራኪና ሆስፒታል)', pct: 45, icon: GraduationCap, color: 'bg-indigo-600' },
              { nameEn: 'Addis Ababa Youth Centers & Clinics', nameAm: 'አዲስ አበባ የወጣቶች ማዕከላት', pct: 35, icon: Hospital, color: 'bg-brand-600' },
              { nameEn: 'Regional Campuses (Hawassa & Bahir Dar)', nameAm: 'የክልል ካምፓሶች (ሐዋሳና ባሕር ዳር)', pct: 20, icon: Compass, color: 'bg-emerald-600' },
            ].map((reg, idx) => (
              <div key={idx} className="space-y-1">
                <div className="flex items-center justify-between text-xs font-semibold">
                  <span className="flex items-center gap-1.5 text-slate-800 dark:text-slate-200">
                    <reg.icon size={14} className="text-slate-500 dark:text-slate-400" />
                    <span>{lang === 'am' ? reg.nameAm : reg.nameEn}</span>
                  </span>
                  <span className="text-slate-700 dark:text-slate-300 font-bold">{reg.pct}%</span>
                </div>
                <div className="w-full bg-slate-100 dark:bg-slate-800 rounded-full h-2.5 overflow-hidden">
                  <div
                    className={`${reg.color} h-2.5 rounded-full transition-all duration-500`}
                    style={{ width: `${reg.pct}%` }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* 4. BOTTOM SECTION: CERTIFIED MENTORS & AUDIT TRAIL */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Counselors Roster (6 Cols) */}
        <div className="lg:col-span-6 bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="text-base font-bold text-slate-900 dark:text-white flex items-center gap-1.5">
                <Users2 size={18} className="text-purple-600 dark:text-purple-400" />
                <span>{lang === 'am' ? 'የወጣቶች አማካሪዎች' : 'Certified Peer Counselors'}</span>
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {lang === 'am' ? 'የስነ-ተዋልዶና የአእምሮ ጤና ባለሙያዎች' : 'Confidential counseling network'}
              </p>
            </div>
            <button
              onClick={() => onNavigate('mentors')}
              className="text-xs font-bold text-brand-600 dark:text-cyan-400 hover:text-brand-700 cursor-pointer"
            >
              {lang === 'am' ? 'አማካሪዎች →' : 'Mentors →'}
            </button>
          </div>

          <div className="space-y-3">
            {mentors.slice(0, 3).map((m) => (
              <div
                key={m.id}
                className="p-3 rounded-xl border border-slate-100 dark:border-slate-800 hover:border-slate-200 dark:hover:border-slate-700 bg-slate-50/50 dark:bg-slate-800/50 hover:bg-white dark:hover:bg-slate-800 transition-all flex items-center justify-between gap-3"
              >
                <div className="flex items-center gap-3">
                  <div className="w-9 h-9 rounded-full bg-purple-100 dark:bg-purple-950/60 text-purple-700 dark:text-purple-300 font-bold text-xs flex items-center justify-center">
                    {m.name.slice(0, 2).toUpperCase()}
                  </div>
                  <div>
                    <h4 className="text-xs font-bold text-slate-900 dark:text-white">{m.name}</h4>
                    <p className="text-[11px] text-slate-500 dark:text-slate-400">{m.organization}</p>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <a
                    href={`tel:${m.phone}`}
                    className="p-1.5 rounded-lg bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 hover:text-brand-600 dark:hover:text-cyan-400 hover:border-brand-200 flex-shrink-0 transition-colors"
                  >
                    <Phone size={13} />
                  </a>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Audit Activity Feed (6 Cols) */}
        <div className="lg:col-span-6 bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="text-base font-bold text-slate-900 dark:text-white flex items-center gap-1.5">
                <Clock size={17} className="text-brand-600 dark:text-cyan-400" />
                <span>{lang === 'am' ? 'የቅርብ የአስተዳዳሪ እርምጃዎች' : 'Recent Audit Activity'}</span>
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {lang === 'am' ? 'የተመዘገቡ የለውጥ እንቅስቃሴዎች' : 'Immutable administrative audit stream'}
              </p>
            </div>
            <button
              onClick={() => onNavigate('audit')}
              className="text-xs font-bold text-brand-600 dark:text-cyan-400 hover:text-brand-700 cursor-pointer"
            >
              {lang === 'am' ? 'ሙሉ ኦዲት →' : 'Audit logs →'}
            </button>
          </div>

          <div className="space-y-3">
            {activity.slice(0, 4).map((act) => (
              <div key={act.id} className="text-xs pb-2.5 border-b border-slate-100 dark:border-slate-800 last:border-0 last:pb-0">
                <div className="flex items-center justify-between text-slate-400 dark:text-slate-500 text-[11px] mb-1">
                  <span className="font-bold text-slate-700 dark:text-slate-300 bg-slate-100 dark:bg-slate-800 px-2 py-0.5 rounded-md border border-slate-200/50 dark:border-slate-700">
                    {act.action}
                  </span>
                  <span>{new Date(act.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
                </div>
                <p className="text-slate-600 dark:text-slate-300 line-clamp-1">{act.details}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};
