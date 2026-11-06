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
  Filter,
  Check,
  AlertCircle,
  Layers,
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
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Search & Filter States
  const [search, setSearch] = useState('');
  const [selectedModuleId, setSelectedModuleId] = useState<string>('all');
  const [selectedType, setSelectedType] = useState<'all' | 'MULTIPLE_CHOICE' | 'TRUE_FALSE'>('all');

  // Interactive Student Preview Player States
  const [previewQuestion, setPreviewQuestion] = useState<QuizQuestion | null>(null);
  const [previewSelectedIdx, setPreviewSelectedIdx] = useState<number | null>(null);
  const [previewRevealed, setPreviewRevealed] = useState(false);
  const [previewLang, setPreviewLang] = useState<'en' | 'am'>(lang);

  const [formData, setFormData] = useState<{
    moduleId: string;
    type: 'MULTIPLE_CHOICE' | 'TRUE_FALSE';
    questionEn: string;
    questionAm: string;
    optionsEn: string[];
    optionsAm: string[];
    correctIndex: number;
    explanationEn: string;
    explanationAm: string;
  }>({
    moduleId: modules[0]?.id || '',
    type: 'MULTIPLE_CHOICE',
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

  // Helper to determine if question is True/False
  const isQuestionTrueFalse = (q: QuizQuestion) => {
    return q.type === 'TRUE_FALSE' || q.optionsEn?.length === 2;
  };

  // Filtered Questions with Search, Module & Type Selector
  const filteredQuestions = useMemo(() => {
    return questions.filter((q) => {
      // Module Filter
      if (selectedModuleId !== 'all' && q.moduleId !== selectedModuleId) {
        return false;
      }

      // Question Type Filter
      if (selectedType !== 'all') {
        const isTf = isQuestionTrueFalse(q);
        if (selectedType === 'TRUE_FALSE' && !isTf) return false;
        if (selectedType === 'MULTIPLE_CHOICE' && isTf) return false;
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
  }, [questions, modules, selectedModuleId, selectedType, search]);

  // Total counts for statistics chips
  const totalTfCount = useMemo(() => {
    return questions.filter((q) => isQuestionTrueFalse(q)).length;
  }, [questions]);

  const totalMcCount = useMemo(() => {
    return questions.filter((q) => !isQuestionTrueFalse(q)).length;
  }, [questions]);

  const openCreateModal = () => {
    setEditingQuestion(null);
    setFormData({
      moduleId: selectedModuleId !== 'all' ? selectedModuleId : (modules[0]?.id || ''),
      type: 'MULTIPLE_CHOICE',
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
    const qType: 'MULTIPLE_CHOICE' | 'TRUE_FALSE' =
      q.type === 'TRUE_FALSE' || q.optionsEn?.length === 2 ? 'TRUE_FALSE' : 'MULTIPLE_CHOICE';

    setFormData({
      moduleId: q.moduleId,
      type: qType,
      questionEn: q.questionEn,
      questionAm: q.questionAm,
      optionsEn:
        qType === 'TRUE_FALSE'
          ? q.optionsEn?.length === 2
            ? [...q.optionsEn]
            : ['True', 'False']
          : q.optionsEn?.length === 4
          ? [...q.optionsEn]
          : [...(q.optionsEn || []), '', '', ''].slice(0, 4),
      optionsAm:
        qType === 'TRUE_FALSE'
          ? q.optionsAm?.length === 2
            ? [...q.optionsAm]
            : ['እውነት', 'ሐሰት']
          : q.optionsAm?.length === 4
          ? [...q.optionsAm]
          : [...(q.optionsAm || []), '', '', ''].slice(0, 4),
      correctIndex: q.correctIndex >= 0 ? q.correctIndex : 0,
      explanationEn: q.explanationEn,
      explanationAm: q.explanationAm,
    });
    setIsModalOpen(true);
  };

  const handleTypeChange = (newType: 'MULTIPLE_CHOICE' | 'TRUE_FALSE') => {
    if (newType === 'TRUE_FALSE') {
      setFormData((prev) => ({
        ...prev,
        type: 'TRUE_FALSE',
        optionsEn: ['True', 'False'],
        optionsAm: ['እውነት', 'ሐሰት'],
        correctIndex: prev.correctIndex > 1 ? 0 : prev.correctIndex,
      }));
    } else {
      setFormData((prev) => ({
        ...prev,
        type: 'MULTIPLE_CHOICE',
        optionsEn: prev.optionsEn.length === 4 ? prev.optionsEn : ['', '', '', ''],
        optionsAm: prev.optionsAm.length === 4 ? prev.optionsAm : ['', '', '', ''],
        correctIndex: prev.correctIndex,
      }));
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    try {
      const payload: Partial<QuizQuestion> = {
        moduleId: formData.moduleId,
        type: formData.type,
        questionEn: formData.questionEn.trim(),
        questionAm: formData.questionAm.trim(),
        optionsEn: formData.optionsEn.map((o) => o.trim()),
        optionsAm: formData.optionsAm.map((o) => o.trim()),
        correctIndex: formData.correctIndex,
        explanationEn: formData.explanationEn.trim(),
        explanationAm: formData.explanationAm.trim(),
      };
      await onSaveQuestion(payload, editingQuestion ? editingQuestion.id : undefined);
      setIsModalOpen(false);
    } finally {
      setIsSubmitting(false);
    }
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
        { header: 'Format / Type', accessor: (q) => isQuestionTrueFalse(q) ? 'TRUE_FALSE' : 'MULTIPLE_CHOICE' },
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
        { header: 'Correct Index', accessor: (q) => q.correctIndex },
        {
          header: 'Correct Letter / Option',
          accessor: (q) =>
            isQuestionTrueFalse(q)
              ? q.correctIndex === 0 ? 'True' : 'False'
              : ['A', 'B', 'C', 'D'][q.correctIndex] || '',
        },
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
              ? 'ለእያንዳንዱ የትምህርት ሞጁል እውነት/ሐሰት ወይም ባለ 4 ምርጫ የፈተና ጥያቄዎችንና ክሊኒካዊ ማብራሪያዎችን ያስተዳድሩ እና ይፈትሹ።'
              : 'Create, test, and moderate True/False and Multiple-Choice clinical self-assessments with instant explanations.'}
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
          <div className="relative min-w-[210px]">
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

          {/* Question Type Filter */}
          <div className="relative min-w-[170px]">
            <div className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none">
              <Layers size={14} />
            </div>
            <select
              value={selectedType}
              onChange={(e) => setSelectedType(e.target.value as any)}
              className="w-full pl-8 pr-8 py-2 text-xs md:text-sm rounded-xl border border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-800/60 text-slate-900 dark:text-white font-medium focus:outline-hidden focus:border-brand-500 transition-colors cursor-pointer appearance-none"
            >
              <option value="all">
                {lang === 'am' ? `ሁሉም አይነቶች (${questions.length})` : `All Formats (${questions.length})`}
              </option>
              <option value="TRUE_FALSE">
                {lang === 'am' ? `እውነት / ሐሰት (${totalTfCount})` : `True / False (${totalTfCount})`}
              </option>
              <option value="MULTIPLE_CHOICE">
                {lang === 'am' ? `ባለ 4 ምርጫ (${totalMcCount})` : `Multiple Choice (${totalMcCount})`}
              </option>
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

          {(search || selectedModuleId !== 'all' || selectedType !== 'all') && (
            <button
              onClick={() => {
                setSearch('');
                setSelectedModuleId('all');
                setSelectedType('all');
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
                ? lang === 'am'
                  ? 'ምንም የፈተና ጥያቄዎች አልተፈጠሩም'
                  : 'No Quiz Questions Found'
                : lang === 'am'
                ? 'ከፍለጋው ጋር የሚዛመድ ጥያቄ አልተገኘም'
                : 'No Matching Questions Found'
            }
            description={
              questions.length === 0
                ? lang === 'am'
                  ? 'ተማሪዎች የጤና ግንዛቤያቸውን እንዲፈትሹ ጥያቄዎችንና ክሊኒካዊ ማብራሪያዎችን በማስገባት ይጀምሩ።'
                  : 'Create True/False or Multiple Choice self-assessments with clinical explanations for students.'
                : lang === 'am'
                ? 'የፍለጋ ቃላትን ይቀይሩ ወይም ሁሉንም የትምህርት ሞጁሎች ይምረጡ።'
                : 'Try adjusting your search query or resetting your filters.'
            }
            actionLabel={
              questions.length === 0
                ? lang === 'am'
                  ? '+ አዲስ ጥያቄ ጨምር'
                  : '+ Add Quiz Question'
                : undefined
            }
            onAction={questions.length === 0 ? openCreateModal : undefined}
            clearLabel={
              questions.length > 0 && (search || selectedModuleId !== 'all' || selectedType !== 'all')
                ? lang === 'am'
                  ? 'ሁሉንም ጥያቄዎች አሳይ'
                  : 'Clear Filters'
                : undefined
            }
            onClear={() => {
              setSearch('');
              setSelectedModuleId('all');
              setSelectedType('all');
            }}
          />
        </div>
      ) : (
        <div className="space-y-4">
          {filteredQuestions.map((q, idx) => {
            const parentMod = getModuleForQuestion(q);
            const isTf = isQuestionTrueFalse(q);
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

                    {/* Question Format Badge */}
                    {isTf ? (
                      <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-md bg-purple-50 dark:bg-purple-950/60 text-purple-700 dark:text-purple-300 border border-purple-200 dark:border-purple-900/40 flex items-center gap-1">
                        <span>●</span>
                        <span>{lang === 'am' ? 'እውነት / ሐሰት' : 'True / False'}</span>
                      </span>
                    ) : (
                      <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-md bg-cyan-50 dark:bg-cyan-950/60 text-cyan-700 dark:text-cyan-400 border border-cyan-200 dark:border-cyan-900/40 flex items-center gap-1">
                        <span>●</span>
                        <span>{lang === 'am' ? 'ባለ 4 ምርጫ' : 'Multiple Choice'}</span>
                      </span>
                    )}

                    <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-md bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 border border-slate-200 dark:border-slate-700">
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

                {/* Options Grid (2 tiles for True/False, 4 tiles for Multiple Choice) */}
                <div
                  className={`grid gap-2 mb-3 ${
                    isTf ? 'grid-cols-1 sm:grid-cols-2' : 'grid-cols-1 sm:grid-cols-2'
                  }`}
                >
                  {(lang === 'am' ? q.optionsAm : q.optionsEn).map((opt, oIdx) => {
                    const isCorrect = oIdx === q.correctIndex;
                    const letter = isTf ? (oIdx === 0 ? 'T' : 'F') : ['A', 'B', 'C', 'D'][oIdx];
                    return (
                      <div
                        key={oIdx}
                        className={`p-2.5 rounded-xl text-xs font-semibold flex items-center justify-between border transition-colors ${
                          isCorrect
                            ? 'bg-emerald-50 dark:bg-emerald-950/40 border-emerald-300 dark:border-emerald-800 text-emerald-900 dark:text-emerald-200 font-bold'
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
                    {previewLang === 'am' ? 'የተማሪ የፈተና ቅድመ-እይታ' : 'Interactive Assessment Studio Player'}
                  </h3>
                  <p className="text-xs text-slate-500 dark:text-slate-400">
                    {previewLang === 'am'
                      ? 'የተማሪዎችን ፈተና ቅድመ-እይታ እና ፈጣን ማብራሪያዎችን ይሞክሩ'
                      : 'Simulate student test taking with instant scoring and clinical feedback'}
                  </p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <button
                  type="button"
                  onClick={() => setPreviewLang(previewLang === 'en' ? 'am' : 'en')}
                  className="px-2.5 py-1 text-xs font-bold rounded-lg border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors cursor-pointer"
                >
                  {previewLang === 'en' ? 'አማርኛ' : 'English'}
                </button>
                <button
                  onClick={() => setPreviewQuestion(null)}
                  className="p-1.5 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer"
                >
                  <X size={20} />
                </button>
              </div>
            </div>

            {/* Question Details in Player */}
            <div className="mt-5 space-y-4">
              <div className="flex items-center gap-2">
                <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-md bg-brand-50 dark:bg-brand-950/60 text-brand-700 dark:text-cyan-400 border border-brand-100 dark:border-brand-900/40">
                  {getModuleForQuestion(previewQuestion)?.category || 'Curriculum'}
                </span>
                <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-md bg-purple-50 dark:bg-purple-950/60 text-purple-700 dark:text-purple-300 border border-purple-200 dark:border-purple-900/40">
                  {isQuestionTrueFalse(previewQuestion)
                    ? previewLang === 'am' ? 'እውነት / ሐሰት' : 'True / False'
                    : previewLang === 'am' ? 'ባለ 4 ምርጫ' : 'Multiple Choice'}
                </span>
              </div>

              <h4 className="text-base md:text-lg font-bold text-slate-900 dark:text-white leading-snug">
                {previewLang === 'am' ? previewQuestion.questionAm : previewQuestion.questionEn}
              </h4>

              {/* Options to click */}
              <div className="space-y-2.5 pt-2">
                {(previewLang === 'am' ? previewQuestion.optionsAm : previewQuestion.optionsEn).map(
                  (optText, optIdx) => {
                    const isSelected = previewSelectedIdx === optIdx;
                    const isCorrect = optIdx === previewQuestion.correctIndex;
                    const isTf = isQuestionTrueFalse(previewQuestion);
                    const letter = isTf ? (optIdx === 0 ? 'T' : 'F') : ['A', 'B', 'C', 'D'][optIdx];

                    let btnStyle =
                      'bg-slate-50 dark:bg-slate-800/60 border-slate-200 dark:border-slate-700/80 text-slate-800 dark:text-slate-200 hover:border-brand-500 hover:bg-brand-50/40 dark:hover:bg-brand-950/30';
                    let badgeStyle = 'bg-slate-200 dark:bg-slate-700 text-slate-700 dark:text-slate-300';

                    if (previewRevealed) {
                      if (isCorrect) {
                        btnStyle =
                          'bg-emerald-50 dark:bg-emerald-950/40 border-emerald-500 text-emerald-900 dark:text-emerald-100 font-bold';
                        badgeStyle = 'bg-emerald-500 text-white';
                      } else if (isSelected && !isCorrect) {
                        btnStyle =
                          'bg-rose-50 dark:bg-rose-950/40 border-rose-500 text-rose-900 dark:text-rose-100 font-bold';
                        badgeStyle = 'bg-rose-500 text-white';
                      } else {
                        btnStyle =
                          'bg-slate-50 dark:bg-slate-800/40 border-slate-200 dark:border-slate-800 text-slate-400 dark:text-slate-500 opacity-60';
                      }
                    }

                    return (
                      <button
                        key={optIdx}
                        type="button"
                        disabled={previewRevealed}
                        onClick={() => handleSelectOption(optIdx)}
                        className={`w-full p-3.5 rounded-2xl border text-left text-xs md:text-sm font-medium transition-all flex items-center justify-between gap-3 cursor-pointer disabled:cursor-default ${btnStyle}`}
                      >
                        <div className="flex items-center gap-3">
                          <span
                            className={`w-7 h-7 rounded-xl flex items-center justify-center font-bold text-xs flex-shrink-0 transition-all ${badgeStyle}`}
                          >
                            {letter}
                          </span>
                          <span>{optText}</span>
                        </div>

                        {previewRevealed && isCorrect && (
                          <div className="flex items-center gap-1 text-emerald-600 dark:text-emerald-400 text-xs font-bold flex-shrink-0">
                            <Check size={16} />
                            <span>{previewLang === 'am' ? 'ትክክለኛ' : 'Correct'}</span>
                          </div>
                        )}

                        {previewRevealed && isSelected && !isCorrect && (
                          <div className="flex items-center gap-1 text-rose-600 dark:text-rose-400 text-xs font-bold flex-shrink-0">
                            <AlertCircle size={16} />
                            <span>{previewLang === 'am' ? 'ስህተት' : 'Incorrect'}</span>
                          </div>
                        )}
                      </button>
                    );
                  }
                )}
              </div>

              {/* Instant Clinical Explanation Reveal */}
              {previewRevealed && (
                <div className="p-4 rounded-2xl bg-brand-50/60 dark:bg-brand-950/40 border border-brand-200 dark:border-brand-900/60 text-xs md:text-sm text-slate-800 dark:text-slate-200 space-y-1 animate-in fade-in">
                  <div className="flex items-center gap-1.5 font-bold text-brand-900 dark:text-cyan-300">
                    <Sparkles size={16} className="text-amber-500" />
                    <span>{previewLang === 'am' ? 'ክሊኒካዊ ማብራሪያ፡' : 'Medical Insight & Clinical Rationale:'}</span>
                  </div>
                  <p className="leading-relaxed text-slate-700 dark:text-slate-300">
                    {previewLang === 'am'
                      ? previewQuestion.explanationAm
                      : previewQuestion.explanationEn}
                  </p>
                </div>
              )}
            </div>

            {/* Modal Actions */}
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
                  ? lang === 'am'
                    ? 'የፈተና ጥያቄን አርትዕ'
                    : 'Edit Quiz Question'
                  : lang === 'am'
                  ? 'አዲስ የፈተና ጥያቄ ጨምር'
                  : 'Add New Quiz Question'}
              </h3>
              <button
                onClick={() => setIsModalOpen(false)}
                className="p-1 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer"
              >
                <X size={20} />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="mt-4 space-y-4 text-xs md:text-sm">
              {/* Parent Module Selector */}
              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                  {lang === 'am' ? 'የትምህርት ሞጁል' : 'Parent Health Module'}
                </label>
                <select
                  value={formData.moduleId}
                  onChange={(e) => setFormData({ ...formData, moduleId: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white font-medium focus:outline-hidden focus:border-brand-500 cursor-pointer"
                >
                  {modules.map((m) => (
                    <option key={m.id} value={m.id}>
                      {m.titleEn} / {m.titleAm} ({m.category})
                    </option>
                  ))}
                </select>
              </div>

              {/* Question Format Toggle (Multiple Choice vs True/False) */}
              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                  {lang === 'am' ? 'የጥያቄው አይነት' : 'Question Format & Type'}
                </label>
                <div className="grid grid-cols-2 gap-2 p-1 bg-slate-100 dark:bg-slate-800/80 rounded-xl border border-slate-200 dark:border-slate-700">
                  <button
                    type="button"
                    onClick={() => handleTypeChange('MULTIPLE_CHOICE')}
                    className={`py-2 px-3 rounded-lg text-xs font-bold transition-all flex items-center justify-center gap-2 cursor-pointer ${
                      formData.type === 'MULTIPLE_CHOICE'
                        ? 'bg-white dark:bg-slate-900 text-brand-600 dark:text-cyan-400 shadow-xs border border-slate-200/60 dark:border-slate-700'
                        : 'text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
                    }`}
                  >
                    <HelpCircle size={14} />
                    <span>{lang === 'am' ? 'ባለ 4 ምርጫ' : 'Multiple Choice (4 Options)'}</span>
                  </button>
                  <button
                    type="button"
                    onClick={() => handleTypeChange('TRUE_FALSE')}
                    className={`py-2 px-3 rounded-lg text-xs font-bold transition-all flex items-center justify-center gap-2 cursor-pointer ${
                      formData.type === 'TRUE_FALSE'
                        ? 'bg-white dark:bg-slate-900 text-purple-600 dark:text-purple-400 shadow-xs border border-slate-200/60 dark:border-slate-700'
                        : 'text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
                    }`}
                  >
                    <CheckCircle2 size={14} />
                    <span>{lang === 'am' ? 'እውነት / ሐሰት' : 'True / False (2 Options)'}</span>
                  </button>
                </div>
              </div>

              {/* Question Prompts */}
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

              {/* Conditional Options Editor based on format */}
              {formData.type === 'TRUE_FALSE' ? (
                /* True / False Visual Correct Answer Selector */
                <div className="space-y-2 pt-1">
                  <div className="flex items-center justify-between">
                    <label className="block font-bold text-slate-700 dark:text-slate-300">
                      {lang === 'am' ? 'ትክክለኛውን መልስ ይምረጡ' : 'Select Correct Answer'}
                    </label>
                    <span className="text-[11px] text-slate-400">
                      {lang === 'am' ? 'ትክክለኛውን መልስ ካርድ ይጫኑ' : 'Click the valid answer card'}
                    </span>
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    <button
                      type="button"
                      onClick={() => setFormData({ ...formData, correctIndex: 0 })}
                      className={`p-3.5 rounded-2xl border-2 text-center transition-all cursor-pointer ${
                        formData.correctIndex === 0
                          ? 'border-emerald-500 bg-emerald-50 dark:bg-emerald-950/40 text-emerald-900 dark:text-emerald-200 shadow-xs font-black'
                          : 'border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/60 text-slate-700 dark:text-slate-300 font-bold'
                      }`}
                    >
                      <div className="flex items-center justify-center gap-2 text-sm">
                        <CheckCircle
                          size={18}
                          className={
                            formData.correctIndex === 0
                              ? 'text-emerald-600 dark:text-emerald-400'
                              : 'text-slate-400'
                          }
                        />
                        <span>True / እውነት</span>
                      </div>
                      <p className="text-[11px] text-slate-500 dark:text-slate-400 mt-1">
                        {formData.correctIndex === 0
                          ? lang === 'am' ? '✓ ትክክለኛ መልስ' : '✓ Marked as correct'
                          : lang === 'am' ? 'ለመምረጥ ይጫኑ' : 'Click to set correct'}
                      </p>
                    </button>

                    <button
                      type="button"
                      onClick={() => setFormData({ ...formData, correctIndex: 1 })}
                      className={`p-3.5 rounded-2xl border-2 text-center transition-all cursor-pointer ${
                        formData.correctIndex === 1
                          ? 'border-emerald-500 bg-emerald-50 dark:bg-emerald-950/40 text-emerald-900 dark:text-emerald-200 shadow-xs font-black'
                          : 'border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/60 text-slate-700 dark:text-slate-300 font-bold'
                      }`}
                    >
                      <div className="flex items-center justify-center gap-2 text-sm">
                        <XCircle
                          size={18}
                          className={
                            formData.correctIndex === 1
                              ? 'text-emerald-600 dark:text-emerald-400'
                              : 'text-slate-400'
                          }
                        />
                        <span>False / ሐሰት</span>
                      </div>
                      <p className="text-[11px] text-slate-500 dark:text-slate-400 mt-1">
                        {formData.correctIndex === 1
                          ? lang === 'am' ? '✓ ትክክለኛ መልስ' : '✓ Marked as correct'
                          : lang === 'am' ? 'ለመምረጥ ይጫኑ' : 'Click to set correct'}
                      </p>
                    </button>
                  </div>
                </div>
              ) : (
                /* Multiple Choice 4 Options Editor */
                <>
                  <div className="space-y-2 pt-1">
                    <div className="flex items-center justify-between">
                      <label className="block font-bold text-slate-700 dark:text-slate-300">
                        4 Multiple Choice Options (English)
                      </label>
                      <span className="text-[11px] text-slate-400">
                        Select radio for correct answer
                      </span>
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

                  <div className="space-y-2 pt-1">
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
                </>
              )}

              {/* Clinical Explanations */}
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

              {/* Modal Buttons */}
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
                  disabled={isSubmitting}
                  className="px-5 py-2 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl shadow-md shadow-brand-600/20 cursor-pointer disabled:opacity-50"
                >
                  {isSubmitting
                    ? lang === 'am' ? 'በመመዝገብ ላይ...' : 'Saving...'
                    : editingQuestion
                    ? lang === 'am' ? 'ለውጦችን መዝግብ' : 'Save Changes'
                    : lang === 'am' ? 'ጥያቄውን መዝግብ' : 'Save Question'}
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
        itemName={
          questionToDelete
            ? lang === 'am'
              ? questionToDelete.questionAm || questionToDelete.questionEn
              : questionToDelete.questionEn
            : ''
        }
        message={
          lang === 'am'
            ? 'ይህ ጥያቄ ከፈተናው ማህደር በቋሚነት ይሰረዛል። ተማሪዎች ይህንን ጥያቄ በፈተና ወቅት አያገኙትም።'
            : 'This clinical self-assessment question and its explanation will be permanently deleted from the assessment bank.'
        }
        lang={lang}
      />
    </div>
  );
};
