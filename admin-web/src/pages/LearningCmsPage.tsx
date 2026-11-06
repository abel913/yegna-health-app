import React, { useState } from 'react';
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
} from 'lucide-react';
import { Module } from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';
import { ConfirmModal } from '../components/common/ConfirmModal.js';

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
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingModule, setEditingModule] = useState<Module | null>(null);
  const [moduleToDelete, setModuleToDelete] = useState<Module | null>(null);
  const [activeTab, setActiveTab] = useState<'en' | 'am'>('en');
  const [previewMode, setPreviewMode] = useState<'edit' | 'preview'>('edit');

  const categories = ['All', 'puberty', 'srh', 'hiv', 'mental_health', 'gbv', 'substance'];

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

  const filtered = modules.filter(
    (m) => selectedCategory === 'All' || m.category === selectedCategory
  );

  const openCreateModal = () => {
    setEditingModule(null);
    setPreviewMode('edit');
    setFormData({
      category: 'puberty',
      titleEn: '',
      titleAm: '',
      summaryEn: '',
      summaryAm: '',
      contentEn: '## Overview\n\nWrite youth clinical education here...\n\n- Key Point 1: Healthy body changes\n- Key Point 2: Hygiene & care\n\n> Medical Note: Every adolescent develops at their own unique pace.',
      contentAm: '## አጠቃላይ መግለጫ\n\nትክክለኛ የጤና ትምህርት እዚህ ይጻፉ...\n\n- ዋና ነጥብ 1፡ ጤናማ የአካል ለውጦች\n- ዋና ነጥብ 2፡ ንፅህናና ጥንቃቄ\n\n> የዶክተር ማስታወሻ፡ እያንዳንዱ ታዳጊ በራሱ ፍጥነት ያድጋል።',
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
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 flex items-center gap-2">
            <BookOpen className="text-brand-600" size={24} />
            <span>{lang === 'am' ? 'የትምህርት ሞጁሎችና የዶክተር ማስታወሻዎች' : 'Health Curriculum CMS'}</span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 mt-1">
            {lang === 'am'
              ? 'የጉርምስና፣ የሥነ-ተዋልዶ፣ የኤች.አይ.ቪና የአእምሮ ጤና ትምህርቶችን በእንግሊዝኛና በአማርኛ ያዘጋጁ።'
              : 'Draft, publish, and update bilingual medical education verified for Ethiopian youth.'}
          </p>
        </div>

        <div className="flex items-center gap-2 self-start sm:self-auto">
          <button
            onClick={handleExportCsv}
            className="flex items-center gap-1.5 px-3.5 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs md:text-sm font-bold rounded-xl border border-slate-200 transition-all cursor-pointer"
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

      {/* Category Pills */}
      <div className="flex items-center gap-2 overflow-x-auto pb-1 text-xs font-bold">
        {categories.map((c) => (
          <button
            key={c}
            onClick={() => setSelectedCategory(c)}
            className={`px-3.5 py-1.5 rounded-xl transition-colors uppercase tracking-wider cursor-pointer ${
              selectedCategory === c
                ? 'bg-brand-600 text-white shadow-xs'
                : 'bg-white border border-slate-200 text-slate-600 hover:bg-slate-50'
            }`}
          >
            {c}
          </button>
        ))}
      </div>

      {/* Modules Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
        {filtered.map((m) => (
          <div
            key={m.id}
            className="bg-white rounded-2xl border border-slate-200/80 p-5 shadow-xs hover:shadow-md transition-all flex flex-col justify-between"
          >
            <div>
              <div className="flex items-start justify-between gap-3 mb-2">
                <span className="text-[10px] font-extrabold uppercase px-2.5 py-0.5 rounded-md bg-brand-50 text-brand-700 border border-brand-100">
                  {m.category}
                </span>
                <div className="flex items-center gap-1">
                  <button
                    onClick={() => openEditModal(m)}
                    className="p-1.5 text-slate-400 hover:text-brand-600 hover:bg-slate-50 rounded-lg cursor-pointer transition-colors"
                    title={lang === 'am' ? 'አርትዕ' : 'Edit module'}
                  >
                    <Edit2 size={14} />
                  </button>
                  <button
                    onClick={() => setModuleToDelete(m)}
                    className="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg cursor-pointer transition-colors"
                    title={lang === 'am' ? 'ሞጁሉን ሰርዝ' : 'Delete module'}
                  >
                    <Trash2 size={14} />
                  </button>
                </div>
              </div>

              <h3 className="font-extrabold text-slate-900 text-base mb-1">
                {lang === 'am' ? m.titleAm : m.titleEn}
              </h3>
              <p className="text-xs text-slate-400 mb-2">
                {lang === 'am' ? m.titleEn : m.titleAm}
              </p>
              <p className="text-xs text-slate-600 line-clamp-2 leading-relaxed">
                {lang === 'am' ? m.summaryAm : m.summaryEn}
              </p>
            </div>

            <div className="pt-4 mt-4 border-t border-slate-100 flex items-center justify-between text-xs text-slate-400">
              <span className="flex items-center gap-1 font-semibold text-slate-600">
                <Clock size={13} className="text-slate-400" />
                {m.readTimeMin} min read
              </span>
              <span className="text-[11px] truncate max-w-[180px]">{m.authorName || 'Medical Review Team'}</span>
            </div>
          </div>
        ))}
      </div>

      {/* Editor Modal with Markdown Live Preview */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl border border-slate-200 shadow-2xl max-w-3xl w-full max-h-[92vh] overflow-y-auto p-6 md:p-8 animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between pb-3 border-b border-slate-100">
              <div>
                <h3 className="text-lg font-extrabold text-slate-900">
                  {editingModule ? (lang === 'am' ? 'የትምህርት ሞጁልን አርትዕ' : 'Edit Health Module') : (lang === 'am' ? 'አዲስ የትምህርት ሞጁል ፍጠር' : 'Create Health Curriculum Module')}
                </h3>
                <p className="text-xs text-slate-400">
                  {lang === 'am' ? 'የዶክተር ማብራሪያዎችንና ማርክዳውን ያርትዑ' : 'Author bilingual youth medical education'}
                </p>
              </div>
              <button
                onClick={() => setIsModalOpen(false)}
                className="p-1 text-slate-400 hover:text-slate-600 rounded-lg hover:bg-slate-100 cursor-pointer"
              >
                <X size={20} />
              </button>
            </div>

            {/* Language Tabs Selector */}
            <div className="flex items-center justify-between gap-2 mt-4 border-b border-slate-100 pb-2">
              <div className="flex items-center gap-1.5">
                <button
                  type="button"
                  onClick={() => setActiveTab('en')}
                  className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
                    activeTab === 'en' ? 'bg-brand-600 text-white shadow-xs' : 'text-slate-500 hover:bg-slate-100'
                  }`}
                >
                  English Content
                </button>
                <button
                  type="button"
                  onClick={() => setActiveTab('am')}
                  className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-colors cursor-pointer ${
                    activeTab === 'am' ? 'bg-brand-600 text-white shadow-xs' : 'text-slate-500 hover:bg-slate-100'
                  }`}
                >
                  የአማርኛ ይዘት (Amharic)
                </button>
              </div>

              {/* Edit vs Live Preview Toggle */}
              <div className="flex items-center bg-slate-100 p-0.5 rounded-xl text-xs font-bold">
                <button
                  type="button"
                  onClick={() => setPreviewMode('edit')}
                  className={`flex items-center gap-1 px-2.5 py-1 rounded-lg transition-all cursor-pointer ${
                    previewMode === 'edit'
                      ? 'bg-white text-slate-900 shadow-xs'
                      : 'text-slate-500 hover:text-slate-900'
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
                      ? 'bg-white text-brand-700 shadow-xs'
                      : 'text-slate-500 hover:text-slate-900'
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
                  <label className="block font-bold text-slate-700 mb-1">
                    {lang === 'am' ? 'የትምህርት ዘርፍ' : 'Health Category'}
                  </label>
                  <select
                    value={formData.category}
                    onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl bg-white font-medium focus:border-brand-500 focus:outline-none"
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
                  <label className="block font-bold text-slate-700 mb-1">
                    {lang === 'am' ? 'የንባብ ጊዜ (ደቂቃ)' : 'Estimated Reading Time'}
                  </label>
                  <input
                    type="number"
                    value={formData.readTimeMin}
                    onChange={(e) => setFormData({ ...formData, readTimeMin: parseInt(e.target.value, 10) || 4 })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                  />
                </div>
              </div>

              {activeTab === 'en' ? (
                <>
                  <div>
                    <label className="block font-bold text-slate-700 mb-1">Title (English)</label>
                    <input
                      type="text"
                      required
                      value={formData.titleEn}
                      onChange={(e) => setFormData({ ...formData, titleEn: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                      placeholder="e.g. Understanding Physical Puberty Changes"
                    />
                  </div>
                  <div>
                    <label className="block font-bold text-slate-700 mb-1">Summary (English)</label>
                    <textarea
                      rows={2}
                      required
                      value={formData.summaryEn}
                      onChange={(e) => setFormData({ ...formData, summaryEn: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                    />
                  </div>

                  <div>
                    <div className="flex items-center justify-between mb-1.5">
                      <label className="font-bold text-slate-700 flex items-center gap-1.5">
                        <span>Article Content (English Markdown)</span>
                        <span className="text-[10px] text-slate-400 font-normal">Markdown Supported</span>
                      </label>

                      {/* Quick Markdown Toolbar Buttons */}
                      {previewMode === 'edit' && (
                        <div className="flex items-center gap-1">
                          <button
                            type="button"
                            onClick={() => insertMarkdown('**', '**')}
                            className="p-1 text-slate-500 hover:text-slate-900 hover:bg-slate-100 rounded"
                            title="Bold"
                          >
                            <Bold size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('## ')}
                            className="p-1 text-slate-500 hover:text-slate-900 hover:bg-slate-100 rounded"
                            title="H2 Heading"
                          >
                            <Heading2 size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('- ')}
                            className="p-1 text-slate-500 hover:text-slate-900 hover:bg-slate-100 rounded"
                            title="Bullet List"
                          >
                            <List size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('> ')}
                            className="p-1 text-slate-500 hover:text-slate-900 hover:bg-slate-100 rounded"
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
                        className="w-full px-3 py-2 border border-slate-200 rounded-xl font-mono text-xs focus:border-brand-500 focus:outline-none"
                      />
                    ) : (
                      <div className="w-full min-h-[170px] max-h-64 overflow-y-auto p-4 border border-brand-200 bg-slate-50/70 rounded-xl">
                        {renderMarkdown(formData.contentEn)}
                      </div>
                    )}
                  </div>
                </>
              ) : (
                <>
                  <div>
                    <label className="block font-bold text-slate-700 mb-1">ርዕስ (በአማርኛ)</label>
                    <input
                      type="text"
                      required
                      value={formData.titleAm}
                      onChange={(e) => setFormData({ ...formData, titleAm: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                      placeholder="ምሳሌ፡ የጉርምስና ወቅትና አካላዊ ለውጦች"
                    />
                  </div>
                  <div>
                    <label className="block font-bold text-slate-700 mb-1">ማጠቃለያ (በአማርኛ)</label>
                    <textarea
                      rows={2}
                      required
                      value={formData.summaryAm}
                      onChange={(e) => setFormData({ ...formData, summaryAm: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                    />
                  </div>

                  <div>
                    <div className="flex items-center justify-between mb-1.5">
                      <label className="font-bold text-slate-700 flex items-center gap-1.5">
                        <span>የትምህርት ይዘት (በአማርኛ ማርክዳውን)</span>
                        <span className="text-[10px] text-slate-400 font-normal">ማርክዳውን ይደግፋል</span>
                      </label>

                      {previewMode === 'edit' && (
                        <div className="flex items-center gap-1">
                          <button
                            type="button"
                            onClick={() => insertMarkdown('**', '**')}
                            className="p-1 text-slate-500 hover:text-slate-900 hover:bg-slate-100 rounded"
                            title="ደማቅ (Bold)"
                          >
                            <Bold size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('## ')}
                            className="p-1 text-slate-500 hover:text-slate-900 hover:bg-slate-100 rounded"
                            title="ንዑስ ርዕስ (H2)"
                          >
                            <Heading2 size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('- ')}
                            className="p-1 text-slate-500 hover:text-slate-900 hover:bg-slate-100 rounded"
                            title="ነጥቦች (List)"
                          >
                            <List size={13} />
                          </button>
                          <button
                            type="button"
                            onClick={() => insertMarkdown('> ')}
                            className="p-1 text-slate-500 hover:text-slate-900 hover:bg-slate-100 rounded"
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
                        className="w-full px-3 py-2 border border-slate-200 rounded-xl font-mono text-xs focus:border-brand-500 focus:outline-none"
                      />
                    ) : (
                      <div className="w-full min-h-[170px] max-h-64 overflow-y-auto p-4 border border-brand-200 bg-slate-50/70 rounded-xl">
                        {renderMarkdown(formData.contentAm)}
                      </div>
                    )}
                  </div>
                </>
              )}

              <div>
                <label className="block font-bold text-slate-700 mb-1">
                  {lang === 'am' ? 'የህክምና ባለሙያ / ደራሲ ስም' : 'Medical Author / Specialist Attribution'}
                </label>
                <input
                  type="text"
                  value={formData.authorName}
                  onChange={(e) => setFormData({ ...formData, authorName: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                  placeholder="e.g. Dr. Hanna Bekele, Adolescent Health Specialist"
                />
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-4 py-2 border border-slate-200 text-slate-600 font-bold rounded-xl hover:bg-slate-50 cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl shadow-md shadow-brand-600/20 cursor-pointer"
                >
                  {editingModule ? (lang === 'am' ? 'ለውጦችን መዝግብ' : 'Save Changes') : (lang === 'am' ? 'ሞጁል ፍጠር' : 'Publish Module')}
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
  if (!content) return <p className="text-slate-400 italic text-xs">No content entered.</p>;

  const lines = content.split('\n');
  const elements: React.ReactNode[] = [];
  let inList = false;
  let listItems: string[] = [];

  const flushList = (keyPrefix: string) => {
    if (inList && listItems.length > 0) {
      elements.push(
        <ul key={`${keyPrefix}_ul`} className="list-disc pl-5 space-y-1 mb-2.5 text-xs text-slate-700">
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
        <h3 key={idx} className="text-base font-extrabold text-slate-900 border-b border-slate-200 pb-1 mt-3 mb-2">
          {parseInlineMarkdown(trimmed.slice(2))}
        </h3>
      );
    } else if (trimmed.startsWith('## ')) {
      flushList(`h2_${idx}`);
      elements.push(
        <h4 key={idx} className="text-sm font-bold text-brand-800 mt-2.5 mb-1.5 flex items-center gap-1.5">
          <span className="w-1.5 h-1.5 rounded-full bg-brand-600 inline-block" />
          {parseInlineMarkdown(trimmed.slice(3))}
        </h4>
      );
    } else if (trimmed.startsWith('### ')) {
      flushList(`h3_${idx}`);
      elements.push(
        <h5 key={idx} className="text-xs font-bold text-slate-800 mt-2 mb-1">
          {parseInlineMarkdown(trimmed.slice(4))}
        </h5>
      );
    } else if (trimmed.startsWith('> ')) {
      flushList(`quote_${idx}`);
      elements.push(
        <blockquote key={idx} className="border-l-3 border-brand-500 bg-brand-50/70 pl-3 pr-2 py-1.5 rounded-r-lg italic text-xs text-brand-900 my-2">
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
            <img src={match[2]} alt={match[1]} className="rounded-xl border border-slate-200 max-h-48 object-cover shadow-xs" />
            {match[1] && <span className="text-[10px] text-slate-400 block mt-1 italic">{match[1]}</span>}
          </div>
        );
      }
    } else {
      flushList(`p_${idx}`);
      elements.push(
        <p key={idx} className="text-xs text-slate-700 leading-relaxed mb-2">
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
      return <strong key={i} className="font-bold text-slate-900">{part.slice(2, -2)}</strong>;
    }
    if (part.startsWith('*') && part.endsWith('*')) {
      return <em key={i} className="italic">{part.slice(1, -1)}</em>;
    }
    if (part.startsWith('`') && part.endsWith('`')) {
      return <code key={i} className="px-1 py-0.5 bg-slate-100 rounded text-brand-700 font-mono text-[11px]">{part.slice(1, -1)}</code>;
    }
    return part;
  });
}
