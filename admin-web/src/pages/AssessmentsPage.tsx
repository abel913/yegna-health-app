import React, { useState, useEffect, useMemo, useRef } from 'react';
import {
  BarChart2,
  BookOpen,
  RefreshCw,
  Download,
  Users,
  Hospital,
  Accessibility,
  GraduationCap,
  Search,
  ShieldCheck,
  Layers,
  Trash2,
  Plus,
  Edit3,
  HelpCircle,
  Check,
  Sliders,
  ChevronDown,
  ChevronLeft,
  ChevronRight,
} from 'lucide-react';
import { api } from '../services/api.js';
import {
  BaselineSurveyStats,
  BaselineSurveySubmission,
  DynamicSurveyStatQuestion,
  LearningAssessment,
  Module,
  SurveyQuestion,
} from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';
import { LearningAssessmentsPage } from './LearningAssessmentsPage.js';

interface AssessmentsPageProps {
  modules: Module[];
  assessments: LearningAssessment[];
  lang: 'en' | 'am';
  activeSubTab?: 'baseline' | 'questions' | 'modules';
  onSubTabChange?: (tab: 'baseline' | 'questions' | 'modules') => void;
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

const OPTION_COLOR_GRADIENTS = [
  'from-emerald-500 to-teal-400',
  'from-slate-700 to-slate-900',
  'from-indigo-500 to-purple-500',
  'from-amber-500 to-orange-400',
  'from-rose-500 to-pink-500',
  'from-slate-600 to-slate-800',
  'from-violet-500 to-fuchsia-500',
];

export const UOG_SECTIONS_LIST = [
  { num: 1, labelEn: 'Section 1: General Info (Q.01–04)', labelAm: 'ክፍል 1፡ አጠቃላይ የግል መረጃ', moduleKey: 'general' },
  { num: 2, labelEn: 'Section 2: Sexual Behaviour (Q.05–12)', labelAm: 'ክፍል 2፡ የጾታዊ ባህሪ እና ተጋላጭነት', moduleKey: 'srh' },
  { num: 3, labelEn: 'Section 3: HIV & STIs (Q.13–20)', labelAm: 'ክፍል 3፡ ኤችአይቪ እና አባለዘር በሽታዎች', moduleKey: 'hiv' },
  { num: 4, labelEn: 'Section 4: Contraception (Q.21–26)', labelAm: 'ክፍል 4፡ የእርግዝና መከላከያ', moduleKey: 'contraception' },
  { num: 5, labelEn: 'Section 5: Menstruation & Puberty (Q.27–34)', labelAm: 'ክፍል 5፡ የወር አበባ እና ስነ-ተዋልዶ', moduleKey: 'puberty' },
  { num: 6, labelEn: 'Section 6: Consent, GBV & Safety (Q.35–40)', labelAm: 'ክፍል 6፡ ስምምነት እና ጾታዊ ጥቃት', moduleKey: 'gbv' },
  { num: 7, labelEn: 'Section 7: Service Access (Q.41–44)', labelAm: 'ክፍል 7፡ የአገልግሎት ተደራሽነት', moduleKey: 'mental_health' },
  { num: 8, labelEn: 'Section 8: Support Preferences (Q.45–50)', labelAm: 'ክፍል 8፡ የድጋፍ ፍላጎት እና ምርጫዎች', moduleKey: 'support' },
];

export const AssessmentsPage: React.FC<AssessmentsPageProps> = ({
  modules,
  assessments,
  lang,
  activeSubTab = 'baseline',
  onSubTabChange,
  onSaveAssessment,
  onDeleteAssessment,
}) => {
  const [currentSubTab, setCurrentSubTab] = useState<'baseline' | 'questions' | 'modules'>(activeSubTab);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  const [surveyStats, setSurveyStats] = useState<BaselineSurveyStats | null>(null);
  const [questions, setQuestions] = useState<SurveyQuestion[]>([]);
  const [sectionFilter, setSectionFilter] = useState<'ALL' | number>('ALL');
  const [surveySection, setSurveySection] = useState<'ALL' | number>('ALL');
  const [loading, setLoading] = useState<boolean>(true);
  const [loadingQuestions, setLoadingQuestions] = useState<boolean>(false);
  const [refreshing, setRefreshing] = useState<boolean>(false);
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [srhFilter, setSrhFilter] = useState<'ALL' | 'YES' | 'NO' | 'NOT_SURE'>('ALL');

  const getQuestionSection = (q: DynamicSurveyStatQuestion, index: number): number => {
    if (typeof q.sectionNumber === 'number' && q.sectionNumber >= 1 && q.sectionNumber <= 8) {
      return q.sectionNumber;
    }
    if (index < 4) return 1;
    if (index < 12) return 2;
    if (index < 20) return 3;
    if (index < 26) return 4;
    if (index < 34) return 5;
    if (index < 40) return 6;
    if (index < 44) return 7;
    return 8;
  };

  const sectionQuestionCounts = useMemo(() => {
    const counts: Record<number, number> = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0 };
    surveyStats?.questions?.forEach((q, idx) => {
      const sec = getQuestionSection(q, idx);
      counts[sec] = (counts[sec] || 0) + 1;
    });
    return counts;
  }, [surveyStats?.questions]);

  const displayedQuestions = useMemo(() => {
    if (!surveyStats?.questions) return [];
    if (surveySection === 'ALL') {
      return surveyStats.questions.map((q, originalIdx) => ({ question: q, originalIdx }));
    }
    const filtered: Array<{ question: DynamicSurveyStatQuestion; originalIdx: number }> = [];
    surveyStats.questions.forEach((q, originalIdx) => {
      if (getQuestionSection(q, originalIdx) === surveySection) {
        filtered.push({ question: q, originalIdx });
      }
    });
    return filtered;
  }, [surveyStats?.questions, surveySection]);

  const activeSectionInfo = useMemo(() => {
    if (surveySection === 'ALL') return null;
    return UOG_SECTIONS_LIST.find((s) => s.num === surveySection) || null;
  }, [surveySection]);

  const handlePrevSection = () => {
    if (surveySection === 'ALL' || surveySection <= 1) {
      setSurveySection(8);
    } else {
      setSurveySection((surveySection - 1) as number);
    }
  };

  const handleNextSection = () => {
    if (surveySection === 'ALL' || surveySection >= 8) {
      setSurveySection(1);
    } else {
      setSurveySection((surveySection + 1) as number);
    }
  };

  // Question Modal State
  const [isQuestionModalOpen, setIsQuestionModalOpen] = useState<boolean>(false);
  const [editingQuestion, setEditingQuestion] = useState<SurveyQuestion | null>(null);
  const [questionSection, setQuestionSection] = useState<number>(1);
  const [questionTitleEn, setQuestionTitleEn] = useState<string>('');
  const [questionTitleAm, setQuestionTitleAm] = useState<string>('');
  const [questionType, setQuestionType] = useState<'SINGLE_CHOICE' | 'MULTI_CHOICE'>('SINGLE_CHOICE');
  const [questionOptions, setQuestionOptions] = useState<
    Array<{ id?: string; position: number; value: string; labelEn: string; labelAm: string }>
  >([]);
  const [savingQuestion, setSavingQuestion] = useState<boolean>(false);

  const isAm = lang === 'am';

  // Sync with prop when parent navigates
  useEffect(() => {
    if (activeSubTab) {
      setCurrentSubTab(activeSubTab);
    }
  }, [activeSubTab]);

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsDropdownOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleSwitchTab = (tab: 'baseline' | 'questions' | 'modules') => {
    setCurrentSubTab(tab);
    setIsDropdownOpen(false);
    onSubTabChange?.(tab);
  };

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

  const loadQuestions = async (sec?: 'ALL' | number) => {
    setLoadingQuestions(true);
    try {
      const activeSec = sec !== undefined ? sec : sectionFilter;
      const res = await api.getSurveyQuestions(
        activeSec !== 'ALL' ? { section: activeSec } : undefined
      );
      setQuestions(res.questions || []);
    } catch (err) {
      console.error('Failed to load survey questions:', err);
    } finally {
      setLoadingQuestions(false);
    }
  };

  const handleSectionFilterChange = (sec: 'ALL' | number) => {
    setSectionFilter(sec);
    loadQuestions(sec);
  };

  useEffect(() => {
    loadStats();
    loadQuestions();
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
    if (!surveyStats?.recentSubmissions || surveyStats.recentSubmissions.length === 0) return;

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

  // Delete single response
  const handleDeleteSubmission = async (id: string) => {
    if (
      !window.confirm(
        isAm
          ? 'ይህን ማንነቱ ያልታወቀ ምላሽ መሰረዝ ይፈልጋሉ?'
          : 'Are you sure you want to permanently delete this anonymous response?'
      )
    )
      return;

    try {
      await api.deleteSurveyResponse(id);
      await loadStats();
    } catch (err) {
      console.error('Failed to delete response:', err);
      alert(isAm ? 'መሰረዝ አልተቻለም' : 'Failed to delete response');
    }
  };

  // Clear all responses
  const handleClearAll = async () => {
    if (
      !window.confirm(
        isAm
          ? 'ሁሉንም የሙከራ ምላሾች ማጽዳት ይፈልጋሉ? ይህ እርምጃ ሊቀለበስ አይችልም።'
          : 'Are you sure you want to clear ALL survey responses? This action cannot be undone.'
      )
    )
      return;

    try {
      await api.clearSurveyResponses();
      await loadStats();
    } catch (err) {
      console.error('Failed to clear responses:', err);
      alert(isAm ? 'ማጽዳት አልተቻለም' : 'Failed to clear responses');
    }
  };

  // Question Management Handlers
  const openCreateQuestionModal = () => {
    setEditingQuestion(null);
    setQuestionSection(typeof sectionFilter === 'number' ? sectionFilter : 1);
    setQuestionTitleEn('');
    setQuestionTitleAm('');
    setQuestionType('SINGLE_CHOICE');
    setQuestionOptions([
      { position: 1, value: 'Option 1', labelEn: 'Option 1', labelAm: 'አማራጭ 1' },
      { position: 2, value: 'Option 2', labelEn: 'Option 2', labelAm: 'አማራጭ 2' },
    ]);
    setIsQuestionModalOpen(true);
  };

  const openEditQuestionModal = (q: SurveyQuestion) => {
    setEditingQuestion(q);
    setQuestionSection(q.sectionNumber || 1);
    setQuestionTitleEn(q.titleEn);
    setQuestionTitleAm(q.titleAm);
    setQuestionType(q.type);
    setQuestionOptions(
      q.options.map((opt, idx) => ({
        id: opt.id,
        position: opt.position ?? idx + 1,
        value: opt.value,
        labelEn: opt.labelEn,
        labelAm: opt.labelAm,
      }))
    );
    setIsQuestionModalOpen(true);
  };

  const handleAddOptionRow = () => {
    const nextIdx = questionOptions.length + 1;
    setQuestionOptions([
      ...questionOptions,
      {
        position: nextIdx,
        value: `Option ${nextIdx}`,
        labelEn: `Option ${nextIdx}`,
        labelAm: `አማራጭ ${nextIdx}`,
      },
    ]);
  };

  const handleRemoveOptionRow = (index: number) => {
    if (questionOptions.length <= 2) {
      alert(isAm ? 'ቢያንስ 2 አማራጮች መኖር አለባቸው' : 'A question must have at least 2 options.');
      return;
    }
    setQuestionOptions(questionOptions.filter((_, idx) => idx !== index));
  };

  const handleSaveQuestion = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!questionTitleEn.trim()) {
      alert('English question title is required');
      return;
    }
    for (const opt of questionOptions) {
      if (!opt.value.trim() || !opt.labelEn.trim()) {
        alert('All options must have a value and an English label');
        return;
      }
    }

    const secInfo = UOG_SECTIONS_LIST.find((s) => s.num === questionSection) || UOG_SECTIONS_LIST[0];

    setSavingQuestion(true);
    try {
      const payload: Partial<SurveyQuestion> = {
        sectionNumber: secInfo.num,
        sectionKey: `section_${secInfo.num}`,
        sectionTitleEn: secInfo.labelEn,
        sectionTitleAm: secInfo.labelAm,
        moduleKey: secInfo.moduleKey,
        titleEn: questionTitleEn.trim(),
        titleAm: questionTitleAm.trim() || questionTitleEn.trim(),
        type: questionType,
        position: editingQuestion ? editingQuestion.position : questions.length + 1,
        isRequired: true,
        options: questionOptions.map((opt, idx) => ({
          id: opt.id,
          position: idx + 1,
          value: opt.value.trim(),
          labelEn: opt.labelEn.trim(),
          labelAm: opt.labelAm.trim() || opt.labelEn.trim(),
        })) as any,
      };

      if (editingQuestion) {
        await api.updateSurveyQuestion(editingQuestion.id, payload);
      } else {
        await api.createSurveyQuestion(payload);
      }

      setIsQuestionModalOpen(false);
      await loadQuestions(sectionFilter);
      await loadStats();
    } catch (err: any) {
      console.error('Error saving question:', err);
      alert(err.message || 'Failed to save question');
    } finally {
      setSavingQuestion(false);
    }
  };

  const handleDeleteQuestion = async (id: string) => {
    if (
      !window.confirm(
        isAm
          ? 'ይህን ጥያቄ በእርግጥ መሰረዝ ይፈልጋሉ? የተያያዙ አማራጮች በሙሉ ይሰረዛሉ።'
          : 'Are you sure you want to delete this question? All its choices will also be deleted.'
      )
    )
      return;

    try {
      await api.deleteSurveyQuestion(id);
      await loadQuestions();
      await loadStats();
    } catch (err: any) {
      console.error('Error deleting question:', err);
      alert(err.message || 'Failed to delete question');
    }
  };

  const handleToggleQuestionActive = async (q: SurveyQuestion) => {
    try {
      await api.updateSurveyQuestion(q.id, { isActive: !q.isActive });
      await loadQuestions();
      await loadStats();
    } catch (err: any) {
      console.error('Error toggling question active status:', err);
    }
  };

  const currentTabOption = [
    {
      id: 'baseline' as const,
      label: isAm ? 'የመግቢያ አጠቃላይ ቅኝት' : 'Survey Insights',
      icon: BarChart2,
      desc: isAm ? 'የተማሪዎች አጠቃላይ ስታቲስቲክስና ዳታ' : 'Anonymous baseline student demographics',
      color: 'text-emerald-500',
    },
    {
      id: 'questions' as const,
      label: isAm ? 'ጥያቄዎችን አስተዳድር' : 'Manage Questions',
      icon: Sliders,
      desc: isAm ? 'ተለዋዋጭ ጥያቄዎችን ማከል፣ ማረም እና ማስወገድ' : 'Create, edit, and reorder custom survey questions',
      color: 'text-purple-500',
    },
    {
      id: 'modules' as const,
      label: isAm ? 'የትምህርት ሞጁል ምዘናዎች' : 'Module Tests',
      icon: BookOpen,
      desc: isAm ? 'የሞጁል ፈተናዎችና የትምህርት ጥያቄዎች' : 'Curriculum chapter tests and learning mastery',
      color: 'text-slate-900 dark:text-white',
    },
  ];

  const activeOption = currentTabOption.find((o) => o.id === currentSubTab) || currentTabOption[0];
  const ActiveIcon = activeOption.icon;

  return (
    <div className="space-y-6">
      {/* 1. TOP HEADER & SUB-NAV CONTROLS */}
      <div className="flex flex-col gap-4 border-b border-slate-200/80 pb-5 sm:flex-row sm:items-center sm:justify-between dark:border-slate-800">
        <div>
          <div className="flex items-center gap-2 text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            <span>{isAm ? 'አስተዳደር' : 'Yegna Admin'}</span>
            <span>/</span>
            <span className="text-slate-900 dark:text-white">{isAm ? 'ምዘናዎች እና ቅኝቶች' : 'Assessments & Surveys'}</span>
          </div>
          <h1 className="mt-1 text-2xl font-black text-slate-900 dark:text-white">
            {isAm ? 'የተማሪዎች ምዘናና መጠይቅ ማዕከል' : 'Assessments & Student Surveys Hub'}
          </h1>
          <p className="mt-0.5 text-sm text-slate-500 dark:text-slate-400">
            {isAm
              ? 'የተማሪዎች አጠቃላይ የመግቢያ ቅኝት፣ ተለዋዋጭ ጥያቄዎች እና የሞጁል ትምህርት ምዘናዎች'
              : 'Anonymous student baseline insights, dynamic survey questions, and curriculum learning tests'}
          </p>
        </div>

        {/* Right side: Dropdown Selector + Context Actions */}
        <div className="flex flex-wrap items-center gap-2.5">
          {/* Executive View Switcher Dropdown */}
          <div className="relative" ref={dropdownRef}>
            <button
              onClick={() => setIsDropdownOpen(!isDropdownOpen)}
              className="flex items-center gap-2.5 px-3.5 py-2 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl shadow-xs text-xs font-bold text-slate-800 dark:text-slate-100 hover:bg-slate-50 dark:hover:bg-slate-750 transition-all cursor-pointer"
            >
              <ActiveIcon size={16} className={activeOption.color} />
              <div className="flex flex-col text-left">
                <span className="text-[10px] uppercase font-semibold text-slate-400 leading-none">View</span>
                <span className="text-xs font-bold leading-tight mt-0.5">{activeOption.label}</span>
              </div>
              <ChevronDown
                size={14}
                className={`ml-1 text-slate-400 transition-transform duration-200 ${
                  isDropdownOpen ? 'rotate-180 text-slate-700 dark:text-slate-200' : ''
                }`}
              />
            </button>

            {isDropdownOpen && (
              <div className="absolute right-0 top-full mt-2 w-72 bg-white dark:bg-slate-900 rounded-2xl shadow-2xl border border-slate-200/90 dark:border-slate-800 z-50 p-2 space-y-1 animate-in fade-in zoom-in-95 duration-150">
                <div className="px-2.5 py-1 text-[10px] font-bold uppercase tracking-wider text-slate-400 dark:text-slate-500">
                  {isAm ? 'ክፍል ይምረጡ' : 'Select Assessment Section'}
                </div>
                {currentTabOption.map((opt) => {
                  const Icon = opt.icon;
                  const isSelected = currentSubTab === opt.id;
                  return (
                    <button
                      key={opt.id}
                      onClick={() => handleSwitchTab(opt.id)}
                      className={`w-full flex items-start gap-3 p-2.5 rounded-xl transition-all text-left cursor-pointer ${
                        isSelected
                          ? 'bg-slate-100 dark:bg-slate-800 text-slate-900 dark:text-white font-bold'
                          : 'hover:bg-slate-50 dark:hover:bg-slate-800/60 text-slate-600 dark:text-slate-300'
                      }`}
                    >
                      <div className={`p-1.5 rounded-lg ${isSelected ? 'bg-white dark:bg-slate-700 shadow-xs' : 'bg-slate-100 dark:bg-slate-800'}`}>
                        <Icon size={16} className={opt.color} />
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center justify-between">
                          <p className="text-xs font-bold truncate">{opt.label}</p>
                          {isSelected && <Check size={14} className="text-slate-900 dark:text-white shrink-0" />}
                        </div>
                        <p className="text-[10px] text-slate-400 dark:text-slate-500 leading-tight mt-0.5 line-clamp-1">{opt.desc}</p>
                      </div>
                    </button>
                  );
                })}
              </div>
            )}
          </div>

          {/* Context actions for baseline */}
          {currentSubTab === 'baseline' && (
            <div className="flex items-center gap-2">
              <button
                onClick={() => loadStats(true)}
                disabled={refreshing}
                className="inline-flex items-center gap-1.5 rounded-xl border border-slate-300 bg-white px-3 py-2 text-xs font-semibold text-slate-700 shadow-xs transition hover:bg-slate-50 disabled:opacity-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 dark:hover:bg-slate-700 cursor-pointer"
                title="Refresh Live Data"
              >
                <RefreshCw size={13} className={refreshing ? 'animate-spin text-slate-700 dark:text-slate-300' : ''} />
                <span className="hidden sm:inline">{isAm ? 'አድስ' : 'Refresh'}</span>
              </button>
              <button
                onClick={handleExportCsv}
                className="inline-flex items-center gap-1.5 rounded-xl bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 border border-slate-900 dark:border-white px-3.5 py-2 text-xs font-bold shadow-xs transition cursor-pointer"
              >
                <Download size={13} />
                <span>{isAm ? 'CSV አውርድ' : 'Export CSV'}</span>
              </button>
              {totalSubmissions > 0 && (
                <button
                  onClick={handleClearAll}
                  className="inline-flex items-center gap-1.5 rounded-xl border border-rose-300 bg-rose-50 px-3 py-2 text-xs font-semibold text-rose-700 shadow-xs transition hover:bg-rose-100 dark:border-rose-800 dark:bg-rose-950/40 dark:text-rose-400 dark:hover:bg-rose-950/70 cursor-pointer"
                  title="Clear all test responses"
                >
                  <Trash2 size={13} />
                  <span>{isAm ? 'የሙከራ መረጃዎችን አጽዳ' : 'Clear Test Data'}</span>
                </button>
              )}
            </div>
          )}

          {/* Context actions for questions */}
          {currentSubTab === 'questions' && (
            <button
              onClick={openCreateQuestionModal}
              className="inline-flex items-center gap-2 rounded-xl bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 border border-slate-900 dark:border-white px-4 py-2 text-xs font-bold shadow-xs transition cursor-pointer"
            >
              <Plus size={15} />
              <span>{isAm ? 'አዲስ ጥያቄ ጨምር' : 'Add New Question'}</span>
            </button>
          )}
        </div>
      </div>

      {/* 2. SUB-TAB CONTENT */}
      {currentSubTab === 'modules' ? (
        // Tab 3: Module Learning Assessments
        <LearningAssessmentsPage
          modules={modules}
          assessments={assessments}
          lang={lang}
          onSave={onSaveAssessment}
          onDelete={onDeleteAssessment}
        />
      ) : currentSubTab === 'questions' ? (
        // Tab 2: Manage Dynamic Survey Questions
        <div className="space-y-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <span className="flex h-8 w-8 items-center justify-center rounded-xl bg-purple-500/10 text-purple-600 dark:bg-purple-500/20 dark:text-purple-400">
                <HelpCircle size={18} />
              </span>
              <div>
                <h3 className="text-lg font-bold text-slate-900 dark:text-white">
                  {isAm ? 'ተለዋዋጭ የመግቢያ ጥያቄዎች' : 'Baseline Assessment Questions'}
                </h3>
                <p className="text-xs text-slate-500 dark:text-slate-400">
                  {isAm
                    ? 'በተማሪዎች ሞባይል አፕሊኬሽን የሚቀርቡትን ጥያቄዎች እና አማራጮች ያቀናብሩ'
                    : 'Manage questions and choices rendered dynamically in the mobile onboarding survey modal'}
                </p>
              </div>
            </div>

            <span className="rounded-full bg-slate-100 px-3 py-1 text-xs font-bold text-slate-700 dark:bg-slate-800 dark:text-slate-300">
              {questions.length} {isAm ? 'ጥያቄዎች' : 'Questions'}
            </span>
          </div>

          {/* Section Filter Pills */}
          <div className="flex flex-wrap items-center gap-1.5 rounded-2xl bg-slate-50 p-2.5 dark:bg-slate-800/60 border border-slate-200/70 dark:border-slate-800">
            <span className="text-xs font-bold text-slate-500 uppercase tracking-wider mr-1">
              {isAm ? 'ክፍል፡' : 'Section:'}
            </span>
            <button
              onClick={() => handleSectionFilterChange('ALL')}
              className={`rounded-xl px-3 py-1.5 text-xs font-bold transition-all cursor-pointer ${
                sectionFilter === 'ALL'
                  ? 'bg-purple-600 text-white shadow-xs'
                  : 'bg-white text-slate-700 hover:bg-slate-100 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700 border border-slate-200 dark:border-slate-700'
              }`}
            >
              {isAm ? 'ሁሉም ክፍሎች (1-8)' : 'All Sections (1–8)'}
            </button>
            {UOG_SECTIONS_LIST.map((sec) => (
              <button
                key={sec.num}
                onClick={() => handleSectionFilterChange(sec.num)}
                className={`rounded-xl px-3 py-1.5 text-xs font-bold transition-all cursor-pointer ${
                  sectionFilter === sec.num
                    ? 'bg-purple-600 text-white shadow-xs'
                    : 'bg-white text-slate-700 hover:bg-slate-100 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700 border border-slate-200 dark:border-slate-700'
                }`}
              >
                Sec {sec.num}
              </button>
            ))}
          </div>

          {loadingQuestions ? (
            <div className="flex h-48 items-center justify-center">
              <RefreshCw className="h-6 w-6 animate-spin text-purple-500" />
            </div>
          ) : questions.length === 0 ? (
            <div className="rounded-2xl border border-dashed border-slate-300 p-12 text-center dark:border-slate-700">
              <Sliders className="mx-auto h-12 w-12 text-slate-400" />
              <h4 className="mt-3 text-base font-bold text-slate-700 dark:text-slate-200">
                {isAm ? 'ምንም ጥያቄ አልተገኘም' : 'No Survey Questions Found'}
              </h4>
              <p className="mt-1 text-xs text-slate-500">
                {isAm ? 'አዲስ ጥያቄ ለማከል ከላይ ያለውን አዝራር ይጫኑ' : 'Click "+ Add New Question" to add your first baseline survey question.'}
              </p>
            </div>
          ) : (
            <div className="grid gap-4">
              {questions.map((q, idx) => (
                <div
                  key={q.id}
                  className="group relative rounded-2xl border border-slate-200/90 bg-white p-5 shadow-xs transition hover:border-purple-300 hover:shadow-md dark:border-slate-800 dark:bg-slate-900 dark:hover:border-purple-800"
                >
                  <div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                    <div className="flex items-start gap-3.5">
                      <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-purple-50 text-xs font-black text-purple-600 dark:bg-purple-950/60 dark:text-purple-300">
                        #{idx + 1}
                      </div>
                      <div>
                        <div className="flex flex-wrap items-center gap-2">
                          {q.sectionNumber && (
                            <span className="rounded-md bg-purple-50 px-2 py-0.5 text-[10px] font-bold text-purple-700 dark:bg-purple-950/40 dark:text-purple-300">
                              Section {q.sectionNumber}
                            </span>
                          )}
                          <h4 className="text-base font-bold text-slate-900 dark:text-white">
                            {q.titleEn}
                          </h4>
                          <span
                            className={`rounded-md px-2 py-0.5 text-[10px] font-bold ${
                              q.isActive
                                ? 'bg-emerald-50 text-emerald-700 dark:bg-emerald-950/40 dark:text-emerald-400'
                                : 'bg-slate-100 text-slate-600 dark:bg-slate-800 dark:text-slate-400'
                            }`}
                          >
                            {q.isActive ? (isAm ? 'ንቁ' : 'Active') : (isAm ? 'የተደበቀ' : 'Hidden')}
                          </span>
                          <span className="rounded-md bg-slate-100 px-2 py-0.5 text-[10px] font-bold text-slate-700 dark:bg-slate-800 dark:text-slate-300 border border-slate-200 dark:border-slate-700">
                            {q.type === 'SINGLE_CHOICE' ? 'Single Choice' : 'Multi Choice'}
                          </span>
                        </div>
                        <p className="mt-1 text-sm font-medium text-slate-500 dark:text-slate-400">
                          {q.titleAm}
                        </p>

                        {/* Options pills */}
                        <div className="mt-3 flex flex-wrap gap-1.5">
                          {q.options.map((opt) => (
                            <span
                              key={opt.id}
                              className="inline-flex items-center gap-1.5 rounded-lg border border-slate-200 bg-slate-50 px-2.5 py-1 text-xs font-medium text-slate-700 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300"
                            >
                              <span className="font-mono text-[10px] text-purple-600 dark:text-purple-400">
                                {opt.position}.
                              </span>
                              <span>{opt.labelEn}</span>
                              {opt.labelAm && opt.labelAm !== opt.labelEn && (
                                <span className="text-[10px] text-slate-400">({opt.labelAm})</span>
                              )}
                            </span>
                          ))}
                        </div>
                      </div>
                    </div>

                    {/* Action buttons */}
                    <div className="flex items-center gap-1.5 sm:self-center">
                      <button
                        onClick={() => handleToggleQuestionActive(q)}
                        className={`rounded-lg px-2.5 py-1 text-xs font-semibold transition cursor-pointer ${
                          q.isActive
                            ? 'text-amber-600 hover:bg-amber-50 dark:text-amber-400 dark:hover:bg-amber-950/40'
                            : 'text-emerald-600 hover:bg-emerald-50 dark:text-emerald-400 dark:hover:bg-emerald-950/40'
                        }`}
                        title={q.isActive ? 'Hide from students' : 'Activate in survey'}
                      >
                        {q.isActive ? (isAm ? 'ደብቅ' : 'Hide') : (isAm ? 'አሳይ' : 'Activate')}
                      </button>
                      <button
                        onClick={() => openEditQuestionModal(q)}
                        className="rounded-lg p-1.5 text-slate-400 hover:bg-slate-100 hover:text-slate-900 dark:hover:bg-slate-800 dark:hover:text-white cursor-pointer"
                        title="Edit question"
                      >
                        <Edit3 size={15} />
                      </button>
                      <button
                        onClick={() => handleDeleteQuestion(q.id)}
                        className="rounded-lg p-1.5 text-slate-400 hover:bg-rose-50 hover:text-rose-600 dark:hover:bg-rose-950/40 dark:hover:text-rose-400 cursor-pointer"
                        title="Delete question"
                      >
                        <Trash2 size={15} />
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      ) : (
        // Tab 1: Survey Insights (Live Data & Charts)
        <div className="space-y-6">
          {/* Top KPI Summary Cards */}
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <div className="rounded-2xl border border-slate-200/90 bg-white p-5 shadow-xs dark:border-slate-800 dark:bg-slate-900">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
                  {isAm ? 'ጠቅላላ ተሳታፊዎች' : 'Total Survey Respondents'}
                </span>
                <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-slate-100 text-slate-900 dark:bg-slate-800 dark:text-white">
                  <Users size={18} />
                </span>
              </div>
              <p className="mt-3 text-3xl font-black text-slate-900 dark:text-white">
                {totalSubmissions.toLocaleString()}
              </p>
              <div className="mt-2 flex items-center gap-1.5 text-xs text-emerald-600 dark:text-emerald-400">
                <ShieldCheck size={14} />
                <span className="font-semibold">Zero-PII Privacy Protection</span>
              </div>
            </div>

            <div className="rounded-2xl border border-slate-200/90 bg-white p-5 shadow-xs dark:border-slate-800 dark:bg-slate-900">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
                  {isAm ? 'የጎንደር SRH ክሊኒክ ግንዛቤ' : 'Gondar SRH Awareness'}
                </span>
                <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-emerald-50 text-emerald-600 dark:bg-emerald-950/60 dark:text-emerald-400">
                  <Hospital size={18} />
                </span>
              </div>
              <p className="mt-3 text-3xl font-black text-emerald-600 dark:text-emerald-400">
                {awarePercent}%
              </p>
              <p className="mt-2 text-xs text-slate-500 dark:text-slate-400">
                {awareCount} {isAm ? 'ተማሪዎች አገልግሎቱን ያውቃሉ' : 'students fully aware'}
              </p>
            </div>

            <div className="rounded-2xl border border-slate-200/90 bg-white p-5 shadow-xs dark:border-slate-800 dark:bg-slate-900">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
                  {isAm ? 'የተደራሽነት ድጋፍ ፍላጎት' : 'Accessibility Support Need'}
                </span>
                <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-purple-50 text-purple-600 dark:bg-purple-950/60 dark:text-purple-400">
                  <Accessibility size={18} />
                </span>
              </div>
              <p className="mt-3 text-3xl font-black text-purple-600 dark:text-purple-400">
                {needAssistancePercent}%
              </p>
              <p className="mt-2 text-xs text-slate-500 dark:text-slate-400">
                {needAssistanceCount} {isAm ? 'ተማሪዎች ድጋፍ ይፈልጋሉ' : 'requesting specialized support'}
              </p>
            </div>

            <div className="rounded-2xl border border-slate-200/90 bg-white p-5 shadow-xs dark:border-slate-800 dark:bg-slate-900">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
                  {isAm ? 'ዋና የዕድሜ / የትምህርት ቡድን' : 'Primary Cohort'}
                </span>
                <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-amber-50 text-amber-600 dark:bg-amber-950/60 dark:text-amber-400">
                  <GraduationCap size={18} />
                </span>
              </div>
              <p className="mt-3 text-xl font-black text-slate-900 dark:text-white truncate">
                {topAge}
              </p>
              <p className="mt-2 text-xs text-slate-500 dark:text-slate-400 truncate">
                {topYear}
              </p>
            </div>
          </div>

          {/* Dynamic Question Breakdown Charts */}
          {surveyStats?.questions && surveyStats.questions.length > 0 && (
            <div className="space-y-4">
              {/* Header and Stepper */}
              <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between border-b border-slate-100 pb-3 dark:border-slate-800">
                <div>
                  <h3 className="text-lg font-bold text-slate-900 dark:text-white flex items-center gap-2">
                    <Layers className="text-purple-600 dark:text-purple-400" size={20} />
                    <span>{isAm ? 'የጥያቄዎች ምላሽ ስርጭት (በሞጁል)' : 'Question Response Distributions by Module'}</span>
                  </h3>
                  <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
                    {surveySection === 'ALL'
                      ? isAm
                        ? `ሁሉም ${surveyStats.questions.length} ጥያቄዎች እየታዩ ነው`
                        : `Displaying all ${surveyStats.questions.length} survey questions across 8 modules`
                      : isAm
                      ? `${activeSectionInfo?.labelAm || `ክፍል ${surveySection}`} (${displayedQuestions.length} ጥያቄዎች)`
                      : `${activeSectionInfo?.labelEn || `Section ${surveySection}`} (${displayedQuestions.length} questions)`}
                  </p>
                </div>

                {/* Stepper Buttons */}
                <div className="flex items-center gap-2 self-start sm:self-auto">
                  <button
                    onClick={handlePrevSection}
                    className="inline-flex items-center gap-1 rounded-xl border border-slate-200 bg-white px-2.5 py-1.5 text-xs font-bold text-slate-700 shadow-xs transition hover:bg-slate-50 hover:border-slate-300 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 dark:hover:bg-slate-700 cursor-pointer"
                    title={isAm ? 'ቀዳሚ ክፍል' : 'Previous Module'}
                  >
                    <ChevronLeft size={15} />
                    <span>{isAm ? 'ቀዳሚ' : 'Prev'}</span>
                  </button>

                  <span className="text-xs font-bold px-2 py-1 rounded-lg bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300">
                    {surveySection === 'ALL' ? (isAm ? 'ሁሉም' : 'All') : `${surveySection} / 8`}
                  </span>

                  <button
                    onClick={handleNextSection}
                    className="inline-flex items-center gap-1 rounded-xl border border-slate-200 bg-white px-2.5 py-1.5 text-xs font-bold text-slate-700 shadow-xs transition hover:bg-slate-50 hover:border-slate-300 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 dark:hover:bg-slate-700 cursor-pointer"
                    title={isAm ? 'ቀጣይ ክፍል' : 'Next Module'}
                  >
                    <span>{isAm ? 'ቀጣይ' : 'Next'}</span>
                    <ChevronRight size={15} />
                  </button>
                </div>
              </div>

              {/* Thematic Module Navigation Pill Bar (Scrollable on desktop, responsive dropdown on mobile) */}
              <div className="space-y-2">
                {/* Mobile Dropdown */}
                <div className="block sm:hidden">
                  <select
                    value={surveySection}
                    onChange={(e) => setSurveySection(e.target.value === 'ALL' ? 'ALL' : Number(e.target.value))}
                    className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-xs font-bold text-slate-800 shadow-xs dark:border-slate-700 dark:bg-slate-800 dark:text-slate-100"
                  >
                    <option value="ALL">{isAm ? `ሁሉም ሞጁሎች (${surveyStats.questions.length})` : `All Modules (${surveyStats.questions.length})`}</option>
                    {UOG_SECTIONS_LIST.map((sec) => (
                      <option key={sec.num} value={sec.num}>
                        Sec {sec.num}: {isAm ? sec.labelAm : sec.labelEn} ({sectionQuestionCounts[sec.num] || 0})
                      </option>
                    ))}
                  </select>
                </div>

                {/* Desktop Horizontal Pill Bar */}
                <div className="hidden sm:flex items-center gap-1.5 overflow-x-auto pb-1 no-scrollbar">
                  <button
                    onClick={() => setSurveySection('ALL')}
                    className={`inline-flex items-center gap-1.5 rounded-xl px-3 py-1.5 text-xs font-bold transition-all shrink-0 cursor-pointer ${
                      surveySection === 'ALL'
                        ? 'bg-purple-600 text-white shadow-xs'
                        : 'bg-white text-slate-700 hover:bg-slate-100 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700 border border-slate-200 dark:border-slate-700'
                    }`}
                  >
                    <span>{isAm ? 'ሁሉም ሞጁሎች' : 'All Modules'}</span>
                    <span className={`rounded-full px-1.5 py-0.2 text-[10px] font-extrabold ${surveySection === 'ALL' ? 'bg-purple-700 text-purple-100' : 'bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300'}`}>
                      {surveyStats.questions.length}
                    </span>
                  </button>

                  {UOG_SECTIONS_LIST.map((sec) => {
                    const isSelected = surveySection === sec.num;
                    const count = sectionQuestionCounts[sec.num] || 0;
                    return (
                      <button
                        key={sec.num}
                        onClick={() => setSurveySection(sec.num)}
                        className={`inline-flex items-center gap-1.5 rounded-xl px-3 py-1.5 text-xs font-bold transition-all shrink-0 cursor-pointer ${
                          isSelected
                            ? 'bg-purple-600 text-white shadow-xs'
                            : 'bg-white text-slate-700 hover:bg-slate-100 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700 border border-slate-200 dark:border-slate-700'
                        }`}
                      >
                        <span>Sec {sec.num}</span>
                        <span className={`rounded-full px-1.5 py-0.2 text-[10px] font-extrabold ${isSelected ? 'bg-purple-700 text-purple-100' : 'bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300'}`}>
                          {count}
                        </span>
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Active Section Context Banner (when a single section is chosen) */}
              {activeSectionInfo && (
                <div className="flex items-center justify-between rounded-xl bg-purple-50/70 dark:bg-purple-950/30 border border-purple-200/70 dark:border-purple-800/50 px-4 py-2.5">
                  <div className="flex items-center gap-2.5">
                    <span className="flex h-7 w-7 items-center justify-center rounded-lg bg-purple-600 text-white text-xs font-black">
                      {activeSectionInfo.num}
                    </span>
                    <div>
                      <p className="text-xs font-bold text-purple-900 dark:text-purple-200">
                        {isAm ? activeSectionInfo.labelAm : activeSectionInfo.labelEn}
                      </p>
                      <p className="text-[11px] text-purple-700/80 dark:text-purple-300/80">
                        {isAm
                          ? `በዚህ ክፍል ${displayedQuestions.length} ጥያቄዎች ይገኛሉ`
                          : `Module contains ${displayedQuestions.length} assessment questions`}
                      </p>
                    </div>
                  </div>
                  <button
                    onClick={() => setSurveySection('ALL')}
                    className="text-xs font-bold text-purple-600 hover:text-purple-800 dark:text-purple-400 dark:hover:text-purple-200 underline cursor-pointer"
                  >
                    {isAm ? 'ሁሉንም አሳይ' : 'Show All'}
                  </button>
                </div>
              )}

              {/* Question Cards Grid */}
              <div className="grid grid-cols-1 gap-5 lg:grid-cols-2">
                {displayedQuestions.map(({ question: item, originalIdx }) => (
                  <div
                    key={item.id}
                    className="rounded-2xl border border-slate-200/90 bg-white p-5 shadow-xs dark:border-slate-800 dark:bg-slate-900"
                  >
                    <div className="flex items-start justify-between gap-2 border-b border-slate-100 pb-3 dark:border-slate-800">
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="text-[10px] font-bold uppercase tracking-wider text-purple-600 dark:text-purple-400">
                            Question #{originalIdx + 1}
                          </span>
                          {item.sectionNumber && (
                            <span className="rounded-md bg-slate-100 px-1.5 py-0.2 text-[9px] font-extrabold text-slate-500 dark:bg-slate-800 dark:text-slate-400">
                              Sec {item.sectionNumber}
                            </span>
                          )}
                        </div>
                        <h4 className="text-sm font-bold text-slate-900 dark:text-white mt-0.5">
                          {isAm ? item.titleAm : item.titleEn}
                        </h4>
                        {item.titleAm && item.titleAm !== item.titleEn && (
                          <p className="text-xs text-slate-400 dark:text-slate-500 mt-0.5">
                            {isAm ? item.titleEn : item.titleAm}
                          </p>
                        )}
                      </div>
                      <span className="rounded-full bg-slate-100 px-2.5 py-0.5 text-[11px] font-bold text-slate-600 dark:bg-slate-800 dark:text-slate-300 shrink-0">
                        {totalSubmissions} {isAm ? 'ምላሾች' : 'answers'}
                      </span>
                    </div>

                    <div className="mt-4 space-y-3">
                      {item.options.map((opt, oIdx) => {
                        const gradient = OPTION_COLOR_GRADIENTS[oIdx % OPTION_COLOR_GRADIENTS.length];
                        return (
                          <div key={opt.value} className="space-y-1">
                            <div className="flex items-center justify-between text-xs font-semibold">
                              <span className="text-slate-700 dark:text-slate-200">
                                {isAm ? opt.labelAm : opt.labelEn}
                              </span>
                              <span className="text-slate-500 font-mono text-[11px]">
                                {opt.count} ({opt.percentage}%)
                              </span>
                            </div>
                            <div className="h-2.5 w-full rounded-full bg-slate-100 dark:bg-slate-800 overflow-hidden">
                              <div
                                className={`h-full rounded-full bg-gradient-to-r ${gradient} transition-all duration-500`}
                                style={{ width: `${opt.percentage}%` }}
                              />
                            </div>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Recent Anonymous Submissions Table */}
          <div className="rounded-2xl border border-slate-200/90 bg-white p-5 shadow-xs dark:border-slate-800 dark:bg-slate-900">
            <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between border-b border-slate-100 pb-4 dark:border-slate-800">
              <div>
                <h3 className="text-base font-bold text-slate-900 dark:text-white">
                  {isAm ? 'የቅርብ ጊዜ ምላሾች' : 'Recent Anonymous Responses'}
                </h3>
                <p className="text-xs text-slate-500 dark:text-slate-400">
                  {filteredSubmissions.length} of {totalSubmissions} responses match filter
                </p>
              </div>

              <div className="flex flex-wrap items-center gap-2">
                <div className="relative">
                  <Search className="absolute left-3 top-2.5 h-3.5 w-3.5 text-slate-400" />
                  <input
                    type="text"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    placeholder={isAm ? 'ፈልግ...' : 'Search responses...'}
                    className="w-48 rounded-xl border border-slate-200 bg-slate-50 pl-8 pr-3 py-1.5 text-xs text-slate-800 outline-hidden transition focus:border-slate-900 focus:bg-white dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 dark:focus:border-white"
                  />
                </div>

                <select
                  value={srhFilter}
                  onChange={(e) => setSrhFilter(e.target.value as any)}
                  className="rounded-xl border border-slate-200 bg-slate-50 px-3 py-1.5 text-xs font-medium text-slate-700 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200"
                >
                  <option value="ALL">{isAm ? 'ሁሉም ግንዛቤ' : 'All SRH Awareness'}</option>
                  <option value="YES">{isAm ? 'ያውቃሉ' : 'Aware (Yes)'}</option>
                  <option value="NO">{isAm ? 'አያውቁም' : 'Not Aware (No)'}</option>
                  <option value="NOT_SURE">{isAm ? 'እርግጠኛ አይደሉም' : 'Unsure'}</option>
                </select>
              </div>
            </div>

            {loading ? (
              <div className="flex h-36 items-center justify-center">
                <RefreshCw className="h-6 w-6 animate-spin text-slate-700 dark:text-slate-300" />
              </div>
            ) : filteredSubmissions.length === 0 ? (
              <div className="py-12 text-center text-xs text-slate-400">
                {isAm ? 'ምንም ምላሽ አልተገኘም' : 'No survey responses match your query.'}
              </div>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full text-left text-xs">
                  <thead>
                    <tr className="border-b border-slate-100 text-[11px] font-bold uppercase tracking-wider text-slate-400 dark:border-slate-800">
                      <th className="py-3 px-3">Age Group</th>
                      <th className="py-3 px-3">Year of Study</th>
                      <th className="py-3 px-3">Accessibility Need</th>
                      <th className="py-3 px-3">Gondar SRH Aware</th>
                      <th className="py-3 px-3">Timestamp</th>
                      <th className="py-3 px-3 text-right">Actions</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
                    {filteredSubmissions.map((sub) => (
                      <tr key={sub.id} className="hover:bg-slate-50/50 dark:hover:bg-slate-800/40">
                        <td className="py-3 px-3 font-semibold text-slate-900 dark:text-white">
                          {sub.ageGroup}
                        </td>
                        <td className="py-3 px-3 text-slate-600 dark:text-slate-300">
                          {sub.yearOfStudy}
                        </td>
                        <td className="py-3 px-3">
                          <span
                            className={`rounded-md px-2 py-0.5 text-[10px] font-bold ${
                              sub.disabilityNeed === 'NONE'
                                ? 'bg-slate-100 text-slate-600 dark:bg-slate-800 dark:text-slate-400'
                                : 'bg-purple-50 text-purple-700 dark:bg-purple-950/40 dark:text-purple-300'
                            }`}
                          >
                            {sub.disabilityNeed}
                          </span>
                        </td>
                        <td className="py-3 px-3">
                          <span
                            className={`rounded-md px-2 py-0.5 text-[10px] font-bold ${
                              sub.knowsGondarSrh === 'YES'
                                ? 'bg-emerald-50 text-emerald-700 dark:bg-emerald-950/40 dark:text-emerald-400'
                                : sub.knowsGondarSrh === 'NO'
                                ? 'bg-rose-50 text-rose-700 dark:bg-rose-950/40 dark:text-rose-400'
                                : 'bg-amber-50 text-amber-700 dark:bg-amber-950/40 dark:text-amber-400'
                            }`}
                          >
                            {sub.knowsGondarSrh}
                          </span>
                        </td>
                        <td className="py-3 px-3 text-slate-400 font-mono text-[11px]">
                          {new Date(sub.submittedAt).toLocaleDateString()}
                        </td>
                        <td className="py-3 px-3 text-right">
                          <button
                            onClick={() => handleDeleteSubmission(sub.id)}
                            className="rounded-lg p-1.5 text-slate-400 hover:bg-rose-50 hover:text-rose-600 dark:hover:bg-rose-950/40 dark:hover:text-rose-400 cursor-pointer"
                            title="Delete this record"
                          >
                            <Trash2 size={13} />
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </div>
      )}

      {/* 3. ADD / EDIT QUESTION MODAL */}
      {isQuestionModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-xs p-4 animate-in fade-in">
          <div className="max-h-[90vh] w-full max-w-xl overflow-y-auto rounded-3xl bg-white p-6 shadow-2xl dark:bg-slate-900 dark:border dark:border-slate-800">
            <div className="flex items-center justify-between border-b border-slate-100 pb-4 dark:border-slate-800">
              <h3 className="text-lg font-bold text-slate-900 dark:text-white">
                {editingQuestion
                  ? isAm
                    ? 'ጥያቄ አርም'
                    : 'Edit Survey Question'
                  : isAm
                  ? 'አዲስ ጥያቄ ፍጠር'
                  : 'Add New Survey Question'}
              </h3>
              <button
                onClick={() => setIsQuestionModalOpen(false)}
                className="rounded-xl p-1.5 text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 cursor-pointer"
              >
                ✕
              </button>
            </div>

            <form onSubmit={handleSaveQuestion} className="mt-4 space-y-4">
              {/* Question Section */}
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300">
                  {isAm ? 'የምዘና ክፍል (Section)' : 'Assessment Section'} <span className="text-rose-500">*</span>
                </label>
                <select
                  value={questionSection}
                  onChange={(e) => setQuestionSection(Number(e.target.value))}
                  className="mt-1 w-full rounded-xl border border-slate-200 bg-slate-50 px-3.5 py-2 text-xs font-medium text-slate-800 outline-hidden transition focus:border-purple-500 focus:bg-white dark:border-slate-700 dark:bg-slate-800 dark:text-slate-100"
                >
                  {UOG_SECTIONS_LIST.map((sec) => (
                    <option key={sec.num} value={sec.num}>
                      {isAm ? sec.labelAm : sec.labelEn}
                    </option>
                  ))}
                </select>
              </div>

              {/* Question Title EN */}
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300">
                  Question Prompt (English) <span className="text-rose-500">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={questionTitleEn}
                  onChange={(e) => setQuestionTitleEn(e.target.value)}
                  placeholder="e.g. Do you know where the Gondar campus clinic is?"
                  className="mt-1 w-full rounded-xl border border-slate-200 bg-slate-50 px-3.5 py-2 text-xs font-medium text-slate-800 outline-hidden transition focus:border-purple-500 focus:bg-white dark:border-slate-700 dark:bg-slate-800 dark:text-slate-100"
                />
              </div>

              {/* Question Title AM */}
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300">
                  የጥያቄው ርዕስ (አማርኛ)
                </label>
                <input
                  type="text"
                  value={questionTitleAm}
                  onChange={(e) => setQuestionTitleAm(e.target.value)}
                  placeholder="ለምሳሌ፡ የጎንደር ዩኒቨርሲቲ ክሊኒክ የት እንደሚገኝ ያውቃሉ?"
                  className="mt-1 w-full rounded-xl border border-slate-200 bg-slate-50 px-3.5 py-2 text-xs font-medium text-slate-800 outline-hidden transition focus:border-purple-500 focus:bg-white dark:border-slate-700 dark:bg-slate-800 dark:text-slate-100"
                />
              </div>

              {/* Question Type */}
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300">
                  Question Type
                </label>
                <select
                  value={questionType}
                  onChange={(e) => setQuestionType(e.target.value as any)}
                  className="mt-1 w-full rounded-xl border border-slate-200 bg-slate-50 px-3.5 py-2 text-xs font-medium text-slate-800 outline-hidden transition focus:border-purple-500 focus:bg-white dark:border-slate-700 dark:bg-slate-800 dark:text-slate-100"
                >
                  <option value="SINGLE_CHOICE">Single Choice (Radio Button)</option>
                  <option value="MULTI_CHOICE">Multiple Choice (Checkboxes)</option>
                </select>
              </div>

              {/* Choice Options List */}
              <div className="space-y-2 border-t border-slate-100 pt-3 dark:border-slate-800">
                <div className="flex items-center justify-between">
                  <label className="text-xs font-bold text-slate-700 dark:text-slate-300">
                    Response Choices ({questionOptions.length})
                  </label>
                  <button
                    type="button"
                    onClick={handleAddOptionRow}
                    className="inline-flex items-center gap-1 text-xs font-bold text-purple-600 hover:text-purple-700 dark:text-purple-400 cursor-pointer"
                  >
                    <Plus size={13} />
                    <span>{isAm ? 'አማራጭ ጨምር' : 'Add Option'}</span>
                  </button>
                </div>

                <div className="space-y-2">
                  {questionOptions.map((opt, idx) => (
                    <div
                      key={idx}
                      className="flex items-center gap-2 rounded-xl border border-slate-100 bg-slate-50/80 p-2.5 dark:border-slate-800 dark:bg-slate-800/40"
                    >
                      <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded-lg bg-slate-200 text-[10px] font-bold text-slate-700 dark:bg-slate-700 dark:text-slate-300">
                        {idx + 1}
                      </span>
                      <input
                        type="text"
                        placeholder="English Label"
                        required
                        value={opt.labelEn}
                        onChange={(e) => {
                          const updated = [...questionOptions];
                          updated[idx].labelEn = e.target.value;
                          if (!updated[idx].value || updated[idx].value.startsWith('Option ')) {
                            updated[idx].value = e.target.value;
                          }
                          setQuestionOptions(updated);
                        }}
                        className="w-1/2 rounded-lg border border-slate-200 bg-white px-2.5 py-1.5 text-xs font-medium text-slate-800 outline-hidden dark:border-slate-700 dark:bg-slate-800 dark:text-slate-100"
                      />
                      <input
                        type="text"
                        placeholder="የአማርኛ ስያሜ"
                        value={opt.labelAm}
                        onChange={(e) => {
                          const updated = [...questionOptions];
                          updated[idx].labelAm = e.target.value;
                          setQuestionOptions(updated);
                        }}
                        className="w-1/2 rounded-lg border border-slate-200 bg-white px-2.5 py-1.5 text-xs font-medium text-slate-800 outline-hidden dark:border-slate-700 dark:bg-slate-800 dark:text-slate-100"
                      />
                      <button
                        type="button"
                        onClick={() => handleRemoveOptionRow(idx)}
                        className="p-1 text-slate-400 hover:text-rose-500 cursor-pointer"
                        title="Remove option"
                      >
                        ✕
                      </button>
                    </div>
                  ))}
                </div>
              </div>

              {/* Modal Buttons */}
              <div className="flex items-center justify-end gap-2 border-t border-slate-100 pt-4 dark:border-slate-800">
                <button
                  type="button"
                  onClick={() => setIsQuestionModalOpen(false)}
                  className="rounded-xl border border-slate-200 px-4 py-2 text-xs font-bold text-slate-600 hover:bg-slate-50 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800 cursor-pointer"
                >
                  {isAm ? 'ሰርዝ' : 'Cancel'}
                </button>
                <button
                  type="submit"
                  disabled={savingQuestion}
                  className="inline-flex items-center gap-1.5 rounded-xl bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 border border-slate-900 dark:border-white px-5 py-2 text-xs font-bold shadow-xs transition disabled:opacity-50 cursor-pointer"
                >
                  {savingQuestion && <RefreshCw size={12} className="animate-spin" />}
                  <span>
                    {savingQuestion
                      ? isAm
                        ? 'በማስቀመጥ ላይ...'
                        : 'Saving...'
                      : isAm
                      ? 'አስቀምጥ'
                      : 'Save Question'}
                  </span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
