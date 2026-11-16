import React, { useState, useMemo, useEffect } from 'react';
import {
  BookOpen,
  Plus,
  Edit2,
  Trash2,
  Clock,
  X,
  Edit3,
  Download,
  Bold,
  Heading2,
  List,
  Quote,
  Search,
  Sparkles,
  Image as ImageIcon,
  Lightbulb,
  Smartphone,
  LayoutTemplate,
} from 'lucide-react';
import { Module } from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';
import { ConfirmModal } from '../components/common/ConfirmModal.js';
import { EmptyState } from '../components/common/EmptyState.js';
import {
  CURRICULUM_TEMPLATES,
  OFFICIAL_ILLUSTRATIONS,
  CurriculumTemplate,
} from '../data/curriculumTemplates.js';
import { ModuleMobilePreview } from '../components/learning/ModuleMobilePreview.js';

interface LearningCmsPageProps {
  modules: Module[];
  lang: 'en' | 'am';
  onSave: (data: Partial<Module>, id?: string) => Promise<void>;
  onDelete: (id: string) => Promise<void>;
}

export const LearningCmsPage: React.FC<LearningCmsPageProps> = ({
  modules,
  lang,
  onSave,
  onDelete,
}) => {
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [search, setSearch] = useState('');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingModule, setEditingModule] = useState<Module | null>(null);
  const [moduleToDelete, setModuleToDelete] = useState<Module | null>(null);
  const [activeTab, setActiveTab] = useState<'en' | 'am'>('en');
  const [modalTab, setModalTab] = useState<'form' | 'preview'>('form');
  const [showTemplatePicker, setShowTemplatePicker] = useState(false);
  const [showImagePicker, setShowImagePicker] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const categories = [
    'All',
    'puberty',
    'srh',
    'sti',
    'hiv',
    'hepatitis',
    'mental_health',
    'gbv',
    'substance',
  ];

  const categoryLabels: Record<string, { en: string; am: string }> = {
    All: { en: 'All Topics', am: 'ሁሉም ዘርፎች' },
    puberty: { en: 'Puberty & Growth', am: 'ጉርምስና' },
    srh: { en: 'Reproductive Health', am: 'ሥነ-ተዋልዶ' },
    sti: { en: 'STI Prevention', am: 'የአባላዘር በሽታዎች' },
    hiv: { en: 'HIV & AIDS Prevention', am: 'ኤች.አይ.ቪ' },
    hepatitis: { en: 'Viral Hepatitis', am: 'የጉበት ቫይረስ' },
    mental_health: { en: 'Mental Health & Stress', am: 'አእምሮ ጤና' },
    gbv: { en: 'GBV & Consent', am: 'ጾታዊ ጥቃት' },
    substance: { en: 'Substance Abuse', am: 'የሱስ መከላከል' },
  };

  const [formData, setFormData] = useState({
    category: 'puberty',
    titleEn: '',
    titleAm: '',
    summaryEn: '',
    summaryAm: '',
    doctorNoteEn: '',
    doctorNoteAm: '',
    contentEn: '',
    contentAm: '',
    imageUrl: 'assets/images/learning/module_01_puberty.jpg',
    readTimeMin: 4,
    authorName: 'Dr. Hanna Bekele, Adolescent Specialist',
    isPublished: true,
    orderIndex: 1,
  });

  // Lock body scroll and capture Escape key when modal is open
  useEffect(() => {
    if (isModalOpen) {
      document.body.style.overflow = 'hidden';
      const handleKeyDown = (e: KeyboardEvent) => {
        if (e.key === 'Escape') {
          setIsModalOpen(false);
        }
      };
      window.addEventListener('keydown', handleKeyDown);
      return () => {
        document.body.style.overflow = '';
        window.removeEventListener('keydown', handleKeyDown);
      };
    } else {
      document.body.style.overflow = '';
    }
  }, [isModalOpen]);

  // Filter modules by category and full-text search
  const filtered = useMemo(() => {
    return modules.filter((m) => {
      if (selectedCategory !== 'All' && m.category !== selectedCategory) {
        return false;
      }

      if (search.trim()) {
        const query = search.toLowerCase();
        const matchTitle =
          m.titleEn.toLowerCase().includes(query) ||
          m.titleAm.toLowerCase().includes(query);
        const matchSummary =
          m.summaryEn.toLowerCase().includes(query) ||
          m.summaryAm.toLowerCase().includes(query);
        const matchContent =
          m.contentEn.toLowerCase().includes(query) ||
          m.contentAm.toLowerCase().includes(query);
        const matchAuthor = m.authorName?.toLowerCase().includes(query);
        const matchCategory = m.category.toLowerCase().includes(query);

        return (
          matchTitle ||
          matchSummary ||
          matchContent ||
          Boolean(matchAuthor) ||
          matchCategory
        );
      }

      return true;
    });
  }, [modules, selectedCategory, search]);

  const extractNoteFromMarkdown = (content: string): string => {
    const match = content.match(
      />\s*(?:(?:Clinical Tip|Medical Note|የዶክተር ማስታወሻ|Note):\s*)?([^\n\r]+)/i
    );
    return match ? match[1].trim() : '';
  };

  const openCreateModal = () => {
    setEditingModule(null);
    setModalTab('form');
    setShowTemplatePicker(false);
    setShowImagePicker(false);
    // Auto-select Puberty template as initial starting scaffold
    const defaultTemplate = CURRICULUM_TEMPLATES[0];
    setFormData({
      category: defaultTemplate.category,
      titleEn: defaultTemplate.titleEn,
      titleAm: defaultTemplate.titleAm,
      summaryEn: defaultTemplate.summaryEn,
      summaryAm: defaultTemplate.summaryAm,
      doctorNoteEn: defaultTemplate.doctorNoteEn,
      doctorNoteAm: defaultTemplate.doctorNoteAm,
      contentEn: defaultTemplate.contentEn,
      contentAm: defaultTemplate.contentAm,
      imageUrl: defaultTemplate.imageAsset,
      readTimeMin: defaultTemplate.readTimeMin,
      authorName: defaultTemplate.authorName,
      isPublished: true,
      orderIndex: modules.length + 1,
    });
    setIsModalOpen(true);
  };

  const openEditModal = (m: Module) => {
    setEditingModule(m);
    setModalTab('form');
    setShowTemplatePicker(false);
    setShowImagePicker(false);

    const fallbackImg =
      OFFICIAL_ILLUSTRATIONS.find((i) => i.id === m.category)?.path ||
      'assets/images/learning/module_01_puberty.jpg';

    setFormData({
      category: m.category,
      titleEn: m.titleEn,
      titleAm: m.titleAm,
      summaryEn: m.summaryEn,
      summaryAm: m.summaryAm,
      doctorNoteEn:
        m.doctorNoteEn || extractNoteFromMarkdown(m.contentEn || ''),
      doctorNoteAm:
        m.doctorNoteAm || extractNoteFromMarkdown(m.contentAm || ''),
      contentEn: m.contentEn,
      contentAm: m.contentAm,
      imageUrl: m.imageUrl || fallbackImg,
      readTimeMin: m.readTimeMin,
      authorName: m.authorName || '',
      isPublished: m.isPublished,
      orderIndex: m.orderIndex,
    });
    setIsModalOpen(true);
  };

  const applyTemplate = (template: CurriculumTemplate) => {
    setFormData((prev) => ({
      ...prev,
      category: template.category,
      titleEn: template.titleEn,
      titleAm: template.titleAm,
      summaryEn: template.summaryEn,
      summaryAm: template.summaryAm,
      doctorNoteEn: template.doctorNoteEn,
      doctorNoteAm: template.doctorNoteAm,
      contentEn: template.contentEn,
      contentAm: template.contentAm,
      imageUrl: template.imageAsset,
      readTimeMin: template.readTimeMin,
      authorName: template.authorName,
    }));
    setShowTemplatePicker(false);
  };

  const handleExportCsv = () => {
    exportToCsv(
      'Yegna_Health_Curriculum_Modules',
      [
        { header: 'Title (English)', accessor: (m) => m.titleEn },
        { header: 'Title (Amharic)', accessor: (m) => m.titleAm },
        { header: 'Category', accessor: (m) => m.category },
        { header: 'Read Time (Minutes)', accessor: (m) => m.readTimeMin },
        {
          header: 'Author Attribution',
          accessor: (m) => m.authorName || 'Medical Review Team',
        },
        { header: 'Summary (English)', accessor: (m) => m.summaryEn },
        { header: 'Summary (Amharic)', accessor: (m) => m.summaryAm },
        {
          header: 'Publication Status',
          accessor: (m) => (m.isPublished ? 'PUBLISHED' : 'DRAFT'),
        },
      ],
      filtered
    );
  };

  const insertMarkdown = (syntaxPrefix: string, syntaxSuffix = '') => {
    if (activeTab === 'en') {
      setFormData((prev) => ({
        ...prev,
        contentEn: `${prev.contentEn}\n${syntaxPrefix}Sample Text${syntaxSuffix}`,
      }));
    } else {
      setFormData((prev) => ({
        ...prev,
        contentAm: `${prev.contentAm}\n${syntaxPrefix}ምሳሌ ጽሑፍ${syntaxSuffix}`,
      }));
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (isSubmitting) return;
    try {
      setIsSubmitting(true);
      await onSave(formData, editingModule ? editingModule.id : undefined);
      setIsModalOpen(false);
    } finally {
      setIsSubmitting(false);
    }
  };

  // Resolve thumbnail preview URL for form display
  const currentThumbnailUrl = useMemo(() => {
    if (!formData.imageUrl) return '/illustrations/module_01_puberty.jpg';
    if (formData.imageUrl.startsWith('http://') || formData.imageUrl.startsWith('https://')) {
      return formData.imageUrl;
    }
    const filename = formData.imageUrl.split('/').pop();
    return `/illustrations/${filename}`;
  }, [formData.imageUrl]);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            <BookOpen className="text-brand-600 dark:text-cyan-400" size={24} />
            <span>
              {lang === 'am'
                ? 'የትምህርት ሞጁሎችና የዶክተር ማስታወሻዎች'
                : 'Health Curriculum CMS'}
            </span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1">
            {lang === 'am'
              ? 'የጉርምስና፣ የሥነ-ተዋልዶ፣ የኤች.አይ.ቪና የአእምሮ ጤና ትምህርቶችን በአብነቶች አማካኝነት ያዘጋጁ።'
              : 'Draft, publish, and update bilingual medical education verified for Ethiopian youth with professional templates.'}
          </p>
        </div>

        <div className="flex items-center gap-2 self-start sm:self-auto">
          <button
            onClick={handleExportCsv}
            className="flex items-center gap-1.5 px-3.5 py-2.5 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs md:text-sm font-bold rounded-xl border border-slate-200 dark:border-slate-700 transition-all cursor-pointer shadow-2xs"
            title={
              lang === 'am'
                ? 'የትምህርት ሞጁሎች ሪፖርት አውርድ'
                : 'Export curriculum to Excel CSV'
            }
          >
            <Download size={15} />
            <span>{lang === 'am' ? 'ሪፖርት (CSV)' : 'Export CSV'}</span>
          </button>
          <button
            onClick={openCreateModal}
            className="flex items-center gap-2 px-4 py-2.5 bg-brand-600 hover:bg-brand-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md shadow-brand-600/20 transition-all cursor-pointer"
          >
            <Plus size={16} />
            <span>
              {lang === 'am' ? '+ አዲስ ትምህርት ጨምር' : '+ New Health Module'}
            </span>
          </button>
        </div>
      </div>

      {/* Search & Topic Filter Bar */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-3.5 sm:p-4 shadow-xs space-y-3">
        {/* Search Input & Live Metrics */}
        <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3">
          <div className="relative flex-1">
            <Search
              className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 dark:text-slate-500"
              size={16}
            />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder={
                lang === 'am'
                  ? 'ሞጁሎችን በርዕስ፣ በማጠቃለያ ወይም በደራሲ ፈልግ...'
                  : 'Search modules by title, summary, content, or author...'
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

          <div className="flex items-center justify-between sm:justify-end gap-3 text-xs text-slate-500 dark:text-slate-400">
            <span>
              {lang === 'am'
                ? `${filtered.length} ከ ${modules.length} ሞጁሎች ተገኝተዋል`
                : `Showing ${filtered.length} of ${modules.length} modules`}
            </span>

            {(search || selectedCategory !== 'All') && (
              <button
                onClick={() => {
                  setSearch('');
                  setSelectedCategory('All');
                }}
                className="text-brand-600 dark:text-cyan-400 font-bold hover:underline cursor-pointer"
              >
                {lang === 'am' ? 'አጣራዎችን አጽዳ' : 'Reset'}
              </button>
            )}
          </div>
        </div>

        {/* Category Pills Bar */}
        <div className="flex items-center gap-1.5 overflow-x-auto pb-1 pt-1 scrollbar-none">
          {categories.map((cat) => {
            const isSelected = selectedCategory === cat;
            const label = categoryLabels[cat]
              ? lang === 'am'
                ? categoryLabels[cat].am
                : categoryLabels[cat].en
              : cat;

            const count =
              cat === 'All'
                ? modules.length
                : modules.filter((m) => m.category === cat).length;

            return (
              <button
                key={cat}
                onClick={() => setSelectedCategory(cat)}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold whitespace-nowrap transition-all cursor-pointer ${
                  isSelected
                    ? 'bg-brand-600 text-white shadow-xs'
                    : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-700'
                }`}
              >
                <span>{label}</span>
                <span
                  className={`text-[10px] px-1.5 py-0.2 rounded-full font-bold ${
                    isSelected
                      ? 'bg-white/20 text-white'
                      : 'bg-slate-200 dark:bg-slate-700 text-slate-600 dark:text-slate-300'
                  }`}
                >
                  {count}
                </span>
              </button>
            );
          })}
        </div>
      </div>

      {/* Modules Grid */}
      {filtered.length === 0 ? (
        <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200/80 dark:border-slate-800 p-8 shadow-xs">
          <EmptyState
            icon={BookOpen}
            title={
              modules.length === 0
                ? (lang === 'am'
                    ? 'ምንም የተመዘገበ የትምህርት ሞጁል የለም'
                    : 'No Health Modules Registered')
                : (lang === 'am'
                    ? 'ከፍለጋዎ ጋር የሚዛመድ ሞጁል አልተገኘም'
                    : 'No Matching Health Modules')
            }
            description={
              modules.length === 0
                ? (lang === 'am'
                    ? 'የመጀመሪያውን የጤና ትምህርት ሞጁል በአብነት ወይም በራስዎ ማብራሪያ ይፍጠሩ።'
                    : 'Create your first youth curriculum module using verified templates or custom lessons.')
                : (lang === 'am'
                    ? 'እባክዎ የፍለጋ ቃላትን ይቀይሩ ወይም ሌላ የጤና ዘርፍ ይምረጡ።'
                    : 'Try adjusting your search query or selecting a different health topic category.')
            }
            actionLabel={
              modules.length === 0
                ? (lang === 'am' ? '+ አዲስ ትምህርት ጨምር' : '+ New Health Module')
                : undefined
            }
            onAction={modules.length === 0 ? openCreateModal : undefined}
            clearLabel={
              modules.length > 0 && (search || selectedCategory !== 'All')
                ? (lang === 'am' ? 'ሁሉንም ሞጁሎች አሳይ' : 'Clear Filters')
                : undefined
            }
            onClear={() => {
              setSearch('');
              setSelectedCategory('All');
            }}
          />
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
          {filtered.map((m) => {
            const cardImgUrl = m.imageUrl
              ? m.imageUrl.startsWith('http')
                ? m.imageUrl
                : `/illustrations/${m.imageUrl.split('/').pop()}`
              : `/illustrations/${OFFICIAL_ILLUSTRATIONS.find((i) => i.id === m.category)?.path.split('/').pop() || 'module_01_puberty.jpg'}`;

            return (
              <div
                key={m.id}
                className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-5 shadow-xs hover:border-slate-300 dark:hover:border-slate-700 transition-all flex flex-col justify-between"
              >
                <div>
                  <div className="flex items-start justify-between gap-3 mb-3">
                    <span className="text-[10px] font-extrabold uppercase px-2.5 py-0.5 rounded-md bg-brand-50 dark:bg-brand-950/60 text-brand-700 dark:text-cyan-400 border border-brand-100 dark:border-brand-900/40">
                      {categoryLabels[m.category]
                        ? lang === 'am'
                          ? categoryLabels[m.category].am
                          : categoryLabels[m.category].en
                        : m.category}
                    </span>
                    <div className="flex items-center gap-1">
                      <button
                        onClick={() => openEditModal(m)}
                        className="p-1.5 text-slate-400 hover:text-brand-600 dark:hover:text-cyan-400 hover:bg-slate-50 dark:hover:bg-slate-800 rounded-lg cursor-pointer transition-colors"
                        title={lang === 'am' ? 'አርትዕ' : 'Edit module'}
                      >
                        <Edit2 size={14} />
                      </button>
                      <button
                        onClick={() => setModuleToDelete(m)}
                        className="p-1.5 text-slate-400 hover:text-rose-600 dark:hover:text-rose-400 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-lg cursor-pointer transition-colors"
                        title={lang === 'am' ? 'ሞጁሉን ሰርዝ' : 'Delete module'}
                      >
                        <Trash2 size={14} />
                      </button>
                    </div>
                  </div>

                  <div className="flex items-start gap-3.5 mb-2">
                    <div className="w-16 h-16 rounded-xl bg-slate-50 dark:bg-slate-800 border border-slate-100 dark:border-slate-700/60 overflow-hidden shrink-0 flex items-center justify-center p-1">
                      <img
                        src={cardImgUrl}
                        alt=""
                        className="w-full h-full object-contain"
                        onError={(e) => {
                          (e.target as HTMLImageElement).src =
                            '/illustrations/module_01_puberty.jpg';
                        }}
                      />
                    </div>
                    <div className="min-w-0 flex-1">
                      <h3 className="font-extrabold text-slate-900 dark:text-white text-base leading-tight mb-1">
                        {lang === 'am' ? m.titleAm : m.titleEn}
                      </h3>
                      <p className="text-xs text-slate-400 dark:text-slate-500 truncate mb-1">
                        {lang === 'am' ? m.titleEn : m.titleAm}
                      </p>
                    </div>
                  </div>

                  <p className="text-xs text-slate-600 dark:text-slate-300 line-clamp-2 leading-relaxed">
                    {lang === 'am' ? m.summaryAm : m.summaryEn}
                  </p>
                </div>

                <div className="pt-4 mt-4 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between text-xs text-slate-400 dark:text-slate-500">
                  <span className="flex items-center gap-1 font-semibold text-slate-600 dark:text-slate-300">
                    <Clock
                      size={13}
                      className="text-slate-400 dark:text-slate-500"
                    />
                    {m.readTimeMin} min read
                  </span>
                  <span className="text-[11px] truncate max-w-[180px]">
                    {m.authorName || 'Medical Review Team'}
                  </span>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* Editor Modal with Template Picker and Mobile Live Preview */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-950/70 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4">
          <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-5xl w-full max-h-[94vh] flex flex-col overflow-hidden animate-in fade-in zoom-in-95">
            {/* Modal Header */}
            <div className="px-6 py-4 border-b border-slate-100 dark:border-slate-800 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-2xl bg-brand-50 dark:bg-brand-950/60 text-brand-600 dark:text-cyan-400 flex items-center justify-center">
                  <BookOpen size={20} />
                </div>
                <div>
                  <h3 className="text-base sm:text-lg font-extrabold text-slate-900 dark:text-white">
                    {editingModule
                      ? (lang === 'am'
                          ? 'የትምህርት ሞጁልን አርትዕ'
                          : 'Edit Health Curriculum Module')
                      : (lang === 'am'
                          ? 'አዲስ የትምህርት ሞጁል ፍጠር'
                          : 'Create Health Curriculum Module')}
                  </h3>
                  <p className="text-xs text-slate-400 dark:text-slate-500">
                    {lang === 'am'
                      ? 'የተሟላ የጤና ትምህርት፣ የዶክተር ማስታወሻና ስዕላዊ መግለጫዎችን ያዘጋጁ'
                      : 'Author bilingual medical education with clinical templates & mobile preview'}
                  </p>
                </div>
              </div>

              <div className="flex items-center gap-2">
                {/* View Mode Toggle: Form vs Live Mobile Preview */}
                <div className="flex items-center bg-slate-100 dark:bg-slate-800 p-1 rounded-xl text-xs font-bold border border-slate-200 dark:border-slate-700">
                  <button
                    type="button"
                    onClick={() => setModalTab('form')}
                    className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg transition-all cursor-pointer ${
                      modalTab === 'form'
                        ? 'bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-xs'
                        : 'text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
                    }`}
                  >
                    <Edit3 size={13} />
                    <span>{lang === 'am' ? 'አዘጋጅ' : 'Editor'}</span>
                  </button>
                  <button
                    type="button"
                    onClick={() => setModalTab('preview')}
                    className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg transition-all cursor-pointer ${
                      modalTab === 'preview'
                        ? 'bg-white dark:bg-slate-700 text-brand-700 dark:text-cyan-300 shadow-xs'
                        : 'text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
                    }`}
                  >
                    <Smartphone size={13} />
                    <span>{lang === 'am' ? 'የሞባይል እይታ' : 'Mobile Preview'}</span>
                  </button>
                </div>

                <button
                  onClick={() => setIsModalOpen(false)}
                  className="p-1.5 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800 cursor-pointer"
                >
                  <X size={20} />
                </button>
              </div>
            </div>

            {/* Modal Body: Form or Mobile Phone Simulator */}
            <div className="flex-1 overflow-y-auto p-5 sm:p-6">
              {modalTab === 'preview' ? (
                /* LIVE MOBILE PREVIEW (REPLICATING IMAGE 2 EXACTLY) */
                <div className="space-y-4">
                  <div className="flex items-center justify-between bg-blue-50/70 dark:bg-blue-950/40 border border-blue-200 dark:border-blue-900/50 rounded-2xl p-3.5 text-xs text-blue-900 dark:text-blue-300">
                    <div className="flex items-center gap-2">
                      <Smartphone size={16} className="text-brand-600 shrink-0" />
                      <span>
                        {lang === 'am'
                          ? 'ይህ የቀጥታ ቅድመ-እይታ ተማሪዎች በሞባይል ስልካቸው ላይ የሚያዩትን ትክክለኛ ገጽታ ያሳያል።'
                          : 'Live Interactive Mobile Preview: Exactly how this module appears on students\' phones.'}
                      </span>
                    </div>

                    <div className="flex items-center gap-1">
                      <button
                        type="button"
                        onClick={() => setActiveTab('en')}
                        className={`px-2.5 py-1 rounded-lg text-xs font-bold ${
                          activeTab === 'en'
                            ? 'bg-brand-600 text-white'
                            : 'bg-white dark:bg-slate-800 text-slate-700 dark:text-slate-300'
                        }`}
                      >
                        English
                      </button>
                      <button
                        type="button"
                        onClick={() => setActiveTab('am')}
                        className={`px-2.5 py-1 rounded-lg text-xs font-bold ${
                          activeTab === 'am'
                            ? 'bg-brand-600 text-white'
                            : 'bg-white dark:bg-slate-800 text-slate-700 dark:text-slate-300'
                        }`}
                      >
                        አማርኛ
                      </button>
                    </div>
                  </div>

                  <ModuleMobilePreview
                    title={activeTab === 'am' ? formData.titleAm : formData.titleEn}
                    summary={activeTab === 'am' ? formData.summaryAm : formData.summaryEn}
                    content={activeTab === 'am' ? formData.contentAm : formData.contentEn}
                    doctorNote={activeTab === 'am' ? formData.doctorNoteAm : formData.doctorNoteEn}
                    imageUrl={formData.imageUrl}
                    authorName={formData.authorName}
                    readTimeMin={formData.readTimeMin}
                    category={formData.category}
                    lang={activeTab}
                  />
                </div>
              ) : (
                /* FORM EDITOR */
                <form onSubmit={handleSubmit} className="space-y-5 text-xs md:text-sm">
                  {/* Template Inserter Toolbar */}
                  <div className="bg-gradient-to-r from-brand-50 to-indigo-50 dark:from-slate-800/80 dark:to-brand-950/40 border border-brand-200/80 dark:border-brand-900/50 rounded-2xl p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                    <div className="flex items-center gap-2.5">
                      <div className="w-8 h-8 rounded-xl bg-brand-600 text-white flex items-center justify-center shrink-0 shadow-xs">
                        <Sparkles size={16} />
                      </div>
                      <div>
                        <h4 className="font-extrabold text-slate-900 dark:text-white text-sm">
                          {lang === 'am'
                            ? 'የተሟሉ የህክምና አብነቶች (Templates)'
                            : 'Professional Curriculum Templates'}
                        </h4>
                        <p className="text-[11px] text-slate-600 dark:text-slate-400">
                          {lang === 'am'
                            ? 'በአንድ ጠቅታ የተዘጋጀ የጉርምስና፣ የሥነ-ተዋልዶ ወይም የኤች.አይ.ቪ ትምህርት ይምረጡ'
                            : 'Auto-fill verified clinical texts, doctor note, illustration, and 4 sections'}
                        </p>
                      </div>
                    </div>

                    <button
                      type="button"
                      onClick={() => setShowTemplatePicker(!showTemplatePicker)}
                      className="px-3.5 py-2 bg-brand-600 hover:bg-brand-700 text-white rounded-xl text-xs font-bold flex items-center justify-center gap-1.5 shadow-sm transition-all cursor-pointer self-start sm:self-auto"
                    >
                      <LayoutTemplate size={14} />
                      <span>
                        {showTemplatePicker
                          ? (lang === 'am' ? 'አብነቶችን ዝጋ' : 'Close Templates')
                          : (lang === 'am' ? 'አብነት ምረጥ (Templates)' : 'Browse Clinical Templates')}
                      </span>
                    </button>
                  </div>

                  {/* Template Picker Drawer */}
                  {showTemplatePicker && (
                    <div className="bg-white dark:bg-slate-900 border border-brand-300 dark:border-brand-800 rounded-2xl p-4 shadow-lg animate-in fade-in slide-in-from-top-2">
                      <div className="flex items-center justify-between mb-3 pb-2 border-b border-slate-100 dark:border-slate-800">
                        <span className="text-xs font-bold text-slate-700 dark:text-slate-300">
                          {lang === 'am'
                            ? 'ሊተገብሩት የሚፈልጉትን የትምህርት አብነት ይምረጡ፡'
                            : 'Select a clinical template to auto-populate the form:'}
                        </span>
                        <button
                          type="button"
                          onClick={() => setShowTemplatePicker(false)}
                          className="text-slate-400 hover:text-slate-600"
                        >
                          <X size={15} />
                        </button>
                      </div>

                      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-3 max-h-64 overflow-y-auto p-1">
                        {CURRICULUM_TEMPLATES.map((tmpl) => (
                          <button
                            key={tmpl.id}
                            type="button"
                            onClick={() => applyTemplate(tmpl)}
                            className="text-left p-3 rounded-xl border border-slate-200 dark:border-slate-800 bg-slate-50/70 dark:bg-slate-800/50 hover:border-brand-500 hover:bg-brand-50/40 dark:hover:bg-slate-800 transition-all cursor-pointer group flex flex-col justify-between"
                          >
                            <div>
                              <div className="flex items-center justify-between gap-1 mb-1">
                                <span className="text-[10px] font-extrabold uppercase text-brand-600 dark:text-cyan-400">
                                  {tmpl.category}
                                </span>
                                <span className="text-[10px] text-slate-400">
                                  {tmpl.readTimeMin} min
                                </span>
                              </div>
                              <h5 className="font-extrabold text-slate-900 dark:text-white text-xs mb-1 group-hover:text-brand-600 dark:group-hover:text-cyan-400">
                                {lang === 'am' ? tmpl.nameAm : tmpl.nameEn}
                              </h5>
                              <p className="text-[11px] text-slate-500 dark:text-slate-400 line-clamp-2">
                                {lang === 'am' ? tmpl.summaryAm : tmpl.summaryEn}
                              </p>
                            </div>
                            <span className="mt-2 text-[10px] font-bold text-brand-600 dark:text-cyan-400 flex items-center gap-1">
                              <span>{lang === 'am' ? 'ተግብር' : 'Apply'}</span>
                              <span>→</span>
                            </span>
                          </button>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* 1. Category, Reading Time, and Cover Illustration Selector */}
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div>
                      <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                        {lang === 'am' ? 'የትምህርት ዘርፍ' : 'Health Category'}
                      </label>
                      <select
                        value={formData.category}
                        onChange={(e) => {
                          const newCat = e.target.value;
                          const matchingImg = OFFICIAL_ILLUSTRATIONS.find((i) => i.id === newCat)?.path;
                          setFormData({
                            ...formData,
                            category: newCat,
                            imageUrl: matchingImg || formData.imageUrl,
                          });
                        }}
                        className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white font-medium focus:border-brand-500 focus:outline-hidden"
                      >
                        <option value="puberty">Puberty & Growth (ጉርምስና)</option>
                        <option value="srh">Sexual & Reproductive Health (ሥነ-ተዋልዶ)</option>
                        <option value="sti">STI Prevention (የአባላዘር በሽታዎች)</option>
                        <option value="hiv">HIV & AIDS Prevention (ኤች.አይ.ቪ)</option>
                        <option value="hepatitis">Viral Hepatitis (የጉበት ቫይረስ)</option>
                        <option value="mental_health">Mental Health & Stress (አእምሮ ጤና)</option>
                        <option value="gbv">GBV & Consent (ጾታዊ ጥቃት)</option>
                        <option value="substance">Substance Abuse (የሱስ መከላከል)</option>
                      </select>
                    </div>

                    <div>
                      <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                        {lang === 'am' ? 'የንባብ ጊዜ (ደቂቃ)' : 'Estimated Reading Time'}
                      </label>
                      <input
                        type="number"
                        min={1}
                        max={30}
                        value={formData.readTimeMin}
                        onChange={(e) =>
                          setFormData({
                            ...formData,
                            readTimeMin: parseInt(e.target.value, 10) || 4,
                          })
                        }
                        className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:border-brand-500 focus:outline-hidden"
                      />
                    </div>

                    {/* Cover Illustration Picker */}
                    <div>
                      <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                        {lang === 'am' ? 'የሞጁሉ ስዕል (Cover Illustration)' : 'Cover Illustration'}
                      </label>
                      <div className="flex items-center gap-2">
                        <div className="w-10 h-10 rounded-xl bg-slate-100 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 overflow-hidden shrink-0 flex items-center justify-center p-1">
                          <img
                            src={currentThumbnailUrl}
                            alt=""
                            className="w-full h-full object-contain"
                            onError={(e) => {
                              (e.target as HTMLImageElement).src =
                                '/illustrations/module_01_puberty.jpg';
                            }}
                          />
                        </div>
                        <button
                          type="button"
                          onClick={() => setShowImagePicker(!showImagePicker)}
                          className="flex-1 px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-slate-50 dark:bg-slate-800 hover:bg-slate-100 text-slate-800 dark:text-slate-200 text-xs font-bold flex items-center justify-between cursor-pointer"
                        >
                          <span className="truncate">
                            {formData.imageUrl.split('/').pop() || 'Choose Image'}
                          </span>
                          <ImageIcon size={14} className="text-slate-400 shrink-0" />
                        </button>
                      </div>
                    </div>
                  </div>

                  {/* Visual Illustration Chooser Gallery */}
                  {showImagePicker && (
                    <div className="bg-slate-50 dark:bg-slate-800/80 border border-slate-200 dark:border-slate-700 rounded-2xl p-4 space-y-3">
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-bold text-slate-700 dark:text-slate-300 flex items-center gap-1.5">
                          <ImageIcon size={14} className="text-brand-600" />
                          <span>
                            {lang === 'am'
                              ? 'ከታወቁት የጤና ስዕላዊ መግለጫዎች ይምረጡ፡'
                              : 'Select from official health curriculum illustrations:'}
                          </span>
                        </span>
                        <button
                          type="button"
                          onClick={() => setShowImagePicker(false)}
                          className="text-slate-400 hover:text-slate-600"
                        >
                          <X size={15} />
                        </button>
                      </div>

                      <div className="grid grid-cols-2 sm:grid-cols-4 gap-2.5">
                        {OFFICIAL_ILLUSTRATIONS.map((ill) => {
                          const isSelected = formData.imageUrl === ill.path;
                          return (
                            <button
                              key={ill.id}
                              type="button"
                              onClick={() => {
                                setFormData({ ...formData, imageUrl: ill.path });
                                setShowImagePicker(false);
                              }}
                              className={`p-2 rounded-xl border text-center transition-all cursor-pointer flex flex-col items-center gap-1.5 ${
                                isSelected
                                  ? 'border-brand-500 bg-brand-50/70 dark:bg-brand-950/60 ring-2 ring-brand-500/20'
                                  : 'border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 hover:border-slate-300'
                              }`}
                            >
                              <img
                                src={ill.previewUrl}
                                alt={ill.name}
                                className="h-16 w-full object-contain"
                              />
                              <span className="text-[10px] font-bold text-slate-700 dark:text-slate-300 truncate w-full">
                                {ill.name}
                              </span>
                            </button>
                          );
                        })}
                      </div>

                      {/* Custom Image URL option */}
                      <div className="pt-2 border-t border-slate-200 dark:border-slate-700 flex items-center gap-2">
                        <input
                          type="text"
                          value={formData.imageUrl}
                          onChange={(e) =>
                            setFormData({ ...formData, imageUrl: e.target.value })
                          }
                          placeholder="Or paste custom image asset path or HTTPS image URL..."
                          className="flex-1 px-3 py-1.5 text-xs rounded-lg border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-800 dark:text-white"
                        />
                        <button
                          type="button"
                          onClick={() => setShowImagePicker(false)}
                          className="px-3 py-1.5 bg-brand-600 text-white rounded-lg text-xs font-bold"
                        >
                          {lang === 'am' ? 'አረጋግጥ' : 'Done'}
                        </button>
                      </div>
                    </div>
                  )}

                  {/* Language Selector Bar for Bilingual Inputs */}
                  <div className="flex items-center gap-2 border-b border-slate-100 dark:border-slate-800 pb-2">
                    <button
                      type="button"
                      onClick={() => setActiveTab('en')}
                      className={`px-3.5 py-1.5 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
                        activeTab === 'en'
                          ? 'bg-brand-600 text-white shadow-xs'
                          : 'text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800'
                      }`}
                    >
                      English Content (የእንግሊዝኛ ይዘት)
                    </button>
                    <button
                      type="button"
                      onClick={() => setActiveTab('am')}
                      className={`px-3.5 py-1.5 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
                        activeTab === 'am'
                          ? 'bg-brand-600 text-white shadow-xs'
                          : 'text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800'
                      }`}
                    >
                      የአማርኛ ይዘት (Amharic Content)
                    </button>
                  </div>

                  {/* Bilingual Fields */}
                  {activeTab === 'en' ? (
                    <>
                      <div>
                        <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                          Module Title (English)
                        </label>
                        <input
                          type="text"
                          required
                          value={formData.titleEn}
                          onChange={(e) =>
                            setFormData({ ...formData, titleEn: e.target.value })
                          }
                          className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:border-brand-500 focus:outline-hidden"
                          placeholder="e.g. Adolescent health & puberty"
                        />
                      </div>

                      <div>
                        <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                          Summary / Overview (English)
                        </label>
                        <textarea
                          rows={2}
                          required
                          value={formData.summaryEn}
                          onChange={(e) =>
                            setFormData({ ...formData, summaryEn: e.target.value })
                          }
                          className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:border-brand-500 focus:outline-hidden"
                          placeholder="Short summary displayed under the title in the Hero Card..."
                        />
                      </div>

                      {/* Doctor's Takeaway Note Container (Matching Image 2 Note) */}
                      <div className="bg-[#EFF7FD] border border-[#CFE5F7] rounded-2xl p-4 space-y-2">
                        <div className="flex items-center gap-2">
                          <div className="w-7 h-7 rounded-full bg-[#D8EDFB] flex items-center justify-center shrink-0">
                            <Lightbulb size={16} className="text-[#0284C7]" />
                          </div>
                          <div>
                            <span className="font-extrabold text-[#08264A] text-xs sm:text-sm">
                              Doctor's Key Takeaway Note ("| Note")
                            </span>
                            <span className="text-[11px] text-[#0284C7] ml-2 font-medium">
                              Displayed in the lightbulb callout card on mobile
                            </span>
                          </div>
                        </div>

                        <textarea
                          rows={2}
                          value={formData.doctorNoteEn}
                          onChange={(e) =>
                            setFormData({ ...formData, doctorNoteEn: e.target.value })
                          }
                          placeholder="e.g. Every adolescent experiences puberty at their own unique pace—practicing good hygiene, understanding bodily changes, and embracing self-confidence helps ensure a healthy transition."
                          className="w-full px-3 py-2 border border-[#BAE6FD] rounded-xl bg-white text-slate-900 text-xs focus:border-[#0284C7] focus:outline-hidden"
                        />
                      </div>

                      {/* Expandable Sections Markdown Editor */}
                      <div>
                        <div className="flex items-center justify-between mb-1.5">
                          <label className="font-bold text-slate-700 dark:text-slate-300 flex items-center gap-1.5">
                            <span>Learning Sections (English Markdown)</span>
                            <span className="text-[10px] text-slate-400 font-normal">
                              Each '## Heading' creates an expandable section card
                            </span>
                          </label>

                          <div className="flex items-center gap-1">
                            <button
                              type="button"
                              onClick={() => insertMarkdown('**', '**')}
                              className="p-1 text-slate-500 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                              title="Bold"
                            >
                              <Bold size={13} />
                            </button>
                            <button
                              type="button"
                              onClick={() => insertMarkdown('## ')}
                              className="p-1 text-slate-500 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                              title="H2 New Section"
                            >
                              <Heading2 size={13} />
                            </button>
                            <button
                              type="button"
                              onClick={() => insertMarkdown('- ')}
                              className="p-1 text-slate-500 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                              title="Bullet List"
                            >
                              <List size={13} />
                            </button>
                            <button
                              type="button"
                              onClick={() => insertMarkdown('> ')}
                              className="p-1 text-slate-500 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                              title="Clinical Tip"
                            >
                              <Quote size={13} />
                            </button>
                          </div>
                        </div>

                        <textarea
                          rows={8}
                          required
                          value={formData.contentEn}
                          onChange={(e) =>
                            setFormData({ ...formData, contentEn: e.target.value })
                          }
                          className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white font-mono text-xs focus:border-brand-500 focus:outline-hidden"
                        />
                      </div>
                    </>
                  ) : (
                    <>
                      <div>
                        <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                          ርዕስ (በአማርኛ)
                        </label>
                        <input
                          type="text"
                          required
                          value={formData.titleAm}
                          onChange={(e) =>
                            setFormData({ ...formData, titleAm: e.target.value })
                          }
                          className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:border-brand-500 focus:outline-hidden"
                          placeholder="ምሳሌ፡ የጉርምስና ወቅትና አካላዊ ለውጦች"
                        />
                      </div>

                      <div>
                        <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                          ማጠቃለያ (በአማርኛ)
                        </label>
                        <textarea
                          rows={2}
                          required
                          value={formData.summaryAm}
                          onChange={(e) =>
                            setFormData({ ...formData, summaryAm: e.target.value })
                          }
                          className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:border-brand-500 focus:outline-hidden"
                          placeholder="በሞባይል ስልኩ ዋና ገጽ ላይ የሚታይ አጭር ማጠቃለያ..."
                        />
                      </div>

                      {/* Doctor's Takeaway Note (Amharic) */}
                      <div className="bg-[#EFF7FD] border border-[#CFE5F7] rounded-2xl p-4 space-y-2">
                        <div className="flex items-center gap-2">
                          <div className="w-7 h-7 rounded-full bg-[#D8EDFB] flex items-center justify-center shrink-0">
                            <Lightbulb size={16} className="text-[#0284C7]" />
                          </div>
                          <div>
                            <span className="font-extrabold text-[#08264A] text-xs sm:text-sm">
                              የዶክተር ማስታወሻ ("| Note")
                            </span>
                            <span className="text-[11px] text-[#0284C7] ml-2 font-medium">
                              በሞባይሉ ላይ ከስዕሉ በታች ባለው ሰማያዊ ሳጥን ውስጥ የሚቀመጥ
                            </span>
                          </div>
                        </div>

                        <textarea
                          rows={2}
                          value={formData.doctorNoteAm}
                          onChange={(e) =>
                            setFormData({ ...formData, doctorNoteAm: e.target.value })
                          }
                          placeholder="ምሳሌ፡ እያንዳንዱ ታዳጊ በራሱ ተፈጥሯዊ ፍጥነት ያድጋል፤ ንፅህናን መጠበቅ፣ የአካል ለውጦችን መረዳትና በራስ መተማመንን ማዳበር ጤናማ ሽግግርን ያረጋግጣል።"
                          className="w-full px-3 py-2 border border-[#BAE6FD] rounded-xl bg-white text-slate-900 text-xs focus:border-[#0284C7] focus:outline-hidden"
                        />
                      </div>

                      {/* Expandable Sections Markdown Editor (Amharic) */}
                      <div>
                        <div className="flex items-center justify-between mb-1.5">
                          <label className="font-bold text-slate-700 dark:text-slate-300 flex items-center gap-1.5">
                            <span>የትምህርት ይዘት (በአማርኛ ማርክዳውን)</span>
                            <span className="text-[10px] text-slate-400 font-normal">
                              እያንዳንዱ '## ' የሚጀምር ንዑስ ርዕስ ወደ ተጠቃይ ሳጥንነት ይቀየራል
                            </span>
                          </label>

                          <div className="flex items-center gap-1">
                            <button
                              type="button"
                              onClick={() => insertMarkdown('**', '**')}
                              className="p-1 text-slate-500 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                              title="ደማቅ"
                            >
                              <Bold size={13} />
                            </button>
                            <button
                              type="button"
                              onClick={() => insertMarkdown('## ')}
                              className="p-1 text-slate-500 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                              title="ንዑስ ርዕስ (H2)"
                            >
                              <Heading2 size={13} />
                            </button>
                            <button
                              type="button"
                              onClick={() => insertMarkdown('- ')}
                              className="p-1 text-slate-500 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                              title="ነጥቦች"
                            >
                              <List size={13} />
                            </button>
                            <button
                              type="button"
                              onClick={() => insertMarkdown('> ')}
                              className="p-1 text-slate-500 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                              title="የዶክተር ማስታወሻ"
                            >
                              <Quote size={13} />
                            </button>
                          </div>
                        </div>

                        <textarea
                          rows={8}
                          required
                          value={formData.contentAm}
                          onChange={(e) =>
                            setFormData({ ...formData, contentAm: e.target.value })
                          }
                          className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white font-mono text-xs focus:border-brand-500 focus:outline-hidden"
                        />
                      </div>
                    </>
                  )}

                  {/* Author Attribution */}
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                      {lang === 'am'
                        ? 'የህክምና ባለሙያ / ደራሲ ስም'
                        : 'Medical Author / Specialist Attribution'}
                    </label>
                    <input
                      type="text"
                      value={formData.authorName}
                      onChange={(e) =>
                        setFormData({ ...formData, authorName: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:border-brand-500 focus:outline-hidden"
                      placeholder="e.g. Dr. Hanna Bekele, Adolescent Health Specialist"
                    />
                  </div>

                  {/* Submit / Cancel Buttons */}
                  <div className="pt-4 flex items-center justify-between border-t border-slate-100 dark:border-slate-800">
                    <button
                      type="button"
                      onClick={() => setModalTab('preview')}
                      className="text-xs font-bold text-brand-600 dark:text-cyan-400 hover:underline flex items-center gap-1 cursor-pointer"
                    >
                      <Smartphone size={14} />
                      <span>{lang === 'am' ? 'ሞባይሉ ላይ እንዴት እንደሚታይ እይ' : 'Preview on Mobile First'}</span>
                    </button>

                    <div className="flex items-center gap-3">
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
                        className="px-5 py-2 bg-brand-600 hover:bg-brand-700 disabled:opacity-50 disabled:cursor-not-allowed text-white font-bold rounded-xl shadow-md shadow-brand-600/20 cursor-pointer flex items-center gap-2"
                      >
                        {isSubmitting && (
                          <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                        )}
                        <span>
                          {isSubmitting
                            ? (lang === 'am' ? 'በመመዝገብ ላይ...' : 'Saving...')
                            : editingModule
                            ? (lang === 'am' ? 'ለውጦችን መዝግብ' : 'Save Changes')
                            : (lang === 'am' ? 'ሞጁል ፍጠር' : 'Publish Module')}
                        </span>
                      </button>
                    </div>
                  </div>
                </form>
              )}
            </div>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      <ConfirmModal
        isOpen={Boolean(moduleToDelete)}
        onClose={() => setModuleToDelete(null)}
        onConfirm={async () => {
          if (moduleToDelete) {
            await onDelete(moduleToDelete.id);
          }
        }}
        title={
          lang === 'am'
            ? 'የትምህርት ሞጁሉ ይሰረዝ?'
            : 'Delete Health Curriculum Module?'
        }
        itemName={
          moduleToDelete
            ? lang === 'am'
              ? moduleToDelete.titleAm || moduleToDelete.titleEn
              : moduleToDelete.titleEn
            : ''
        }
        message={
          lang === 'am'
            ? 'ይህ እርምጃ ሞጁሉንና በውስጡ ያሉትን ትምህርቶች ከመዝገቡ በቋሚነት ያጠፋል። ተማሪዎች ይህንን ይዘት በሞባይል መተግበሪያቸው ማግኘት አይችሉም።'
            : 'This module and all its authored lessons will be permanently deleted. Students will no longer see this topic in their reading feed.'
        }
        lang={lang}
      />
    </div>
  );
};
