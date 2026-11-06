import React, { useState, useMemo, useEffect } from 'react';
import {
  HelpCircle,
  Plus,
  Trash2,
  Edit2,
  CheckCircle,
  CheckCircle2,
  X,
  XCircle,
  Search,
  Download,
  PlayCircle,
  RotateCcw,
  Sparkles,
  BookOpen,
  Filter,
} from 'lucide-react';
import { QuizQuestion, Module } from '../types/index.js';
import { ConfirmModal } from '../components/common/ConfirmModal.js';
import { EmptyState } from '../components/common/EmptyState.js';
import { exportToCsv } from '../utils/csvExport.js';

interface QuizzesPageProps {
  questions: QuizQuestion[];
  modules: Module[];
  lang: 'en' | 'am';
  onSaveQuestion: (data: Partial<QuizQuestion>, id?: string) => Promise<void>;
  onDeleteQuestion: (id: string) => Promise<void>;
}

export const QuizzesPage: React.FC<QuizzesPageProps> = ({
  questions,
  modules,
  lang,
  onSaveQuestion,
  onDeleteQuestion,
}) => {
  // Modal & Form States
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingQuestion, setEditingQuestion] = useState<QuizQuestion | null>(null);
  const [questionToDelete, setQuestionToDelete] = useState<QuizQuestion | null>(null);

  // Search & Filter States
  const [search, setSearch] = useState('');
  const [selectedModuleId, setSelectedModuleId] = useState<string>('all');

  // Interactive Student Preview Player States
  const [previewQuestion, setPreviewQuestion] = useState<QuizQuestion | null>(null);
  const [previewSelectedIdx, setPreviewSelectedIdx] = useState<number | null>(null);
  const [previewRevealed, setPreviewRevealed] = useState(false);
  const [previewLang, setPreviewLang] = useState<'en' | 'am'>(lang);

  const [formData, setFormData] = useState({
    moduleId: modules[0]?.id || '',
    questionEn: '',
    questionAm: '',
    optionsEn: ['', '', '', ''],
    optionsAm: ['', '', '', ''],
    correctIndex: 0,
    explanationEn: '',
    explanationAm: '',
  });

  // Keep preview language synchronized with current global language if not explicitly toggled
  useEffect(() => {
    setPreviewLang(lang);
  }, [lang]);

  // Lock body scroll when create/edit or preview modals are open
  useEffect(() => {
    if (isModalOpen || previewQuestion) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => {
      document.body.style.overflow = '';
    };
  }, [isModalOpen, previewQuestion]);

  // Helper to resolve parent module metadata
  const getModuleForQuestion = (q: QuizQuestion) => {
    return q.module || modules.find((m) => m.id === q.moduleId);
  };

  // Filtered Questions with Search & Module Selector
  const filteredQuestions = useMemo(() => {
    return questions.filter((q) => {
      // Module Filter
      if (selectedModuleId !== 'all' && q.moduleId !== selectedModuleId) {
        return false;
      }

      // Keyword Search Filter
      if (search.trim()) {
        const query = search.toLowerCase();
        const parentMod = getModuleForQuestion(q);
        const matchQuestion =
          q.questionEn.toLowerCase().includes(query) ||
          q.questionAm.toLowerCase().includes(query);
        const matchExplanation =
          q.explanationEn.toLowerCase().includes(query) ||
          q.explanationAm.toLowerCase().includes(query);
        const matchOptions =
          q.optionsEn.some((opt) => opt.toLowerCase().includes(query)) ||
          q.optionsAm.some((opt) => opt.toLowerCase().includes(query));
        const matchModule =
          parentMod?.titleEn?.toLowerCase().includes(query) ||
          parentMod?.titleAm?.toLowerCase().includes(query) ||
          parentMod?.category?.toLowerCase().includes(query);

        return matchQuestion || matchExplanation || matchOptions || Boolean(matchModule);
      }

      return true;
    });
  }, [questions, modules, selectedModuleId, search]);

  const openCreateModal = () => {
    setEditingQuestion(null);
    setFormData({
      moduleId: modules[0]?.id || '',
      questionEn: '',
      questionAm: '',
      optionsEn: ['', '', '', ''],
      optionsAm: ['', '', '', ''],
      correctIndex: 0,
      explanationEn: '',
      explanationAm: '',
    });
    setIsModalOpen(true);
  };

  const openEditModal = (q: QuizQuestion) => {
    setEditingQuestion(q);
    setFormData({
      moduleId: q.moduleId,
      questionEn: q.questionEn,
      questionAm: q.questionAm,
      optionsEn: [...q.optionsEn],
      optionsAm: [...q.optionsAm],
      correctIndex: q.correctIndex,
      explanationEn: q.explanationEn,
      explanationAm: q.explanationAm,
    });
    setIsModalOpen(true);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await onSaveQuestion(formData, editingQuestion ? editingQuestion.id : undefined);
    setIsModalOpen(false);
  };

  // Student Preview Player Handlers
  const openPreview = (q: QuizQuestion) => {
    setPreviewQuestion(q);
    setPreviewSelectedIdx(null);
    setPreviewRevealed(false);
    setPreviewLang(lang);
  };

  const handleSelectOption = (index: number) => {
    setPreviewSelectedIdx(index);
    setPreviewRevealed(true);
  };

  const handleResetPreview = () => {
    setPreviewSelectedIdx(null);
    setPreviewRevealed(false);
  };

  // 1-Click CSV Export
  const handleExportCsv = () => {
    exportToCsv(
      'Yegna_Health_Assessment_Quizzes',
      [
        { header: 'Question ID', accessor: (q) => q.id },
        { header: 'Module ID', accessor: (q) => q.moduleId },
        { header: 'Module Category', accessor: (q) => getModuleForQuestion(q)?.category || 'Curriculum' },
        { header: 'Module Title (EN)', accessor: (q) => getModuleForQuestion(q)?.titleEn || '' },
        { header: 'Module Title (AM)', accessor: (q) => getModuleForQuestion(q)?.titleAm || '' },
        { header: 'Question (English)', accessor: (q) => q.questionEn },
        { header: 'Question (Amharic)', accessor: (q) => q.questionAm },
        { header: 'Option 1 (EN)', accessor: (q) => q.optionsEn[0] || '' },
        { header: 'Option 1 (AM)', accessor: (q) => q.optionsAm[0] || '' },
        { header: 'Option 2 (EN)', accessor: (q) => q.optionsEn[1] || '' },
        { header: 'Option 2 (AM)', accessor: (q) => q.optionsAm[1] || '' },
        { header: 'Option 3 (EN)', accessor: (q) => q.optionsEn[2] || '' },
        { header: 'Option 3 (AM)', accessor: (q) => q.optionsAm[2] || '' },
        { header: 'Option 4 (EN)', accessor: (q) => q.optionsEn[3] || '' },
        { header: 'Option 4 (AM)', accessor: (q) => q.optionsAm[3] || '' },
        { header: 'Correct Index (0-3)', accessor: (q) => q.correctIndex },
        { header: 'Correct Letter', accessor: (q) => ['A', 'B', 'C', 'D'][q.correctIndex] || '' },
        { header: 'Correct Answer (EN)', accessor: (q) => q.optionsEn[q.correctIndex] || '' },
        { header: 'Correct Answer (AM)', accessor: (q) => q.optionsAm[q.correctIndex] || '' },
        { header: 'Clinical Explanation (EN)', accessor: (q) => q.explanationEn },
        { header: 'Clinical Explanation (AM)', accessor: (q) => q.explanationAm },
      ],
      filteredQuestions
    );
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            <HelpCircle className="text-brand-600 dark:text-cyan-400" size={24} />
            <span>{lang === 'am' ? 'የግንዛቤ መፈተሻ ጥያቄዎች እና ፈተናዎች ስቱዲዮ' : 'Interactive Quizzes & Assessments Studio'}</span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1">
            {lang === 'am'
              ? 'ለእያንዳንዱ የትምህርት ሞጁል 4 አማራጭ ያላቸውን የፈተና ጥያቄዎችና የትምህርት ማብራሪያዎችን ያስተዳድሩ እና ይፈትሹ።'
              : 'Create, test, and moderate multiple-choice clinical self-assessments with instant explanations for students.'}
          </p>
        </div>
        <div className="flex items-center gap-2 self-start sm:self-auto">
          <button
            onClick={handleExportCsv}
            className="flex items-center gap-1.5 px-3.5 py-2.5 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs md:text-sm font-bold rounded-xl border border-slate-200 dark:border-slate-700 transition-all cursor-pointer shadow-2xs"
            title={lang === 'am' ? 'የፈተና ጥያቄዎችን በCSV አውርድ' : 'Export assessment quizzes to CSV'}
          >
            <Download size={15} />
            <span>{lang === 'am' ? 'ሪፖርት (CSV)' : 'Export CSV'}</span>
          </button>
          <button
            onClick={openCreateModal}
            className="flex items-center gap-2 px-4 py-2.5 bg-brand-600 hover:bg-brand-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md shadow-brand-600/20 transition-all self-start sm:self-auto cursor-pointer"
          >
            <Plus size={16} />
            <span>{lang === 'am' ? '+ አዲስ ጥያቄ ጨምር' : '+ Add Quiz Question'}</span>
          </button>
        </div>
      </div>

      {/* Filter and Search Bar */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-3.5 sm:p-4 shadow-xs flex flex-col md:flex-row items-stretch md:items-center justify-between gap-3">
        <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-3 flex-1">
          {/* Search Input */}
          <div className="relative flex-1">
            <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 dark:text-slate-500" size={16} />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder={
                lang === 'am'
                  ? 'ጥያቄዎችን፣ መልሶችን ወይም ማብራሪያዎችን ፈልግ...'
                  : 'Search questions, answers, explanations...'
              }
              className="w-full pl-9 pr-8 py-2 text-xs md:text-sm rounded-xl border border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-800/60 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-hidden focus:border-brand-500 dark:focus:border-brand-400 transition-colors"
            />
            {search && (
              <button
                type="button"
                onClick={() => setSearch('')}
                className="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200"
              >
                <X size={14} />
              </button>
            )}
          </div>

          {/* Module Selector */}
          <div className="relative min-w-[220px]">
            <div className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none">
              <Filter size={14} />
            </div>
            <select
              value={selectedModuleId}
              onChange={(e) => setSelectedModuleId(e.target.value)}
              className="w-full pl-8 pr-8 py-2 text-xs md:text-sm rounded-xl border border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-800/60 text-slate-900 dark:text-white font-medium focus:outline-hidden focus:border-brand-500 transition-colors cursor-pointer appearance-none"
            >
              <option value="all">
                {lang === 'am' ? `ሁሉም ሞጁሎች (${questions.length})` : `All Modules (${questions.length})`}
              </option>
              {modules.map((m) => {
                const count = questions.filter((q) => q.moduleId === m.id).length;
                return (
                  <option key={m.id} value={m.id}>
                    {lang === 'am' ? m.titleAm : m.titleEn} ({count})
                  </option>
                );
              })}
            </select>
            <div className="absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-slate-400 text-xs">
              ▼
            </div>
          </div>
        </div>

        {/* Counter and Clear Filter Pill */}
        <div className="flex items-center justify-between md:justify-end gap-3 text-xs text-slate-500 dark:text-slate-400 pt-2 md:pt-0 border-t md:border-t-0 border-slate-100 dark:border-slate-800">
          <span>
            {lang === 'am'
              ? `${filteredQuestions.length} ከ ${questions.length} ጥያቄዎች ተገኝተዋል`
              : `Showing ${filteredQuestions.length} of ${questions.length} questions`}
          </span>

          {(search || selectedModuleId !== 'all') && (
            <button
              onClick={() => {
                setSearch('');
                setSelectedModuleId('all');
              }}
              className="text-xs font-bold text-brand-600 dark:text-cyan-400 hover:underline cursor-pointer"
            >
              {lang === 'am' ? 'ማጣሪያውን አጽዳ' : 'Reset Filters'}
            </button>
          )}
        </div>
      </div>

      {/* Questions Grid or Empty State */}
      {filteredQuestions.length === 0 ? (
        <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs">
          <EmptyState
            icon={HelpCircle}
            title={
              questions.length === 0
                ? (lang === 'am' ? 'ምንም የፈተና ጥያቄዎች አልተፈጠሩም' : 'No Quiz Questions Found')
                : (lang === 'am' ? 'ከፍለጋው ጋር የሚዛመድ ጥያቄ አልተገኘም' : 'No Matching Questions Found')
            }
            description={
              questions.length === 0
                ? (lang === 'am'
                    ? 'ተማሪዎች የጤና ግንዛቤያቸውን እንዲፈትሹ ጥያቄዎችንና ክሊኒካዊ ማብራሪያዎችን በማስገባት ይጀምሩ።'
                    : 'Create multiple-choice self-assessments with clinical explanations for students.')
                : (lang === 'am'
                    ? 'የፍለጋ ቃላትን ይቀይሩ ወይም ሁሉንም የትምህርት ሞጁሎች ይምረጡ።'
                    : 'Try adjusting your search query or selecting a different health module filter.')
            }
            actionLabel={
              questions.length === 0
                ? (lang === 'am' ? '+ አዲስ ጥያቄ ጨምር' : '+ Add Quiz Question')
                : undefined
            }
            onAction={questions.length === 0 ? openCreateModal : undefined}
            clearLabel={
              questions.length > 0 && (search || selectedModuleId !== 'all')
                ? (lang === 'am' ? 'ሁሉንም ጥያቄዎች አሳይ' : 'Clear Filters')
                : undefined
            }
            onClear={() => {
              setSearch('');
              setSelectedModuleId('all');
            }}
          />
        </div>
      ) : (
        <div className="space-y-4">
          {filteredQuestions.map((q, idx) => {
            const parentMod = getModuleForQuestion(q);
            return (
              <div
                key={q.id}
                className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-5 shadow-xs hover:border-slate-300 dark:hover:border-slate-700 transition-all"
              >
                <div className="flex items-start justify-between gap-3 mb-3">
                  <div className="flex flex-wrap items-center gap-2">
                    <span className="w-6 h-6 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 font-bold text-xs flex items-center justify-center">
                      {idx + 1}
                    </span>
                    <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-md bg-brand-50 dark:bg-brand-950/60 text-brand-700 dark:text-cyan-400 border border-brand-100 dark:border-brand-900/40">
                      {parentMod?.category || 'Curriculum'}
                    </span>
                    {parentMod && (
                      <span className="text-xs text-slate-500 dark:text-slate-400 font-medium">
                        • {lang === 'am' ? parentMod.titleAm : parentMod.titleEn}
                      </span>
                    )}
                  </div>

                  <div className="flex items-center gap-1.5">
                    {/* Interactive Test / Preview Button */}
                    <button
                      onClick={() => openPreview(q)}
                      className="flex items-center gap-1 px-2.5 py-1 bg-brand-50 dark:bg-brand-950/50 hover:bg-brand-100 dark:hover:bg-brand-900/50 text-brand-700 dark:text-cyan-300 rounded-lg text-xs font-bold transition-colors cursor-pointer border border-brand-200 dark:border-brand-900/40"
                      title={lang === 'am' ? 'ጥያቄውን እንደ ተማሪ ፈትን' : 'Test question as a student player'}
                    >
                      <PlayCircle size={14} />
                      <span className="hidden sm:inline">{lang === 'am' ? 'ሞክር' : 'Test Quiz'}</span>
                    </button>

                    {/* Edit Button */}
                    <button
                      onClick={() => openEditModal(q)}
                      className="p-1.5 text-slate-400 hover:text-brand-600 dark:hover:text-cyan-400 hover:bg-brand-50 dark:hover:bg-slate-800 rounded-lg transition-colors cursor-pointer"
                      title={lang === 'am' ? 'አርትዕ' : 'Edit question'}
                    >
                      <Edit2 size={15} />
                    </button>

                    {/* Delete Button */}
                    <button
                      onClick={() => setQuestionToDelete(q)}
                      className="p-1.5 text-slate-400 hover:text-rose-600 dark:hover:text-rose-400 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-lg transition-colors cursor-pointer"
                      title={lang === 'am' ? 'ጥያቄውን ሰርዝ' : 'Delete question'}
                    >
                      <Trash2 size={15} />
                    </button>
                  </div>
                </div>

                <h3 className="font-bold text-slate-900 dark:text-white text-sm md:text-base mb-1">
                  {lang === 'am' ? q.questionAm : q.questionEn}
                </h3>
                <p className="text-xs text-slate-400 dark:text-slate-500 mb-3">
                  {lang === 'am' ? q.questionEn : q.questionAm}
                </p>

                {/* Options Grid */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 mb-3">
                  {(lang === 'am' ? q.optionsAm : q.optionsEn).map((opt, oIdx) => {
                    const isCorrect = oIdx === q.correctIndex;
                    const letter = ['A', 'B', 'C', 'D'][oIdx];
                    return (
                      <div
                        key={oIdx}
                        className={`p-2.5 rounded-xl text-xs font-semibold flex items-center justify-between border transition-colors ${
                          isCorrect
                            ? 'bg-emerald-50 dark:bg-emerald-950/40 border-emerald-200 dark:border-emerald-800 text-emerald-900 dark:text-emerald-200 font-bold'
                            : 'bg-slate-50 dark:bg-slate-800/60 border-slate-200/70 dark:border-slate-700/60 text-slate-700 dark:text-slate-300'
                        }`}
                      >
                        <div className="flex items-center gap-2">
                          <span
                            className={`w-5 h-5 rounded-md flex items-center justify-center text-[10px] font-black ${
                              isCorrect
                                ? 'bg-emerald-200/80 dark:bg-emerald-800 text-emerald-900 dark:text-emerald-100'
                                : 'bg-slate-200/70 dark:bg-slate-700 text-slate-600 dark:text-slate-300'
                            }`}
                          >
                            {letter}
                          </span>
                          <span>{opt}</span>
                        </div>
                        {isCorrect && (
                          <div className="flex items-center gap-1 text-[11px] text-emerald-600 dark:text-emerald-400 font-bold flex-shrink-0">
                            <CheckCircle size={14} />
                            <span className="hidden xs:inline">
                              {lang === 'am' ? 'ትክክለኛ' : 'Correct'}
                            </span>
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>

                {/* Clinical Explanation Card */}
                <div className="p-3.5 bg-slate-50 dark:bg-slate-800/40 rounded-xl text-xs text-slate-600 dark:text-slate-300 border border-slate-200/70 dark:border-slate-800">
                  <span className="font-bold text-slate-900 dark:text-white flex items-center gap-1.5 mb-1">
                    <Sparkles size={14} className="text-amber-500" />
                    <span>{lang === 'am' ? 'የዶክተር ክሊኒካዊ ማብራሪያ፡' : 'Clinical Explanation & Rationale:'}</span>
                  </span>
                  <p className="leading-relaxed">
                    {lang === 'am' ? q.explanationAm : q.explanationEn}
                  </p>
                  <p className="mt-1 text-[11px] text-slate-400 dark:text-slate-500 italic">
                    {lang === 'am' ? q.explanationEn : q.explanationAm}
                  </p>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* Interactive Student Test Preview Player Modal */}
      {previewQuestion && (
        <div className="fixed inset-0 z-50 bg-slate-950/60 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-xl w-full max-h-[90vh] overflow-y-auto p-6 md:p-8 animate-in fade-in zoom-in-95">
            {/* Modal Header */}
            <div className="flex items-center justify-between pb-4 border-b border-slate-100 dark:border-slate-800">
              <div className="flex items-center gap-2.5">
                <div className="w-10 h-10 rounded-2xl bg-brand-50 dark:bg-brand-950/60 text-brand-600 dark:text-cyan-400 flex items-center justify-center shadow-2xs border border-brand-100 dark:border-brand-900/40">
                  <PlayCircle size={22} />
                </div>
                <div>
                  <h3 className="text-base md:text-lg font-extrabold text-slate-900 dark:text-white">
                    {lang === 'am' ? 'የተማሪ የፈተና ቅድመ-እይታ' : 'Interactive Assessment Studio Player'}
                  </h3>
                  <p className="text-xs text-slate-500 dark:text-slate-400">
                    {lang === 'am'
                      ? 'የተማሪዎችን ፈተና ቅድመ-እይታ እና ፈጣን ማብራሪያዎችን ይሞክሩ'
                      : 'Simulate student test taking with instant scoring and clinical feedback'}
                  </p>
                </div>
              </div>
              <button
                onClick={() => setPreviewQuestion(null)}
                className="p-1.5 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer"
              >
                <X size={20} />
              </button>
            </div>

            {/* Language Switcher Pill for Preview */}
            <div className="mt-4 flex items-center justify-between">
              <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-md bg-brand-50 dark:bg-brand-950/60 text-brand-700 dark:text-cyan-400 border border-brand-100 dark:border-brand-900/40">
                {getModuleForQuestion(previewQuestion)?.category || 'Health Assessment'}
              </span>

              <div className="flex items-center bg-slate-100 dark:bg-slate-800 rounded-xl p-0.5 border border-slate-200 dark:border-slate-700">
                <button
                  type="button"
                  onClick={() => setPreviewLang('en')}
                  className={`px-2.5 py-1 text-xs font-bold rounded-lg transition-all cursor-pointer ${
                    previewLang === 'en'
                      ? 'bg-white dark:bg-slate-700 text-brand-600 dark:text-cyan-300 shadow-2xs'
                      : 'text-slate-500 dark:text-slate-400 hover:text-slate-800'
                  }`}
                >
                  English
                </button>
                <button
                  type="button"
                  onClick={() => setPreviewLang('am')}
                  className={`px-2.5 py-1 text-xs font-bold rounded-lg transition-all cursor-pointer ${
                    previewLang === 'am'
                      ? 'bg-white dark:bg-slate-700 text-brand-600 dark:text-cyan-300 shadow-2xs'
                      : 'text-slate-500 dark:text-slate-400 hover:text-slate-800'
                  }`}
                >
                  አማርኛ
                </button>
              </div>
            </div>

            {/* Question Text */}
            <div className="mt-4">
              <h4 className="text-sm md:text-base font-extrabold text-slate-900 dark:text-white leading-snug">
                {previewLang === 'am' ? previewQuestion.questionAm : previewQuestion.questionEn}
              </h4>
              <p className="text-xs text-slate-400 dark:text-slate-500 mt-1 italic">
                {previewLang === 'am' ? previewQuestion.questionEn : previewQuestion.questionAm}
              </p>
            </div>

            {/* Interactive Options List */}
            <div className="mt-5 space-y-2.5">
              {(previewLang === 'am' ? previewQuestion.optionsAm : previewQuestion.optionsEn).map((opt, oIdx) => {
                const letter = ['A', 'B', 'C', 'D'][oIdx];
                const isSelected = previewSelectedIdx === oIdx;
                const isCorrect = oIdx === previewQuestion.correctIndex;

                let buttonStyle =
                  'bg-white dark:bg-slate-800/80 border-slate-200 dark:border-slate-700 text-slate-800 dark:text-slate-200 hover:border-brand-500 dark:hover:border-cyan-400 hover:bg-brand-50/20';

                if (previewRevealed) {
                  if (isCorrect) {
                    buttonStyle =
                      'bg-emerald-50 dark:bg-emerald-950/60 border-emerald-500 dark:border-emerald-500 text-emerald-950 dark:text-emerald-100 shadow-xs ring-1 ring-emerald-500/30';
                  } else if (isSelected && !isCorrect) {
                    buttonStyle =
                      'bg-rose-50 dark:bg-rose-950/60 border-rose-500 dark:border-rose-500 text-rose-950 dark:text-rose-100 ring-1 ring-rose-500/30';
                  } else {
                    buttonStyle =
                      'bg-slate-50 dark:bg-slate-800/30 border-slate-200/50 dark:border-slate-800 text-slate-400 dark:text-slate-500 opacity-60';
                  }
                }

                return (
                  <button
                    key={oIdx}
                    type="button"
                    onClick={() => handleSelectOption(oIdx)}
                    className={`w-full p-3.5 rounded-2xl text-xs md:text-sm font-semibold flex items-center justify-between border text-left transition-all cursor-pointer ${buttonStyle}`}
                  >
                    <div className="flex items-center gap-3">
                      <span
                        className={`w-6 h-6 rounded-lg flex items-center justify-center text-xs font-black transition-colors ${
                          previewRevealed && isCorrect
                            ? 'bg-emerald-600 text-white'
                            : previewRevealed && isSelected && !isCorrect
                            ? 'bg-rose-600 text-white'
                            : 'bg-slate-100 dark:bg-slate-700 text-slate-700 dark:text-slate-200'
                        }`}
                      >
                        {letter}
                      </span>
                      <span>{opt}</span>
                    </div>

                    {previewRevealed && isCorrect && (
                      <span className="flex items-center gap-1 text-emerald-600 dark:text-emerald-400 text-xs font-bold">
                        <CheckCircle2 size={16} />
                        <span>{previewLang === 'am' ? 'ትክክለኛ' : 'Correct'}</span>
                      </span>
                    )}

                    {previewRevealed && isSelected && !isCorrect && (
                      <span className="flex items-center gap-1 text-rose-600 dark:text-rose-400 text-xs font-bold">
                        <XCircle size={16} />
                        <span>{previewLang === 'am' ? 'የተሳሳተ' : 'Incorrect'}</span>
                      </span>
                    )}
                  </button>
                );
              })}
            </div>

            {/* Real-time Feedback Banner */}
            {previewRevealed && (
              <div
                className={`mt-4 p-3.5 rounded-2xl border text-xs md:text-sm font-bold flex items-start gap-2.5 animate-in fade-in duration-200 ${
                  previewSelectedIdx === previewQuestion.correctIndex
                    ? 'bg-emerald-50 dark:bg-emerald-950/40 border-emerald-200 dark:border-emerald-800 text-emerald-900 dark:text-emerald-200'
                    : 'bg-rose-50 dark:bg-rose-950/40 border-rose-200 dark:border-rose-800 text-rose-900 dark:text-rose-200'
                }`}
              >
                {previewSelectedIdx === previewQuestion.correctIndex ? (
                  <CheckCircle2 size={18} className="text-emerald-600 dark:text-emerald-400 flex-shrink-0 mt-0.5" />
                ) : (
                  <XCircle size={18} className="text-rose-600 dark:text-rose-400 flex-shrink-0 mt-0.5" />
                )}
                <div>
                  <p>
                    {previewSelectedIdx === previewQuestion.correctIndex
                      ? (previewLang === 'am'
                          ? 'ትክክል! የተረጋገጠ ክሊኒካዊ የጤና ትምህርት መልስ ነው።'
                          : 'Spot on! Clinically validated guidance and correct choice.')
                      : (previewLang === 'am'
                          ? 'ትክክል አይደለም። ከዚህ በታች ያለውን የዶክተር ማብራሪያ ያንብቡ።'
                          : 'Not quite. Please review the clinical reasoning below.')}
                  </p>
                </div>
              </div>
            )}

            {/* Revealed Clinical Explanation */}
            {previewRevealed && (
              <div className="mt-3 p-4 bg-slate-50 dark:bg-slate-800/50 rounded-2xl border border-slate-200/80 dark:border-slate-800 text-xs md:text-sm text-slate-700 dark:text-slate-300 leading-relaxed animate-in fade-in duration-200">
                <div className="font-extrabold text-slate-900 dark:text-white flex items-center gap-1.5 mb-1.5">
                  <BookOpen size={16} className="text-brand-600 dark:text-cyan-400" />
                  <span>{previewLang === 'am' ? 'የዶክተር ክሊኒካዊ ማብራሪያ' : 'Clinical Explanation & Rationale'}</span>
                </div>
                <p>{previewLang === 'am' ? previewQuestion.explanationAm : previewQuestion.explanationEn}</p>
                <p className="mt-2 text-xs text-slate-400 dark:text-slate-500 italic">
                  {previewLang === 'am' ? previewQuestion.explanationEn : previewQuestion.explanationAm}
                </p>
              </div>
            )}

            {/* Preview Controls */}
            <div className="mt-6 pt-4 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between gap-3">
              <button
                type="button"
                onClick={handleResetPreview}
                disabled={!previewRevealed}
                className="flex items-center gap-1.5 px-4 py-2 border border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-700 dark:text-slate-300 text-xs font-bold rounded-xl transition-all cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed"
              >
                <RotateCcw size={14} />
                <span>{previewLang === 'am' ? 'እንደገና ሞክር' : 'Reset / Try Again'}</span>
              </button>

              <button
                type="button"
                onClick={() => setPreviewQuestion(null)}
                className="px-5 py-2 bg-slate-900 hover:bg-slate-800 dark:bg-brand-600 dark:hover:bg-brand-700 text-white text-xs font-bold rounded-xl shadow-xs transition-all cursor-pointer"
              >
                {previewLang === 'am' ? 'ዝጋ' : 'Close Preview'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Create / Edit Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-950/60 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-xl w-full max-h-[90vh] overflow-y-auto p-6 md:p-8 animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between pb-3 border-b border-slate-100 dark:border-slate-800">
              <h3 className="text-lg font-extrabold text-slate-900 dark:text-white">
                {editingQuestion
                  ? (lang === 'am' ? 'የፈተና ጥያቄን አርትዕ' : 'Edit Quiz Question')
                  : (lang === 'am' ? 'አዲስ የፈተና ጥያቄ ጨምር' : 'Add New Quiz Question')}
              </h3>
              <button
                onClick={() => setIsModalOpen(false)}
                className="p-1 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer"
              >
                <X size={20} />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="mt-4 space-y-3.5 text-xs md:text-sm">
              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                  {lang === 'am' ? 'የትምህርት ሞጁል' : 'Parent Health Module'}
                </label>
                <select
                  value={formData.moduleId}
                  onChange={(e) => setFormData({ ...formData, moduleId: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white font-medium focus:outline-hidden focus:border-brand-500"
                >
                  {modules.map((m) => (
                    <option key={m.id} value={m.id}>
                      {m.titleEn} / {m.titleAm} ({m.category})
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                  Question (English)
                </label>
                <input
                  type="text"
                  required
                  value={formData.questionEn}
                  onChange={(e) => setFormData({ ...formData, questionEn: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:outline-hidden focus:border-brand-500"
                  placeholder="e.g. Which method protects against both pregnancy and STIs?"
                />
              </div>

              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                  ጥያቄ (በአማርኛ)
                </label>
                <input
                  type="text"
                  required
                  value={formData.questionAm}
                  onChange={(e) => setFormData({ ...formData, questionAm: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:outline-hidden focus:border-brand-500"
                  placeholder="ምሳሌ፡ ከአባላዘር በሽታዎችና ያልተፈለገ እርግዝና የሚከላከል የትኛው ነው?"
                />
              </div>

              <div className="space-y-2 pt-2">
                <div className="flex items-center justify-between">
                  <label className="block font-bold text-slate-700 dark:text-slate-300">
                    4 Multiple Choice Options (English)
                  </label>
                  <span className="text-[11px] text-slate-400">Select radio for correct answer</span>
                </div>
                {formData.optionsEn.map((opt, i) => (
                  <div key={i} className="flex items-center gap-2">
                    <input
                      type="radio"
                      name="correctIdx"
                      checked={formData.correctIndex === i}
                      onChange={() => setFormData({ ...formData, correctIndex: i })}
                      title="Mark as correct answer"
                      className="accent-brand-600 cursor-pointer"
                    />
                    <input
                      type="text"
                      required
                      placeholder={`Option ${i + 1} (${['A', 'B', 'C', 'D'][i]})`}
                      value={opt}
                      onChange={(e) => {
                        const next = [...formData.optionsEn];
                        next[i] = e.target.value;
                        setFormData({ ...formData, optionsEn: next });
                      }}
                      className="flex-1 px-3 py-1.5 border border-slate-200 dark:border-slate-700 rounded-lg text-xs bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:outline-hidden focus:border-brand-500"
                    />
                  </div>
                ))}
              </div>

              <div className="space-y-2 pt-2">
                <label className="block font-bold text-slate-700 dark:text-slate-300">
                  4 አማራጮች (በአማርኛ)
                </label>
                {formData.optionsAm.map((opt, i) => (
                  <div key={i} className="flex items-center gap-2">
                    <span className="text-xs text-slate-400 font-bold w-4">#{i + 1}</span>
                    <input
                      type="text"
                      required
                      placeholder={`አማራጭ ${i + 1} (${['ሀ', 'ለ', 'ሐ', 'መ'][i]})`}
                      value={opt}
                      onChange={(e) => {
                        const next = [...formData.optionsAm];
                        next[i] = e.target.value;
                        setFormData({ ...formData, optionsAm: next });
                      }}
                      className="flex-1 px-3 py-1.5 border border-slate-200 dark:border-slate-700 rounded-lg text-xs bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:outline-hidden focus:border-brand-500"
                    />
                  </div>
                ))}
              </div>

              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                  Clinical Explanation (English)
                </label>
                <textarea
                  rows={2}
                  required
                  value={formData.explanationEn}
                  onChange={(e) => setFormData({ ...formData, explanationEn: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl text-xs bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:outline-hidden focus:border-brand-500"
                  placeholder="Explain why the correct answer is valid based on clinical health guidance..."
                />
              </div>

              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                  የዶክተር ማብራሪያ (በአማርኛ)
                </label>
                <textarea
                  rows={2}
                  required
                  value={formData.explanationAm}
                  onChange={(e) => setFormData({ ...formData, explanationAm: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl text-xs bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:outline-hidden focus:border-brand-500"
                  placeholder="ትክክለኛውን መልስ ክሊኒካዊ ምክንያት በግልጽ ያብራሩ..."
                />
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-slate-100 dark:border-slate-800">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-4 py-2 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 font-bold rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800 cursor-pointer"
                >
                  {lang === 'am' ? 'ሰርዝ' : 'Cancel'}
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl shadow-md shadow-brand-600/20 cursor-pointer"
                >
                  {editingQuestion
                    ? (lang === 'am' ? 'ለውጦችን መዝግብ' : 'Save Changes')
                    : (lang === 'am' ? 'ጥያቄውን መዝግብ' : 'Save Question')}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      <ConfirmModal
        isOpen={Boolean(questionToDelete)}
        onClose={() => setQuestionToDelete(null)}
        onConfirm={async () => {
          if (questionToDelete) {
            await onDeleteQuestion(questionToDelete.id);
          }
        }}
        title={lang === 'am' ? 'የፈተና ጥያቄው ይሰረዝ?' : 'Delete Quiz Question?'}
        itemName={questionToDelete ? (lang === 'am' ? questionToDelete.questionAm || questionToDelete.questionEn : questionToDelete.questionEn) : ''}
        message={
          lang === 'am'
            ? 'ይህ ጥያቄ ከፈተናው ማህደር በቋሚነት ይሰረዛል። ተማሪዎች ይህንን ጥያቄ በፈተና ወቅት አያገኙትም።'
            : 'This multiple-choice clinical question and its explanation will be permanently deleted from the assessment bank.'
        }
        lang={lang}
      />
    </div>
  );
};
