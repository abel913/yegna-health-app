import React, { useState } from 'react';
import {
  Users2,
  Plus,
  Phone,
  Send,
  CheckCircle2,
  Edit2,
  Trash2,
  X,
  Languages,
} from 'lucide-react';
import { Mentor } from '../types/index.js';
import { EmptyState } from '../components/common/EmptyState.js';

interface MentorsPageProps {
  mentors: Mentor[];
  lang: 'en' | 'am';
  onSave: (data: Partial<Mentor>, id?: string) => Promise<void>;
  onDelete: (id: string) => Promise<void>;
}

export const MentorsPage: React.FC<MentorsPageProps> = ({
  mentors,
  lang,
  onSave,
  onDelete,
}) => {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingMentor, setEditingMentor] = useState<Mentor | null>(null);

  const [formData, setFormData] = useState({
    name: '',
    organization: '',
    phone: '',
    telegramHandle: '',
    email: '',
    languages: ['Amharic', 'English'],
    specialties: ['#MentalHealth', '#SRH'],
    isAvailable: true,
    isVerified: true,
  });

  const openCreateModal = () => {
    setEditingMentor(null);
    setFormData({
      name: '',
      organization: 'Talent Youth Association (TYA)',
      phone: '+2519',
      telegramHandle: '@',
      email: '',
      languages: ['Amharic', 'English'],
      specialties: ['#MentalHealth', '#SRH'],
      isAvailable: true,
      isVerified: true,
    });
    setIsModalOpen(true);
  };

  const openEditModal = (m: Mentor) => {
    setEditingMentor(m);
    setFormData({
      name: m.name,
      organization: m.organization,
      phone: m.phone,
      telegramHandle: m.telegramHandle || '',
      email: m.email || '',
      languages: m.languages || ['Amharic', 'English'],
      specialties: m.specialties || [],
      isAvailable: m.isAvailable,
      isVerified: m.isVerified,
    });
    setIsModalOpen(true);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await onSave(formData, editingMentor ? editingMentor.id : undefined);
    setIsModalOpen(false);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            <Users2 className="text-brand-600 dark:text-cyan-400" size={24} />
            <span>{lang === 'am' ? 'የተመሰከረላቸው የወጣቶች አማካሪዎች' : 'Certified Peer Mentors & Counselors'}</span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1">
            {lang === 'am'
              ? 'የወጣቶች አእምሮ ጤና፣ የሥነ-ተዋልዶ እና የአፍላ ዕድሜ የምክር አገልግሎት ሰጪዎችን ያስተዳድሩ።'
              : 'Manage certified youth peer counselors, Telegram contact handles, hotlines, and availability.'}
          </p>
        </div>
        <button
          onClick={openCreateModal}
          className="flex items-center gap-2 px-4 py-2.5 bg-brand-600 hover:bg-brand-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md shadow-brand-600/20 transition-all self-start sm:self-auto cursor-pointer"
        >
          <Plus size={16} />
          <span>{lang === 'am' ? '+ አዲስ አማካሪ መዝግብ' : '+ Add New Mentor'}</span>
        </button>
      </div>

      {/* Counselor Grid or Empty State */}
      {mentors.length === 0 ? (
        <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs">
          <EmptyState
            icon={Users2}
            title={lang === 'am' ? 'ምንም አማካሪዎች አልተመዘገቡም' : 'No Peer Mentors Registered'}
            description={
              lang === 'am'
                ? 'የተመሰከረላቸው የወጣቶች አማካሪዎችን እና የምክር አገልግሎት ሰጪዎችን በመመዝገብ ለተማሪዎች ቀጥተኛ ድጋፍ ይስጡ።'
                : 'Add certified youth peer mentors, hotlines, and Telegram counselors to support student mental and reproductive health.'
            }
            actionLabel={lang === 'am' ? '+ አዲስ አማካሪ መዝግብ' : '+ Add New Mentor'}
            onAction={openCreateModal}
          />
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {mentors.map((m) => (
            <div
              key={m.id}
              className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-5 shadow-xs hover:shadow-md transition-all flex flex-col justify-between"
            >
              <div>
                {/* Header Info */}
                <div className="flex items-start justify-between gap-3 mb-3">
                  <div className="flex items-center gap-3">
                    <div className="w-12 h-12 rounded-full bg-gradient-to-tr from-cyan-500 via-blue-600 to-indigo-600 text-white font-extrabold text-sm flex items-center justify-center shadow-sm">
                      {m.name.slice(0, 2).toUpperCase()}
                    </div>
                    <div>
                      <div className="flex items-center gap-1.5">
                        <h3 className="font-bold text-slate-900 dark:text-white text-sm leading-tight">{m.name}</h3>
                        {m.isVerified && <CheckCircle2 size={14} className="text-brand-600 dark:text-cyan-400 flex-shrink-0" />}
                      </div>
                      <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">{m.organization}</p>
                    </div>
                  </div>

                  <div className="flex items-center gap-1">
                    <button
                      onClick={() => openEditModal(m)}
                      className="p-1.5 text-slate-400 hover:text-brand-600 dark:hover:text-cyan-400 hover:bg-slate-50 dark:hover:bg-slate-800 rounded-lg cursor-pointer"
                    >
                      <Edit2 size={14} />
                    </button>
                    <button
                      onClick={() => {
                        if (confirm(`Delete mentor ${m.name}?`)) onDelete(m.id);
                      }}
                      className="p-1.5 text-slate-400 hover:text-rose-600 dark:hover:text-rose-400 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-lg cursor-pointer"
                    >
                      <Trash2 size={14} />
                    </button>
                  </div>
                </div>

                {/* Status Badge */}
                <div className="flex items-center gap-2 mb-3">
                  <span
                    className={`inline-flex items-center gap-1.5 text-[11px] font-bold px-2.5 py-0.5 rounded-full ${
                      m.isAvailable
                        ? 'bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800'
                        : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400'
                    }`}
                  >
                    <span
                      className={`w-1.5 h-1.5 rounded-full ${
                        m.isAvailable ? 'bg-emerald-500 animate-pulse' : 'bg-slate-400'
                      }`}
                    />
                    {m.isAvailable ? (lang === 'am' ? 'አሁን ይገኛል' : 'Available Now') : (lang === 'am' ? 'ዝግ ነው' : 'Offline')}
                  </span>
                  <span className="text-xs text-slate-400 dark:text-slate-500 flex items-center gap-1">
                    <Languages size={12} />
                    {(m.languages || []).join(' • ')}
                  </span>
                </div>

                {/* Specialty Tags */}
                <div className="flex flex-wrap gap-1.5 mb-4">
                  {(m.specialties || []).map((s, idx) => (
                    <span key={idx} className="text-[10px] font-bold px-2 py-0.5 rounded-md bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 border border-slate-200/50 dark:border-slate-700/50">
                      {s}
                    </span>
                  ))}
                </div>
              </div>

              {/* Contact Channels Bar */}
              <div className="pt-3 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between text-xs">
                <a
                  href={`tel:${m.phone}`}
                  className="inline-flex items-center gap-1 font-bold text-slate-700 dark:text-slate-300 hover:text-brand-600 dark:hover:text-cyan-400"
                >
                  <Phone size={13} className="text-slate-400" />
                  {m.phone}
                </a>
                {m.telegramHandle && (
                  <a
                    href={`https://t.me/${m.telegramHandle.replace('@', '')}`}
                    target="_blank"
                    rel="noreferrer"
                    className="inline-flex items-center gap-1 font-bold text-sky-600 dark:text-sky-400 hover:underline"
                  >
                    <Send size={12} />
                    {m.telegramHandle}
                  </a>
                )}
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Modal Dialog */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-lg w-full max-h-[90vh] overflow-y-auto p-6 md:p-8 animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between pb-4 border-b border-slate-100 dark:border-slate-800">
              <h3 className="text-lg font-extrabold text-slate-900 dark:text-white">
                {editingMentor ? 'Edit Counselor Profile' : 'Register New Certified Mentor'}
              </h3>
              <button onClick={() => setIsModalOpen(false)} className="p-1 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 cursor-pointer">
                <X size={20} />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="mt-4 space-y-3.5 text-xs md:text-sm">
              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">Full Name</label>
                <input
                  type="text"
                  required
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                  placeholder="e.g. Selamawit Tadesse"
                />
              </div>

              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">Organization / Affiliation</label>
                <input
                  type="text"
                  required
                  value={formData.organization}
                  onChange={(e) => setFormData({ ...formData, organization: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                  placeholder="e.g. Talent Youth Association (TYA)"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">Phone Number</label>
                  <input
                    type="text"
                    required
                    value={formData.phone}
                    onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="+251911223344"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">Telegram Handle</label>
                  <input
                    type="text"
                    value={formData.telegramHandle}
                    onChange={(e) => setFormData({ ...formData, telegramHandle: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="@username"
                  />
                </div>
              </div>

              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">Email Address</label>
                <input
                  type="email"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                  placeholder="mentor@organization.org"
                />
              </div>

              <div className="flex items-center gap-4 pt-2">
                <label className="flex items-center gap-2 cursor-pointer text-xs font-bold text-slate-700 dark:text-slate-300">
                  <input
                    type="checkbox"
                    checked={formData.isAvailable}
                    onChange={(e) => setFormData({ ...formData, isAvailable: e.target.checked })}
                    className="rounded text-brand-600 focus:ring-brand-500"
                  />
                  Available Now (Online)
                </label>
                <label className="flex items-center gap-2 cursor-pointer text-xs font-bold text-slate-700 dark:text-slate-300">
                  <input
                    type="checkbox"
                    checked={formData.isVerified}
                    onChange={(e) => setFormData({ ...formData, isVerified: e.target.checked })}
                    className="rounded text-brand-600 focus:ring-brand-500"
                  />
                  Verified Checkmark
                </label>
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-slate-100 dark:border-slate-800">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-4 py-2 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 font-bold rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800 cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl shadow-md cursor-pointer"
                >
                  Save Mentor
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
