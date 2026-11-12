import React, { useState, useEffect, useMemo } from 'react';
import {
  BarChart2,
  BookOpen,
  RefreshCw,
  Download,
  Users,
  Hospital,
  Accessibility,
  GraduationCap,
  CheckCircle2,
  XCircle,
  AlertCircle,
  Search,
  ShieldCheck,
  Calendar,
  Layers,
} from 'lucide-react';
import { api } from '../services/api.js';
import {
  BaselineSurveyStats,
  BaselineSurveySubmission,
  LearningAssessment,
  Module,
} from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';
import { LearningAssessmentsPage } from './LearningAssessmentsPage.js';

interface AssessmentsPageProps {
  modules: Module[];
  assessments: LearningAssessment[];
  lang: 'en' | 'am';
  onSaveAssessment: (data: {
    moduleId: string;
    questions: Array<{
      promptEn: string;
      promptAm: string;
      choices: Array<{ labelEn: string; labelAm: string; score: number }>;
    }>;
  }) => Promise<void>;
  onDeleteAssessment: (id: string) => Promise<void>;
}

export const AssessmentsPage: React.FC<AssessmentsPageProps> = ({
  modules,
  assessments,
  lang,
  onSaveAssessment,
  onDeleteAssessment,
}) => {
  const [activeSubTab, setActiveSubTab] = useState<'baseline' | 'modules'>('baseline');
  const [surveyStats, setSurveyStats] = useState<BaselineSurveyStats | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [refreshing, setRefreshing] = useState<boolean>(false);
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [srhFilter, setSrhFilter] = useState<'ALL' | 'YES' | 'NO' | 'NOT_SURE'>('ALL');

  const isAm = lang === 'am';

  const loadStats = async (isManualRefresh = false) => {
    if (isManualRefresh) setRefreshing(true);
    else setLoading(true);

    try {
      const data = await api.getSurveyStats();
      setSurveyStats(data);
    } catch (err) {
      console.error('Failed to load baseline survey stats:', err);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  useEffect(() => {
    loadStats();
  }, []);

  // Filtered submissions
  const filteredSubmissions = useMemo(() => {
    if (!surveyStats?.recentSubmissions) return [];
    return surveyStats.recentSubmissions.filter((sub) => {
      const matchSrh = srhFilter === 'ALL' || sub.knowsGondarSrh === srhFilter;
      const matchSearch =
        searchQuery.trim() === '' ||
        sub.ageGroup.toLowerCase().includes(searchQuery.toLowerCase()) ||
        sub.yearOfStudy.toLowerCase().includes(searchQuery.toLowerCase()) ||
        sub.disabilityNeed.toLowerCase().includes(searchQuery.toLowerCase());
      return matchSrh && matchSearch;
    });
  }, [surveyStats?.recentSubmissions, srhFilter, searchQuery]);

  // Key KPI Computations
  const totalSubmissions = surveyStats?.totalResponses || 0;

  const awareCount =
    surveyStats?.breakdown.byGondarSrhAwareness.find((i) => i.knowsGondarSrh === 'YES')?.count || 0;
  const awarePercent = totalSubmissions > 0 ? Math.round((awareCount / totalSubmissions) * 100) : 0;

  const needAssistanceCount =
    surveyStats?.breakdown.byDisabilityNeed
      .filter((i) => i.disabilityNeed !== 'NONE' && i.disabilityNeed !== 'PREFER_NOT_TO_SAY')
      .reduce((acc, curr) => acc + curr.count, 0) || 0;
  const needAssistancePercent =
    totalSubmissions > 0 ? Math.round((needAssistanceCount / totalSubmissions) * 100) : 0;

  const topAge = surveyStats?.breakdown.byAge[0]?.ageGroup || '—';
  const topYear = surveyStats?.breakdown.byYearOfStudy[0]?.yearOfStudy || '—';

  // Export CSV
  const handleExportCsv = () => {
    if (!surveyStats?.recentSubmissions || surveyStats.recentSubmissions.length === 0) {
      alert(isAm ? 'ለማውረድ የሚገኝ መረጃ የለም' : 'No survey submissions to export.');
      return;
    }

    exportToCsv<BaselineSurveySubmission>(
      'student_baseline_surveys',
      [
        { header: 'ID (Anonymous)', accessor: (i) => i.id },
        { header: 'Submission Time', accessor: (i) => new Date(i.submittedAt).toLocaleString() },
        { header: 'Age Group', accessor: (i) => i.ageGroup },
        { header: 'Year of Study', accessor: (i) => i.yearOfStudy },
        { header: 'Accessibility / Disability', accessor: (i) => i.disabilityNeed },
        { header: 'Gondar SRH Aware', accessor: (i) => i.knowsGondarSrh },
        { header: 'Privacy Status', accessor: () => '100% Anonymous (Zero PII)' },
      ],
      surveyStats.recentSubmissions
    );
  };

  return (
    <div className="space-y-6">
      {/* 1. Header with Breadcrumbs & Action Controls */}
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <div className="flex items-center gap-2 text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            <span>{isAm ? 'አስተዳደር' : 'Yegna Admin'}</span>
            <span>/</span>
            <span className="text-sky-600 dark:text-sky-400">{isAm ? 'ምዘናዎች እና ቅኝቶች' : 'Assessments'}</span>
          </div>
          <h1 className="mt-1 text-2xl font-black text-slate-900 dark:text-white">
            {isAm ? 'የተማሪዎች ምዘና ማዕከል' : 'Assessments & Student Surveys'}
          </h1>
          <p className="mt-0.5 text-sm text-slate-500 dark:text-slate-400">
            {isAm
              ? 'የተማሪዎች አጠቃላይ የመግቢያ ቅኝት እና የሞጁል ትምህርት ምዘናዎች'
              : 'Anonymous student baseline insights and curriculum learning assessments'}
          </p>
        </div>

        {/* Top Segmented Tab Switcher */}
        <div className="flex flex-wrap items-center gap-2">
          <div className="inline-flex rounded-xl bg-slate-200/80 p-1 dark:bg-slate-800">
            <button
              onClick={() => setActiveSubTab('baseline')}
              className={`inline-flex items-center gap-2 rounded-lg px-3.5 py-1.5 text-xs font-bold transition-all ${
                activeSubTab === 'baseline'
                  ? 'bg-white text-slate-900 shadow-sm dark:bg-slate-700 dark:text-white'
                  : 'text-slate-600 hover:text-slate-900 dark:text-slate-400 dark:hover:text-white'
              }`}
            >
              <BarChart2 size={15} className="text-emerald-500" />
              {isAm ? 'የመግቢያ አጠቃላይ ቅኝት' : 'General Baseline Survey'}
            </button>
            <button
              onClick={() => setActiveSubTab('modules')}
              className={`inline-flex items-center gap-2 rounded-lg px-3.5 py-1.5 text-xs font-bold transition-all ${
                activeSubTab === 'modules'
                  ? 'bg-white text-slate-900 shadow-sm dark:bg-slate-700 dark:text-white'
                  : 'text-slate-600 hover:text-slate-900 dark:text-slate-400 dark:hover:text-white'
              }`}
            >
              <BookOpen size={15} className="text-sky-500" />
              {isAm ? 'የትምህርት ሞጁል ምዘናዎች' : 'Module Assessments'}
            </button>
          </div>

          {activeSubTab === 'baseline' && (
            <div className="flex items-center gap-2">
              <button
                onClick={() => loadStats(true)}
                disabled={refreshing}
                className="inline-flex items-center gap-1.5 rounded-xl border border-slate-300 bg-white px-3 py-1.5 text-xs font-semibold text-slate-700 shadow-sm transition hover:bg-slate-50 disabled:opacity-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 dark:hover:bg-slate-700"
                title="Refresh Live Data"
              >
                <RefreshCw size={14} className={refreshing ? 'animate-spin text-sky-500' : ''} />
                <span className="hidden sm:inline">{isAm ? 'አድስ' : 'Refresh'}</span>
              </button>
              <button
                onClick={handleExportCsv}
                className="inline-flex items-center gap-1.5 rounded-xl bg-slate-900 px-3.5 py-1.5 text-xs font-semibold text-white shadow-sm transition hover:bg-slate-800 dark:bg-emerald-600 dark:hover:bg-emerald-700"
              >
                <Download size={14} />
                <span>{isAm ? 'CSV አውርድ' : 'Export CSV'}</span>
              </button>
            </div>
          )}
        </div>
      </div>

      {/* 2. SUB-TAB CONTENT */}
      {activeSubTab === 'modules' ? (
        // Tab 2: Abel's Module Learning Assessments Page
        <LearningAssessmentsPage
          modules={modules}
          assessments={assessments}
          lang={lang}
          onSave={onSaveAssessment}
          onDelete={onDeleteAssessment}
        />
      ) : (
        // Tab 1: General Baseline Survey Analytics
        <div className="space-y-6">
          {/* Top 4 KPI Stat Cards */}
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
            {/* KPI 1: Total Respondents */}
            <div className="relative overflow-hidden rounded-2xl border border-slate-200/80 bg-white p-5 shadow-sm transition-all hover:shadow-md dark:border-slate-800 dark:bg-slate-900">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
                  {isAm ? 'ጠቅላላ ምላሽ ሰጪዎች' : 'Total Respondents'}
                </span>
                <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-emerald-500/10 text-emerald-600 dark:bg-emerald-500/20 dark:text-emerald-400">
                  <Users size={18} />
                </div>
              </div>
              <div className="mt-3 flex items-baseline gap-2">
                <span className="text-3xl font-black text-slate-900 dark:text-white">
                  {loading ? '...' : totalSubmissions}
                </span>
                <span className="rounded-md bg-emerald-100 px-1.5 py-0.5 text-[11px] font-bold text-emerald-700 dark:bg-emerald-950/60 dark:text-emerald-400">
                  {isAm ? 'ተማሪዎች' : 'Students'}
                </span>
              </div>
              <p className="mt-1 text-xs text-slate-500 dark:text-slate-400">
                {isAm ? '100% ማንነትን ሳይገልጽ የተሰበሰበ' : 'Zero-Knowledge Verified Anonymous'}
              </p>
            </div>

            {/* KPI 2: Gondar Clinic Awareness */}
            <div className="relative overflow-hidden rounded-2xl border border-slate-200/80 bg-white p-5 shadow-sm transition-all hover:shadow-md dark:border-slate-800 dark:bg-slate-900">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
                  {isAm ? 'የጎንደር ክሊኒክ ግንዛቤ' : 'Clinic Awareness Rate'}
                </span>
                <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-sky-500/10 text-sky-600 dark:bg-sky-500/20 dark:text-sky-400">
                  <Hospital size={18} />
                </div>
              </div>
              <div className="mt-3 flex items-baseline gap-2">
                <span className="text-3xl font-black text-slate-900 dark:text-white">
                  {loading ? '...' : `${awarePercent}%`}
                </span>
                <span
                  className={`rounded-md px-1.5 py-0.5 text-[11px] font-bold ${
                    awarePercent >= 50
                      ? 'bg-emerald-100 text-emerald-700 dark:bg-emerald-950/60 dark:text-emerald-400'
                      : 'bg-rose-100 text-rose-700 dark:bg-rose-950/60 dark:text-rose-400'
                  }`}
                >
                  {awarePercent >= 50 ? (isAm ? 'ጥሩ ደረጃ' : 'High') : (isAm ? 'ትኩረት ያስፈልጋል' : 'Needs Outreach')}
                </span>
              </div>
              <p className="mt-1 text-xs text-slate-500 dark:text-slate-400">
                {isAm
                  ? `${totalSubmissions - awareCount} ተማሪዎች አገልግሎቱ የሚገኝበትን አያውቁም`
                  : `${totalSubmissions - awareCount} students unaware of campus clinic`}
              </p>
            </div>

            {/* KPI 3: Accessibility Needs */}
            <div className="relative overflow-hidden rounded-2xl border border-slate-200/80 bg-white p-5 shadow-sm transition-all hover:shadow-md dark:border-slate-800 dark:bg-slate-900">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
                  {isAm ? 'የተደራሽነት ድጋፍ ፈላጊ' : 'Accessibility Support'}
                </span>
                <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-purple-500/10 text-purple-600 dark:bg-purple-500/20 dark:text-purple-400">
                  <Accessibility size={18} />
                </div>
              </div>
              <div className="mt-3 flex items-baseline gap-2">
                <span className="text-3xl font-black text-slate-900 dark:text-white">
                  {loading ? '...' : `${needAssistancePercent}%`}
                </span>
                <span className="rounded-md bg-purple-100 px-1.5 py-0.5 text-[11px] font-bold text-purple-700 dark:bg-purple-950/60 dark:text-purple-400">
                  {needAssistanceCount} {isAm ? 'ተማሪዎች' : 'Students'}
                </span>
              </div>
              <p className="mt-1 text-xs text-slate-500 dark:text-slate-400">
                {isAm ? 'የእይታ፣ መስማት ወይም የእንቅስቃሴ ድጋፍ' : 'Visual, hearing, or mobility needs'}
              </p>
            </div>

            {/* KPI 4: Primary Demographic */}
            <div className="relative overflow-hidden rounded-2xl border border-slate-200/80 bg-white p-5 shadow-sm transition-all hover:shadow-md dark:border-slate-800 dark:bg-slate-900">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
                  {isAm ? 'ዋና የተማሪ ስብስብ' : 'Primary Cohort'}
                </span>
                <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-amber-500/10 text-amber-600 dark:bg-amber-500/20 dark:text-amber-400">
                  <GraduationCap size={18} />
                </div>
              </div>
              <div className="mt-3 flex items-baseline gap-2">
                <span className="text-xl font-black text-slate-900 dark:text-white">
                  {loading ? '...' : topAge}
                </span>
                <span className="rounded-md bg-amber-100 px-1.5 py-0.5 text-[11px] font-bold text-amber-700 dark:bg-amber-950/60 dark:text-amber-400">
                  {topYear}
                </span>
              </div>
              <p className="mt-1 text-xs text-slate-500 dark:text-slate-400">
                {isAm ? 'በጣም የተወከለው የዕድሜ እና የትምህርት ደረጃ' : 'Most represented student cohort'}
              </p>
            </div>
          </div>

          {/* 3. The 4 Question Breakdown Cards Grid */}
          <div className="grid grid-cols-1 gap-5 lg:grid-cols-2">
            {/* Q1: Age Group Breakdown */}
            <div className="rounded-2xl border border-slate-200/80 bg-white p-5 shadow-sm dark:border-slate-800 dark:bg-slate-900">
              <div className="flex items-center justify-between border-b border-slate-100 pb-3 dark:border-slate-800">
                <div className="flex items-center gap-2">
                  <span className="flex h-6 w-6 items-center justify-center rounded-lg bg-emerald-100 text-xs font-bold text-emerald-700 dark:bg-emerald-950 dark:text-emerald-400">
                    Q1
                  </span>
                  <h3 className="font-extrabold text-slate-900 dark:text-white">
                    {isAm ? 'ዕድሜዎ ስንት ነው? (የዕድሜ ክፍፍል)' : 'What is your age? (Age Distribution)'}
                  </h3>
                </div>
                <span className="text-xs text-slate-500">
                  {surveyStats?.breakdown.byAge.length || 0} {isAm ? 'ምድቦች' : 'Tiers'}
                </span>
              </div>

              <div className="mt-4 space-y-3.5">
                {surveyStats?.breakdown.byAge.map((item) => (
                  <div key={item.ageGroup} className="space-y-1">
                    <div className="flex items-center justify-between text-xs font-bold">
                      <span className="text-slate-700 dark:text-slate-300">{item.ageGroup}</span>
                      <span className="text-slate-500 dark:text-slate-400">
                        {item.count} {isAm ? 'ተማሪ' : 'students'} ({item.percentage}%)
                      </span>
                    </div>
                    <div className="h-2.5 w-full overflow-hidden rounded-full bg-slate-100 dark:bg-slate-800">
                      <div
                        className="h-full rounded-full bg-gradient-to-r from-emerald-500 to-teal-400 transition-all duration-500"
                        style={{ width: `${Math.max(item.percentage, 3)}%` }}
                      />
                    </div>
                  </div>
                )) || <div className="py-4 text-center text-xs text-slate-400">{isAm ? 'መረጃ የለም' : 'No data yet'}</div>}
              </div>
            </div>

            {/* Q2: Current Year of Study */}
            <div className="rounded-2xl border border-slate-200/80 bg-white p-5 shadow-sm dark:border-slate-800 dark:bg-slate-900">
              <div className="flex items-center justify-between border-b border-slate-100 pb-3 dark:border-slate-800">
                <div className="flex items-center gap-2">
                  <span className="flex h-6 w-6 items-center justify-center rounded-lg bg-sky-100 text-xs font-bold text-sky-700 dark:bg-sky-950 dark:text-sky-400">
                    Q2
                  </span>
                  <h3 className="font-extrabold text-slate-900 dark:text-white">
                    {isAm ? 'በምን ዓመት የትምህርት ደረጃ ላይ ይገኛሉ?' : 'Current Year of Study'}
                  </h3>
                </div>
                <span className="text-xs text-slate-500">
                  {surveyStats?.breakdown.byYearOfStudy.length || 0} {isAm ? 'ደረጃዎች' : 'Levels'}
                </span>
              </div>

              <div className="mt-4 space-y-3.5">
                {surveyStats?.breakdown.byYearOfStudy.map((item) => (
                  <div key={item.yearOfStudy} className="space-y-1">
                    <div className="flex items-center justify-between text-xs font-bold">
                      <span className="text-slate-700 dark:text-slate-300">{item.yearOfStudy}</span>
                      <span className="text-slate-500 dark:text-slate-400">
                        {item.count} {isAm ? 'ተማሪ' : 'students'} ({item.percentage}%)
                      </span>
                    </div>
                    <div className="h-2.5 w-full overflow-hidden rounded-full bg-slate-100 dark:bg-slate-800">
                      <div
                        className="h-full rounded-full bg-gradient-to-r from-sky-500 to-indigo-500 transition-all duration-500"
                        style={{ width: `${Math.max(item.percentage, 3)}%` }}
                      />
                    </div>
                  </div>
                )) || <div className="py-4 text-center text-xs text-slate-400">{isAm ? 'መረጃ የለም' : 'No data yet'}</div>}
              </div>
            </div>

            {/* Q3: Disability & Accessibility Needs */}
            <div className="rounded-2xl border border-slate-200/80 bg-white p-5 shadow-sm dark:border-slate-800 dark:bg-slate-900">
              <div className="flex items-center justify-between border-b border-slate-100 pb-3 dark:border-slate-800">
                <div className="flex items-center gap-2">
                  <span className="flex h-6 w-6 items-center justify-center rounded-lg bg-purple-100 text-xs font-bold text-purple-700 dark:bg-purple-950 dark:text-purple-400">
                    Q3
                  </span>
                  <h3 className="font-extrabold text-slate-900 dark:text-white">
                    {isAm ? 'የተለየ የተደራሽነት ድጋፍ ፍላጎት' : 'Disability & Accessibility Needs'}
                  </h3>
                </div>
                <span className="text-xs text-slate-500">
                  {needAssistanceCount} {isAm ? 'ድጋፍ ፈላጊ' : 'Requested'}
                </span>
              </div>

              <div className="mt-4 space-y-3.5">
                {surveyStats?.breakdown.byDisabilityNeed.map((item) => {
                  const isNone = item.disabilityNeed === 'NONE';
                  return (
                    <div key={item.disabilityNeed} className="space-y-1">
                      <div className="flex items-center justify-between text-xs font-bold">
                        <span className="flex items-center gap-1.5 text-slate-700 dark:text-slate-300">
                          <span
                            className={`h-2 w-2 rounded-full ${
                              isNone ? 'bg-emerald-500' : 'bg-purple-500'
                            }`}
                          />
                          {item.disabilityNeed}
                        </span>
                        <span className="text-slate-500 dark:text-slate-400">
                          {item.count} ({item.percentage}%)
                        </span>
                      </div>
                      <div className="h-2.5 w-full overflow-hidden rounded-full bg-slate-100 dark:bg-slate-800">
                        <div
                          className={`h-full rounded-full transition-all duration-500 ${
                            isNone
                              ? 'bg-slate-400 dark:bg-slate-600'
                              : 'bg-gradient-to-r from-purple-500 to-pink-500'
                          }`}
                          style={{ width: `${Math.max(item.percentage, 3)}%` }}
                        />
                      </div>
                    </div>
                  );
                }) || <div className="py-4 text-center text-xs text-slate-400">{isAm ? 'መረጃ የለም' : 'No data yet'}</div>}
              </div>
            </div>

            {/* Q4: Gondar SRH Service Awareness */}
            <div className="rounded-2xl border border-slate-200/80 bg-white p-5 shadow-sm dark:border-slate-800 dark:bg-slate-900">
              <div className="flex items-center justify-between border-b border-slate-100 pb-3 dark:border-slate-800">
                <div className="flex items-center gap-2">
                  <span className="flex h-6 w-6 items-center justify-center rounded-lg bg-rose-100 text-xs font-bold text-rose-700 dark:bg-rose-950 dark:text-rose-400">
                    Q4
                  </span>
                  <h3 className="font-extrabold text-slate-900 dark:text-white">
                    {isAm
                      ? 'የጎንደር ዩኒቨርሲቲ የስነ-ተዋልዶ ጤና አገልግሎት ግንዛቤ'
                      : 'University of Gondar SRH Awareness'}
                  </h3>
                </div>
                <span className="rounded-md bg-rose-50 px-2 py-0.5 text-xs font-bold text-rose-600 dark:bg-rose-950/50 dark:text-rose-300">
                  {awarePercent}% {isAm ? 'ግንዛቤ አላቸው' : 'Awareness'}
                </span>
              </div>

              <div className="mt-4 space-y-3.5">
                {surveyStats?.breakdown.byGondarSrhAwareness.map((item) => {
                  const isYes = item.knowsGondarSrh === 'YES';
                  const isNo = item.knowsGondarSrh === 'NO';
                  return (
                    <div key={item.knowsGondarSrh} className="space-y-1">
                      <div className="flex items-center justify-between text-xs font-bold">
                        <span className="flex items-center gap-1.5 text-slate-700 dark:text-slate-300">
                          {isYes && <CheckCircle2 size={13} className="text-emerald-500" />}
                          {isNo && <XCircle size={13} className="text-rose-500" />}
                          {!isYes && !isNo && <AlertCircle size={13} className="text-amber-500" />}
                          {item.knowsGondarSrh === 'YES'
                            ? isAm
                              ? 'አዎ አውቃለሁ (Yes)'
                              : 'Yes, I know'
                            : item.knowsGondarSrh === 'NO'
                            ? isAm
                              ? 'አልያውቅም (No)'
                              : 'No, not yet'
                            : isAm
                            ? 'እርግጠኛ አይደለሁም (Not sure)'
                            : 'Not sure'}
                        </span>
                        <span className="text-slate-500 dark:text-slate-400">
                          {item.count} ({item.percentage}%)
                        </span>
                      </div>
                      <div className="h-2.5 w-full overflow-hidden rounded-full bg-slate-100 dark:bg-slate-800">
                        <div
                          className={`h-full rounded-full transition-all duration-500 ${
                            isYes
                              ? 'bg-gradient-to-r from-emerald-500 to-teal-400'
                              : isNo
                              ? 'bg-gradient-to-r from-rose-500 to-red-400'
                              : 'bg-gradient-to-r from-amber-500 to-yellow-400'
                          }`}
                          style={{ width: `${Math.max(item.percentage, 3)}%` }}
                        />
                      </div>
                    </div>
                  );
                }) || <div className="py-4 text-center text-xs text-slate-400">{isAm ? 'መረጃ የለም' : 'No data yet'}</div>}
              </div>
            </div>
          </div>

          {/* 4. Recent Anonymous Submissions Table */}
          <div className="overflow-hidden rounded-2xl border border-slate-200/80 bg-white shadow-sm dark:border-slate-800 dark:bg-slate-900">
            {/* Table Header & Controls */}
            <div className="flex flex-col gap-3 border-b border-slate-100 p-5 sm:flex-row sm:items-center sm:justify-between dark:border-slate-800">
              <div className="flex items-center gap-2">
                <Layers size={18} className="text-sky-500" />
                <h3 className="font-extrabold text-slate-900 dark:text-white">
                  {isAm ? 'የቅርብ ጊዜ ማንነት-የማይገልጹ ምላሾች' : 'Recent Anonymous Submissions'}
                </h3>
                <span className="rounded-full bg-slate-100 px-2.5 py-0.5 text-xs font-bold text-slate-600 dark:bg-slate-800 dark:text-slate-300">
                  {filteredSubmissions.length}
                </span>
              </div>

              {/* Filters & Search */}
              <div className="flex flex-wrap items-center gap-2">
                <div className="relative">
                  <Search
                    size={14}
                    className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400"
                  />
                  <input
                    type="text"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    placeholder={isAm ? 'በዕድሜ/ደረጃ ፈልግ...' : 'Search submissions...'}
                    className="rounded-xl border border-slate-200 bg-slate-50 py-1.5 pl-8 pr-3 text-xs text-slate-900 outline-none transition focus:border-sky-500 focus:bg-white dark:border-slate-700 dark:bg-slate-800 dark:text-white"
                  />
                </div>

                <select
                  value={srhFilter}
                  onChange={(e) => setSrhFilter(e.target.value as any)}
                  className="rounded-xl border border-slate-200 bg-slate-50 px-2.5 py-1.5 text-xs font-semibold text-slate-700 outline-none dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200"
                >
                  <option value="ALL">{isAm ? 'ሁሉንም ግንዛቤዎች' : 'All Awareness'}</option>
                  <option value="YES">{isAm ? 'ያወቁ (Yes)' : 'Aware (Yes)'}</option>
                  <option value="NO">{isAm ? 'ያላወቁ (No)' : 'Unaware (No)'}</option>
                  <option value="NOT_SURE">{isAm ? 'እርግጠኛ ያልሆኑ' : 'Not Sure'}</option>
                </select>
              </div>
            </div>

            {/* Table Rows */}
            <div className="overflow-x-auto">
              <table className="w-full text-left text-xs">
                <thead className="border-b border-slate-100 bg-slate-50/75 text-[11px] font-bold uppercase tracking-wider text-slate-500 dark:border-slate-800 dark:bg-slate-800/40 dark:text-slate-400">
                  <tr>
                    <th className="py-3 pl-5 pr-3">{isAm ? 'የገባበት ቀን' : 'Timestamp'}</th>
                    <th className="px-3 py-3">{isAm ? 'ዕድሜ' : 'Age Group'}</th>
                    <th className="px-3 py-3">{isAm ? 'የትምህርት ዓመት' : 'Year of Study'}</th>
                    <th className="px-3 py-3">{isAm ? 'የተደራሽነት ድጋፍ' : 'Accessibility Need'}</th>
                    <th className="px-3 py-3">{isAm ? 'የጎንደር ክሊኒክ ግንዛቤ' : 'Gondar SRH Aware'}</th>
                    <th className="py-3 pl-3 pr-5">{isAm ? 'የግላዊነት ሁኔታ' : 'Privacy Protection'}</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
                  {filteredSubmissions.length > 0 ? (
                    filteredSubmissions.map((sub) => {
                      const isYes = sub.knowsGondarSrh === 'YES';
                      const isNo = sub.knowsGondarSrh === 'NO';
                      return (
                        <tr
                          key={sub.id}
                          className="transition hover:bg-slate-50/80 dark:hover:bg-slate-800/40"
                        >
                          <td className="py-3.5 pl-5 pr-3 font-mono text-[11px] text-slate-500 dark:text-slate-400">
                            <span className="flex items-center gap-1.5">
                              <Calendar size={13} className="text-slate-400" />
                              {new Date(sub.submittedAt).toLocaleDateString()}{' '}
                              {new Date(sub.submittedAt).toLocaleTimeString([], {
                                hour: '2-digit',
                                minute: '2-digit',
                              })}
                            </span>
                          </td>
                          <td className="px-3 py-3.5 font-bold text-slate-800 dark:text-slate-200">
                            <span className="rounded-md bg-slate-100 px-2 py-0.5 text-xs font-bold text-slate-700 dark:bg-slate-800 dark:text-slate-300">
                              {sub.ageGroup}
                            </span>
                          </td>
                          <td className="px-3 py-3.5 text-slate-700 dark:text-slate-300">
                            {sub.yearOfStudy}
                          </td>
                          <td className="px-3 py-3.5">
                            <span
                              className={`rounded-md px-2 py-0.5 text-xs font-semibold ${
                                sub.disabilityNeed === 'NONE'
                                  ? 'text-slate-500'
                                  : 'bg-purple-50 text-purple-700 dark:bg-purple-950/60 dark:text-purple-300'
                              }`}
                            >
                              {sub.disabilityNeed}
                            </span>
                          </td>
                          <td className="px-3 py-3.5">
                            <span
                              className={`inline-flex items-center gap-1 rounded-full px-2.5 py-0.5 text-[11px] font-bold ${
                                isYes
                                  ? 'bg-emerald-50 text-emerald-700 dark:bg-emerald-950/50 dark:text-emerald-400'
                                  : isNo
                                  ? 'bg-rose-50 text-rose-700 dark:bg-rose-950/50 dark:text-rose-400'
                                  : 'bg-amber-50 text-amber-700 dark:bg-amber-950/50 dark:text-amber-400'
                              }`}
                            >
                              {isYes ? '✓ Yes' : isNo ? '✕ No' : '• Not Sure'}
                            </span>
                          </td>
                          <td className="py-3.5 pl-3 pr-5">
                            <span className="inline-flex items-center gap-1.5 text-[11px] font-semibold text-emerald-600 dark:text-emerald-400">
                              <ShieldCheck size={14} />
                              100% Anonymous (Zero PII)
                            </span>
                          </td>
                        </tr>
                      );
                    })
                  ) : (
                    <tr>
                      <td colSpan={6} className="py-10 text-center text-xs text-slate-400">
                        {isAm
                          ? 'ምንም ምላሾች አልተገኙም ወይም ገና አልገቡም'
                          : 'No baseline survey submissions found.'}
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
