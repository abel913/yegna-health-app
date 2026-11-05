import React, { useState } from 'react';
import {
  BookOpen,
  Plus,
  Edit2,
  Trash2,
  Clock,
  X,
} from 'lucide-react';
import { Module } from '../types/index.js';

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
  const [activeTab, setActiveTab] = useState<'en' | 'am'>('en');

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
    setFormData({
      category: 'puberty',
      titleEn: '',
      titleAm: '',
      summaryEn: '',
      summaryAm: '',
      contentEn: '# Overview\n\nWrite clinical youth education here...',
      contentAm: '# አጠቃላይ መግለጫ\n\nትክክለኛ የጤና ትምህርት እዚህ ይጻፉ...',
      readTimeMin: 4,
      authorName: 'Adolescent Health Specialist',
      isPublished: true,
      orderIndex: modules.length + 1,
    });
    setIsModalOpen(true);
  };

  const openEditModal = (m: Module) => {
    setEditingModule(m);
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
        <button
          onClick={openCreateModal}
          className="flex items-center gap-2 px-4 py-2.5 bg-brand-600 hover:bg-brand-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md shadow-brand-600/20 transition-all self-start sm:self-auto"
        >
          <Plus size={16} />
          <span>{lang === 'am' ? '+ አዲስ ትምህርት ጨምር' : '+ New Health Module'}</span>
        </button>
      </div>

      {/* Category Pills */}
      <div className="flex items-center gap-2 overflow-x-auto pb-1 text-xs font-bold">
        {categories.map((c) => (
          <button
            key={c}
            onClick={() => setSelectedCategory(c)}
            className={`px-3.5 py-1.5 rounded-xl transition-colors uppercase tracking-wider ${
              selectedCategory === c
                ? 'bg-brand-600 text-white'
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
                    className="p-1.5 text-slate-400 hover:text-brand-600 hover:bg-slate-50 rounded-lg"
                  >
                    <Edit2 size={14} />
                  </button>
                  <button
                    onClick={() => {
                      if (confirm(`Delete module ${m.titleEn}?`)) onDelete(m.id);
                    }}
                    className="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg"
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

      {/* Editor Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl border border-slate-200 shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto p-6 md:p-8 animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between pb-3 border-b border-slate-100">
              <h3 className="text-lg font-extrabold text-slate-900">
                {editingModule ? 'Edit Health Module' : 'Create Health Curriculum Module'}
              </h3>
              <button onClick={() => setIsModalOpen(false)} className="p-1 text-slate-400 hover:text-slate-600">
                <X size={20} />
              </button>
            </div>

            {/* Language Tabs Selector */}
            <div className="flex items-center gap-2 mt-4 border-b border-slate-100 pb-2">
              <button
                type="button"
                onClick={() => setActiveTab('en')}
                className={`px-3 py-1 rounded-lg text-xs font-bold transition-colors ${
                  activeTab === 'en' ? 'bg-brand-600 text-white' : 'text-slate-500 hover:bg-slate-100'
                }`}
              >
                English Content
              </button>
              <button
                type="button"
                onClick={() => setActiveTab('am')}
                className={`px-3 py-1 rounded-lg text-xs font-bold transition-colors ${
                  activeTab === 'am' ? 'bg-brand-600 text-white' : 'text-slate-500 hover:bg-slate-100'
                }`}
              >
                የአማርኛ ይዘት (Amharic)
              </button>
            </div>

            <form onSubmit={handleSubmit} className="mt-4 space-y-3.5 text-xs md:text-sm">
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Health Category</label>
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
                  <label className="block font-bold text-slate-700 mb-1">Estimated Reading Time</label>
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
                    <label className="block font-bold text-slate-700 mb-1">Article Content (Markdown)</label>
                    <textarea
                      rows={6}
                      required
                      value={formData.contentEn}
                      onChange={(e) => setFormData({ ...formData, contentEn: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 rounded-xl font-mono text-xs focus:border-brand-500 focus:outline-none"
                    />
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
                    <label className="block font-bold text-slate-700 mb-1">የትምህርት ይዘት (በአማርኛ ማርክዳውን)</label>
                    <textarea
                      rows={6}
                      required
                      value={formData.contentAm}
                      onChange={(e) => setFormData({ ...formData, contentAm: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 rounded-xl font-mono text-xs focus:border-brand-500 focus:outline-none"
                    />
                  </div>
                </>
              )}

              <div>
                <label className="block font-bold text-slate-700 mb-1">Medical Author / Specialist Attribution</label>
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
                  className="px-4 py-2 border border-slate-200 text-slate-600 font-bold rounded-xl hover:bg-slate-50"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl shadow-md"
                >
                  Save Module
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
