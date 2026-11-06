import React, { useState, useMemo, useEffect } from 'react';
import {
  BookOpen,
  Plus,
  Edit2,
  Trash2,
  Clock,
  X,
  Eye,
  Edit3,
  Download,
  Bold,
  Heading2,
  List,
  Quote,
  Search,
  Filter,
} from 'lucide-react';
import { Module } from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';
import { ConfirmModal } from '../components/common/ConfirmModal.js';
import { EmptyState } from '../components/common/EmptyState.js';

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
  const [previewMode, setPreviewMode] = useState<'edit' | 'preview'>('edit');

  const categories = ['All', 'puberty', 'srh', 'hiv', 'mental_health', 'gbv', 'substance'];

  const categoryLabels: Record<string, { en: string; am: string }> = {
    All: { en: 'All Topics', am: 'ሁሉም ዘርፎች' },
    puberty: { en: 'Puberty & Growth', am: 'ጉርምስና' },
    srh: { en: 'Reproductive Health', am: 'ሥነ-ተዋልዶ' },
    hiv: { en: 'HIV & AIDS Prevention', am: 'ኤች.አይ.ቪ' },
    mental_health: { en: 'Mental Health & Stress', am: 'አእምሮ ጤና' },
    gbv: { en: 'GBV & Consent', am: 'ጾታዊ ጥቃት' },
    substance: { en: 'Substance Abuse', am: 'የሱስ መከላከል' },
  };

  const [formData, setFormData] = useState({
    category: 'srh',
    titleEn: '',
    titleAm: '',
    summaryEn: '',
    summaryAm: '',
    contentEn: '',
    contentAm: '',
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
      // Category filter
      if (selectedCategory !== 'All' && m.category !== selectedCategory) {
        return false;
      }

      // Keyword search
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

        return matchTitle || matchSummary || matchContent || Boolean(matchAuthor) || matchCategory;
      }

      return true;
    });
  }, [modules, selectedCategory, search]);

  const openCreateModal = () => {
    setEditingModule(null);
    setPreviewMode('edit');
    setFormData({
      category: 'puberty',
      titleEn: '',
      titleAm: '',
      summaryEn: '',
      summaryAm: '',
      contentEn:
        '## Overview\n\nWrite youth clinical education here...\n\n- Key Point 1: Healthy body changes\n- Key Point 2: Hygiene & care\n\n> Medical Note: Every adolescent develops at their own unique pace.',
      contentAm:
        '## አጠቃላይ መግለጫ\n\nትክክለኛ የጤና ትምህርት እዚህ ይጻፉ...\n\n- ዋና ነጥብ 1፡ ጤናማ የአካል ለውጦች\n- ዋና ነጥብ 2፡ ንፅህናና ጥንቃቄ\n\n> የዶክተር ማስታወሻ፡ እያንዳንዱ ታዳጊ በራሱ ፍጥነት ያድጋል።',
      readTimeMin: 4,
      authorName: 'Adolescent Health Specialist',
      isPublished: true,
      orderIndex: modules.length + 1,
    });
    setIsModalOpen(true);
  };

  const openEditModal = (m: Module) => {
    setEditingModule(m);
    setPreviewMode('edit');
    setFormData({
      category: m.category,
      titleEn: m.titleEn,
      titleAm: m.titleAm,
      summaryEn: m.summaryEn,
      summaryAm: m.summaryAm,
      contentEn: m.contentEn,
      contentAm: m.contentAm,
      readTimeMin: m.readTimeMin,
      authorName: m.authorName || '',
      isPublished: m.isPublished,
      orderIndex: m.orderIndex,
    });
    setIsModalOpen(true);
  };

  const handleExportCsv = () => {
    exportToCsv(
      'Yegna_Health_Curriculum_Modules',
      [
        { header: 'Title (English)', accessor: (m) => m.titleEn },
        { header: 'Title (Amharic)', accessor: (m) => m.titleAm },
        { header: 'Category', accessor: (m) => m.category },
        { header: 'Read Time (Minutes)', accessor: (m) => m.readTimeMin },
        { header: 'Author Attribution', accessor: (m) => m.authorName || 'Medical Review Team' },
        { header: 'Summary (English)', accessor: (m) => m.summaryEn },
        { header: 'Summary (Amharic)', accessor: (m) => m.summaryAm },
        { header: 'Publication Status', accessor: (m) => (m.isPublished ? 'PUBLISHED' : 'DRAFT') },
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
    await onSave(formData, editingModule ? editingModule.id : undefined);
    setIsModalOpen(false);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            <BookOpen className="text-brand-600 dark:text-cyan-400" size={24} />
            <span>{lang === 'am' ? 'የትምህርት ሞጁሎችና የዶክተር ማስታወሻዎች' : 'Health Curriculum CMS'}</span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1">
            {lang === 'am'
              ? 'የጉርምስና፣ የሥነ-ተዋልዶ፣ የኤች.አይ.ቪና የአእምሮ ጤና ትምህርቶችን በእንግሊዝኛና በአማርኛ ያዘጋጁ።'
              : 'Draft, publish, and update bilingual medical education verified for Ethiopian youth.'}
          </p>
        </div>

        <div className="flex items-center gap-2 self-start sm:self-auto">
          <button
            onClick={handleExportCsv}
            className="flex items-center gap-1.5 px-3.5 py-2.5 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs md:text-sm font-bold rounded-xl border border-slate-200 dark:border-slate-700 transition-all cursor-pointer shadow-2xs"
            title={lang === 'am' ? 'የትምህርት ሞጁሎች ሪፖርት አውርድ' : 'Export curriculum to Excel CSV'}
          >
            <Download size={15} />
            <span>{lang === 'am' ? 'ሪፖርት (CSV)' : 'Export CSV'}</span>
          </button>
          <button
            onClick={openCreateModal}
            className="flex items-center gap-2 px-4 py-2.5 bg-brand-600 hover:bg-brand-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md shadow-brand-600/20 transition-all cursor-pointer"
          >
            <Plus size={16} />
            <span>{lang === 'am' ? '+ አዲስ ትምህርት ጨምር' : '+ New Health Module'}</span>
          </button>
        </div>
      </div>

      {/* Search & Topic Filter Bar */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-3.5 sm:p-4 shadow-xs space-y-3">
        {/* Search Input & Live Metrics */}
        <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3">
          <div className="relative flex-1">
            <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 dark:text-slate-500" size={16} />
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
                className="text-xs font-bold text-brand-600 dark:text-cyan-400 hover:underline cursor-pointer"
              >
                {lang === 'am' ? 'ማጣሪያውን አጽዳ' : 'Reset Filters'}
              </button>
            )}
          </div>
        </div>

        {/* Category Pills */}
        <div className="flex items-center gap-2 overflow-x-auto pb-1 text-xs font-bold pt-1 border-t border-slate-100 dark:border-slate-800">
          <div className="text-slate-400 dark:text-slate-500 flex items-center gap-1 pr-1 pointer-events-none text-[11px]">
            <Filter size={12} />
            <span>{lang === 'am' ? 'ዘርፍ፡' : 'Category:'}</span>
          </div>
          {categories.map((c) => {
            const count =
              c === 'All'
                ? modules.length
                : modules.filter((m) => m.category === c).length;
            const label =
              lang === 'am'
                ? categoryLabels[c]?.am || c
                : categoryLabels[c]?.en || c;

            return (
              <button
                key={c}
                type="button"
                onClick={() => setSelectedCategory(c)}
                className={`px-3 py-1.5 rounded-xl transition-all uppercase tracking-wider cursor-pointer whitespace-nowrap text-[11px] flex items-center gap-1.5 ${
                  selectedCategory === c
                    ? 'bg-brand-600 dark:bg-brand-600 text-white shadow-xs'
                    : 'bg-slate-50 dark:bg-slate-800/70 border border-slate-200 dark:border-slate-700/80 text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800'
                }`}
              >
                <span>{label}</span>
                <span
                  className={`text-[10px] px-1.5 py-0.2 rounded-full font-bold ${
                    selectedCategory === c
                      ? 'bg-white/25 text-white'
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

      {/* Modules Grid or Illustrated Empty State */}
      {filtered.length === 0 ? (
        <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs">
          <EmptyState
            icon={BookOpen}
            title={
              modules.length === 0
                ? (lang === 'am' ? 'ምንም የትምህርት ሞጁሎች አልተመዘገቡም' : 'No Health Modules Found')
                : (lang === 'am' ? 'ከፍለጋው ጋር የሚዛመድ ሞጁል አልተገኘም' : 'No Matching Modules Found')
            }
            description={
              modules.length === 0
                ? (lang === 'am'
                    ? 'የጉርምስና፣ የሥነ-ተዋልዶ፣ የኤች.አይ.ቪና የአእምሮ ጤና ትምህርቶችን በእንግሊዝኛና በአማርኛ በማዘጋጀት ይጀምሩ።'
                    : 'Draft, publish, and update bilingual medical education verified for Ethiopian youth.')
                : (lang === 'am'
                    ? 'የፍለጋ ቃላትን ይቀይሩ ወይም ሁሉንም የትምህርት ዘርፎች ይምረጡ።'
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
          {filtered.map((m) => (
            <div
              key={m.id}
              className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-5 shadow-xs hover:border-slate-300 dark:hover:border-slate-700 transition-all flex flex-col justify-between"
            >
              <div>
                <div className="flex items-start justify-between gap-3 mb-2.5">
                  <span className="text-[10px] font-extrabold uppercase px-2.5 py-0.5 rounded-md bg-brand-50 dark:bg-brand-950/60 text-brand-700 dark:text-cyan-400 border border-brand-100 dark:border-brand-900/40">
                    {categoryLabels[m.category] ? (lang === 'am' ? categoryLabels[m.category].am : categoryLabels[m.category].en) : m.category}
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

                <h3 className="font-extrabold text-slate-900 dark:text-white text-base mb-1">
                  {lang === 'am' ? m.titleAm : m.titleEn}
                </h3>
                <p className="text-xs text-slate-400 dark:text-slate-500 mb-2">
                  {lang === 'am' ? m.titleEn : m.titleAm}
                </p>
                <p className="text-xs text-slate-600 dark:text-slate-300 line-clamp-2 leading-relaxed">
                  {lang === 'am' ? m.summaryAm : m.summaryEn}
                </p>
              </div>

              <div className="pt-4 mt-4 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between text-xs text-slate-400 dark:text-slate-500">
                <span className="flex items-center gap-1 font-semibold text-slate-600 dark:text-slate-300">
                  <Clock size={13} className="text-slate-400 dark:text-slate-500" />
                  {m.readTimeMin} min read
                </span>
                <span className="text-[11px] truncate max-w-[180px]">{m.authorName || 'Medical Review Team'}</span>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Editor Modal with Markdown Live Preview */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-950/60 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-3xl w-full max-h-[92vh] overflow-y-auto p-6 md:p-8 animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between pb-3 border-b border-slate-100 dark:border-slate-800">
              <div>
                <h3 className="text-lg font-extrabold text-slate-900 dark:text-white">
                  {editingModule
                    ? (lang === 'am' ? 'የትምህርት ሞጁልን አርትዕ' : 'Edit Health Module')
                    : (lang === 'am' ? 'አዲስ የትምህርት ሞጁል ፍጠር' : 'Create Health Curriculum Module')}
                </h3>
                <p className="text-xs text-slate-400 dark:text-slate-500">
                  {lang === 'am' ? 'የዶክተር ማብራሪያዎችንና ማርክዳውን ያርትዑ' : 'Author bilingual youth medical education'}
                </p>
              </div>
              <button
                onClick={() => setIsModalOpen(false)}
                className="p-1 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800 cursor-pointer"
              >
                <X size={20} />
              </button>
            </div>

            {/* Language Tabs Selector */}
            <div className="flex items-center justify-between gap-2 mt-4 border-b border-slate-100 dark:border-slate-800 pb-2">
              <div className="flex items-center gap-1.5">
                <button
                  type="button"
                  onClick={() => setActiveTab('en')}
                  className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
                    activeTab === 'en'
                      ? 'bg-brand-600 text-white shadow-xs'
                      : 'text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800'
                  }`}
                >
                  English Content
                </button>
                <button
                  type="button"
                  onClick={() => setActiveTab('am')}
                  className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
                    activeTab === 'am'
                      ? 'bg-brand-600 text-white shadow-xs'
                      : 'text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800'
                  }`}
                >
                  የአማርኛ ይዘት (Amharic)
                </button>
              </div>

              {/* Edit vs Live Preview Toggle */}
              <div className="flex items-center bg-slate-100 dark:bg-slate-800 p-0.5 rounded-xl text-xs font-bold border border-slate-200 dark:border-slate-700">
                <button
                  type="button"
                  onClick={() => setPreviewMode('edit')}
                  className={`flex items-center gap-1 px-2.5 py-1 rounded-lg transition-all cursor-pointer ${
                    previewMode === 'edit'
                      ? 'bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-xs'
                      : 'text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
                  }`}
                >
                  <Edit3 size={12} />
                  <span>Editor</span>
                </button>
                <button
                  type="button"
                  onClick={() => setPreviewMode('preview')}
                  className={`flex items-center gap-1 px-2.5 py-1 rounded-lg transition-all cursor-pointer ${
                    previewMode === 'preview'
                      ? 'bg-white dark:bg-slate-700 text-brand-700 dark:text-cyan-300 shadow-xs'
                      : 'text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
                  }`}
                >
                  <Eye size={12} />
                  <span>Live Preview</span>
                </button>
              </div>
            </div>

            <form onSubmit={handleSubmit} className="mt-4 space-y-3.5 text-xs md:text-sm">
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    {lang === 'am' ? 'የትምህርት ዘርፍ' : 'Health Category'}
                  </label>
                  <select
                    value={formData.category}
                    onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white font-medium focus:border-brand-500 focus:outline-hidden"
                  >
                    <option value="puberty">Puberty & Growth (ጉርምስና)</option>
                    <option value="srh">Sexual & Reproductive Health (ሥነ-ተዋልዶ)</option>
                    <option value="hiv">HIV & AIDS Prevention (ኤች.አይ.ቪ)</option>
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
                    value={formData.readTimeMin}
                    onChange={(e) => setFormData({ ...formData, readTimeMin: parseInt(e.target.value, 10) || 4 })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:border-brand-500 focus:outline-hidden"
                  />
                </div>
              </div>

              {activeTab === 'en' ? (
                <>
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">Title (English)</label>
                    <input
                      type="text"
                      required
                      value={formData.titleEn}
                      onChange={(e) => setFormData({ ...formData, titleEn: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                      placeholder="e.g. Understanding Physical Puberty Changes"
                    />
                  </div>
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">Summary (English)</label>
                    <textarea
                      rows={2}
                      required
                      value={formData.summaryEn}
                      onChange={(e) => setFormData({ ...formData, summaryEn: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                    />
                  </div>

                  <div>
                    <div className="flex items-center justify-between mb-1.5">
                      <label className="font-bold text-slate-700 dark:text-slate-300 flex items-center gap-1.5">
                        <span>Article Content (English Markdown)</span>
                        <span className="text-[10px] text-slate-400 dark:text-slate-500 font-normal">Markdown Supported</span>
                      </label>

                      {/* Quick Markdown Toolbar Buttons */}
                      {previewMode === 'edit' && (
                        <div className="flex items-center gap-1">
                          <button
                            type="button"
                            onClick={() => insertMarkdown('**', '**')}
                            className="p-1 text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                            title="Bold"
                          >
                            <Bold size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('## ')}
                            className="p-1 text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                            title="H2 Heading"
                          >
                            <Heading2 size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('- ')}
                            className="p-1 text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                            title="Bullet List"
                          >
                            <List size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('> ')}
                            className="p-1 text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                            title="Quote"
                          >
                            <Quote size={13} />
                          </button>
                        </div>
                      )}
                    </div>

                    {previewMode === 'edit' ? (
                      <textarea
                        rows={7}
                        required
                        value={formData.contentEn}
                        onChange={(e) => setFormData({ ...formData, contentEn: e.target.value })}
                        className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white font-mono text-xs focus:border-brand-500 focus:outline-hidden"
                      />
                    ) : (
                      <div className="w-full min-h-[170px] max-h-64 overflow-y-auto p-4 border border-brand-200 dark:border-brand-900/60 bg-slate-50/70 dark:bg-slate-800/40 rounded-xl">
                        {renderMarkdown(formData.contentEn)}
                      </div>
                    )}
                  </div>
                </>
              ) : (
                <>
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">ርዕስ (በአማርኛ)</label>
                    <input
                      type="text"
                      required
                      value={formData.titleAm}
                      onChange={(e) => setFormData({ ...formData, titleAm: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                      placeholder="ምሳሌ፡ የጉርምስና ወቅትና አካላዊ ለውጦች"
                    />
                  </div>
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">ማጠቃለያ (በአማርኛ)</label>
                    <textarea
                      rows={2}
                      required
                      value={formData.summaryAm}
                      onChange={(e) => setFormData({ ...formData, summaryAm: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                    />
                  </div>

                  <div>
                    <div className="flex items-center justify-between mb-1.5">
                      <label className="font-bold text-slate-700 dark:text-slate-300 flex items-center gap-1.5">
                        <span>የትምህርት ይዘት (በአማርኛ ማርክዳውን)</span>
                        <span className="text-[10px] text-slate-400 dark:text-slate-500 font-normal">ማርክዳውን ይደግፋል</span>
                      </label>

                      {previewMode === 'edit' && (
                        <div className="flex items-center gap-1">
                          <button
                            type="button"
                            onClick={() => insertMarkdown('**', '**')}
                            className="p-1 text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                            title="ደማቅ (Bold)"
                          >
                            <Bold size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('## ')}
                            className="p-1 text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                            title="ንዑስ ርዕስ (H2)"
                          >
                            <Heading2 size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('- ')}
                            className="p-1 text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                            title="ነጥቦች (List)"
                          >
                            <List size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('> ')}
                            className="p-1 text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded"
                            title="የዶክተር ማስታወሻ (Quote)"
                          >
                            <Quote size={13} />
                          </button>
                        </div>
                      )}
                    </div>

                    {previewMode === 'edit' ? (
                      <textarea
                        rows={7}
                        required
                        value={formData.contentAm}
                        onChange={(e) => setFormData({ ...formData, contentAm: e.target.value })}
                        className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white font-mono text-xs focus:border-brand-500 focus:outline-hidden"
                      />
                    ) : (
                      <div className="w-full min-h-[170px] max-h-64 overflow-y-auto p-4 border border-brand-200 dark:border-brand-900/60 bg-slate-50/70 dark:bg-slate-800/40 rounded-xl">
                        {renderMarkdown(formData.contentAm)}
                      </div>
                    )}
                  </div>
                </>
              )}

              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                  {lang === 'am' ? 'የህክምና ባለሙያ / ደራሲ ስም' : 'Medical Author / Specialist Attribution'}
                </label>
                <input
                  type="text"
                  value={formData.authorName}
                  onChange={(e) => setFormData({ ...formData, authorName: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                  placeholder="e.g. Dr. Hanna Bekele, Adolescent Health Specialist"
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
                  {editingModule
                    ? (lang === 'am' ? 'ለውጦችን መዝግብ' : 'Save Changes')
                    : (lang === 'am' ? 'ሞጁል ፍጠር' : 'Publish Module')}
                </button>
              </div>
            </form>
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
        title={lang === 'am' ? 'የትምህርት ሞጁሉ ይሰረዝ?' : 'Delete Health Curriculum Module?'}
        itemName={moduleToDelete ? (lang === 'am' ? moduleToDelete.titleAm || moduleToDelete.titleEn : moduleToDelete.titleEn) : ''}
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

function renderMarkdown(content: string) {
  if (!content) return <p className="text-slate-400 dark:text-slate-500 italic text-xs">No content entered.</p>;

  const lines = content.split('\n');
  const elements: React.ReactNode[] = [];
  let inList = false;
  let listItems: string[] = [];

  const flushList = (keyPrefix: string) => {
    if (inList && listItems.length > 0) {
      elements.push(
        <ul key={`${keyPrefix}_ul`} className="list-disc pl-5 space-y-1 mb-2.5 text-xs text-slate-700 dark:text-slate-300">
          {listItems.map((item, idx) => (
            <li key={idx}>{parseInlineMarkdown(item)}</li>
          ))}
        </ul>
      );
      listItems = [];
      inList = false;
    }
  };

  lines.forEach((line, idx) => {
    const trimmed = line.trim();
    if (!trimmed) {
      flushList(`flush_${idx}`);
      return;
    }

    if (trimmed.startsWith('# ')) {
      flushList(`h1_${idx}`);
      elements.push(
        <h3 key={idx} className="text-base font-extrabold text-slate-900 dark:text-white border-b border-slate-200 dark:border-slate-700 pb-1 mt-3 mb-2">
          {parseInlineMarkdown(trimmed.slice(2))}
        </h3>
      );
    } else if (trimmed.startsWith('## ')) {
      flushList(`h2_${idx}`);
      elements.push(
        <h4 key={idx} className="text-sm font-bold text-brand-800 dark:text-cyan-400 mt-2.5 mb-1.5 flex items-center gap-1.5">
          <span className="w-1.5 h-1.5 rounded-full bg-brand-600 dark:bg-cyan-400 inline-block" />
          {parseInlineMarkdown(trimmed.slice(3))}
        </h4>
      );
    } else if (trimmed.startsWith('### ')) {
      flushList(`h3_${idx}`);
      elements.push(
        <h5 key={idx} className="text-xs font-bold text-slate-800 dark:text-slate-200 mt-2 mb-1">
          {parseInlineMarkdown(trimmed.slice(4))}
        </h5>
      );
    } else if (trimmed.startsWith('> ')) {
      flushList(`quote_${idx}`);
      elements.push(
        <blockquote key={idx} className="border-l-3 border-brand-500 bg-brand-50/70 dark:bg-brand-950/40 pl-3 pr-2 py-1.5 rounded-r-lg italic text-xs text-brand-900 dark:text-brand-300 my-2">
          {parseInlineMarkdown(trimmed.slice(2))}
        </blockquote>
      );
    } else if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
      inList = true;
      listItems.push(trimmed.slice(2));
    } else if (trimmed.startsWith('![')) {
      flushList(`img_${idx}`);
      const match = trimmed.match(/!\[(.*?)\]\((.*?)\)/);
      if (match) {
        elements.push(
          <div key={idx} className="my-2.5">
            <img src={match[2]} alt={match[1]} className="rounded-xl border border-slate-200 dark:border-slate-700 max-h-48 object-cover shadow-xs" />
            {match[1] && <span className="text-[10px] text-slate-400 dark:text-slate-500 block mt-1 italic">{match[1]}</span>}
          </div>
        );
      }
    } else {
      flushList(`p_${idx}`);
      elements.push(
        <p key={idx} className="text-xs text-slate-700 dark:text-slate-300 leading-relaxed mb-2">
          {parseInlineMarkdown(trimmed)}
        </p>
      );
    }
  });

  flushList('final');
  return <div className="space-y-1">{elements}</div>;
}

function parseInlineMarkdown(text: string): React.ReactNode {
  const parts = text.split(/(\*\*.*?\*\*|\*.*?\*|`.*?`)/g);
  return parts.map((part, i) => {
    if (part.startsWith('**') && part.endsWith('**')) {
      return <strong key={i} className="font-bold text-slate-900 dark:text-white">{part.slice(2, -2)}</strong>;
    }
    if (part.startsWith('*') && part.endsWith('*')) {
      return <em key={i} className="italic">{part.slice(1, -1)}</em>;
    }
    if (part.startsWith('`') && part.endsWith('`')) {
      return <code key={i} className="px-1 py-0.5 bg-slate-100 dark:bg-slate-800 rounded text-brand-700 dark:text-cyan-400 font-mono text-[11px]">{part.slice(1, -1)}</code>;
    }
    return part;
  });
}
