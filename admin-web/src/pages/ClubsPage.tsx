import React, { useState } from 'react';
import {
  GraduationCap,
  Plus,
  Users,
  MapPin,
  Calendar,
  Trash2,
  Edit2,
  Eye,
  CheckCircle2,
  Clock,
  Download,
  X,
} from 'lucide-react';
import { StudentClub } from '../types/index.js';
import { api } from '../services/api.js';
import { exportToCsv } from '../utils/csvExport.js';
import { useToast } from '../context/ToastContext.js';
import { EmptyState } from '../components/common/EmptyState.js';
import { ConfirmModal } from '../components/common/ConfirmModal.js';

interface ClubsPageProps {
  clubs: StudentClub[];
  lang: 'en' | 'am';
  onSaveClub: (data: Partial<StudentClub>, id?: string) => Promise<void>;
  onDeleteClub: (id: string) => Promise<void>;
  onToggleApproval: (club: StudentClub) => Promise<void>;
}

export const ClubsPage: React.FC<ClubsPageProps> = ({
  clubs,
  lang,
  onSaveClub,
  onDeleteClub,
  onToggleApproval,
}) => {
  const { toast } = useToast();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingClub, setEditingClub] = useState<StudentClub | null>(null);
  const [clubToDelete, setClubToDelete] = useState<StudentClub | null>(null);
  const [rosterModal, setRosterModal] = useState<{ open: boolean; clubName: string; members: any[] }>({
    open: false,
    clubName: '',
    members: [],
  });

  const [formData, setFormData] = useState({
    name: '',
    description: '',
    category: 'wellness',
    venue: '',
    meetingTime: '',
    isApproved: true,
  });

  const openCreateModal = () => {
    setEditingClub(null);
    setFormData({
      name: '',
      description: '',
      category: 'wellness',
      venue: '',
      meetingTime: '',
      isApproved: true,
    });
    setIsModalOpen(true);
  };

  const openEditModal = (c: StudentClub) => {
    setEditingClub(c);
    setFormData({
      name: c.name,
      description: c.description,
      category: c.category,
      venue: c.venue || '',
      meetingTime: c.meetingTime || '',
      isApproved: c.isApproved,
    });
    setIsModalOpen(true);
  };

  const openRoster = async (club: StudentClub) => {
    try {
      const data = await api.getClubRoster(club.id);
      setRosterModal({ open: true, clubName: data.clubName, members: data.roster || [] });
    } catch (err: any) {
      toast.error('Failed to load roster: ' + err.message, 'Roster Error');
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await onSaveClub(formData, editingClub ? editingClub.id : undefined);
    setIsModalOpen(false);
  };

  const handleExportCsv = () => {
    exportToCsv(
      'Yegna_Health_Student_Clubs',
      [
        { header: 'Club Name', accessor: (c) => c.name },
        { header: 'Category', accessor: (c) => c.category },
        { header: 'Active Members', accessor: (c) => c.memberCount || 0 },
        { header: 'Meeting Venue', accessor: (c) => c.venue || 'TBD' },
        { header: 'Schedule', accessor: (c) => c.meetingTime || 'TBD' },
        { header: 'Approval Status', accessor: (c) => (c.isApproved ? 'APPROVED' : 'PENDING') },
        { header: 'Description', accessor: (c) => c.description },
      ],
      clubs
    );
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            <GraduationCap className="text-brand-600 dark:text-cyan-400" size={24} />
            <span>{lang === 'am' ? 'የተማሪዎች ጤና ክለቦች' : 'Student Health Clubs & Chapters'}</span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1">
            {lang === 'am'
              ? 'የትምህርት ቤት የወጣቶች ጤና ክለቦችን፣ የአባላት ዝርዝርና የመሰብሰቢያ ሰዓቶችን ያስተዳድሩ።'
              : 'Moderate student peer support chapters, meeting schedules, and member rosters.'}
          </p>
        </div>
        <div className="flex items-center gap-2 self-start sm:self-auto">
          <button
            onClick={handleExportCsv}
            className="flex items-center gap-1.5 px-3.5 py-2.5 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs md:text-sm font-bold rounded-xl border border-slate-200 dark:border-slate-700 transition-all cursor-pointer shadow-2xs"
            title={lang === 'am' ? 'የክለቦች ሪፖርት (CSV) አውርድ' : 'Export clubs to Excel CSV'}
          >
            <Download size={15} />
            <span>{lang === 'am' ? 'ሪፖርት (CSV)' : 'Export CSV'}</span>
          </button>
          <button
            onClick={openCreateModal}
            className="flex items-center gap-2 px-4 py-2.5 bg-brand-600 hover:bg-brand-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md shadow-brand-600/20 transition-all cursor-pointer"
          >
            <Plus size={16} />
            <span>{lang === 'am' ? '+ አዲስ ክለብ ፍጠር' : '+ Create Student Club'}</span>
          </button>
        </div>
      </div>

      {/* Clubs Grid or Empty State */}
      {clubs.length === 0 ? (
        <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs">
          <EmptyState
            icon={GraduationCap}
            title={lang === 'am' ? 'ምንም የተማሪ ክለቦች አልተመዘገቡም' : 'No Student Clubs Found'}
            description={
              lang === 'am'
                ? 'አዳዲስ የትምህርት ቤት የጤና ክለቦችን፣ የአባላት ዝርዝርና የመሰብሰቢያ ሰዓቶችን በማስገባት ይጀምሩ።'
                : 'Start by creating health and peer-support chapters across university and high school campuses.'
            }
            actionLabel={lang === 'am' ? '+ አዲስ ክለብ ፍጠር' : '+ Create Student Club'}
            onAction={openCreateModal}
          />
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {clubs.map((c) => (
            <div
              key={c.id}
              className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-5 shadow-xs hover:shadow-md transition-all flex flex-col justify-between"
            >
              <div>
                <div className="flex items-center justify-between gap-2 mb-2.5">
                  <span className="text-[10px] font-extrabold uppercase px-2.5 py-0.5 rounded-md bg-brand-50 dark:bg-brand-950/50 text-brand-700 dark:text-cyan-400 border border-brand-100 dark:border-brand-900/40">
                    {c.category}
                  </span>

                  <div className="flex items-center gap-1.5">
                    {/* Inline 1-Click Approval Toggle */}
                    <button
                      onClick={() => onToggleApproval(c)}
                      className={`px-2 py-0.5 rounded-full text-[10px] font-bold flex items-center gap-1 transition-colors cursor-pointer ${
                        c.isApproved
                          ? 'bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 hover:bg-emerald-100 dark:hover:bg-emerald-900/50 border border-emerald-200 dark:border-emerald-800'
                          : 'bg-amber-50 dark:bg-amber-950/40 text-amber-700 dark:text-amber-300 hover:bg-amber-100 dark:hover:bg-amber-900/50 border border-amber-200 dark:border-amber-800'
                      }`}
                      title={lang === 'am' ? 'የፍቃድ ሁኔታን ለመቀየር ይጫኑ' : 'Click to toggle approval'}
                    >
                      {c.isApproved ? (
                        <>
                          <CheckCircle2 size={11} className="text-emerald-600 dark:text-emerald-400" />
                          <span>{lang === 'am' ? 'የተፈቀደ' : 'Approved'}</span>
                        </>
                      ) : (
                        <>
                          <Clock size={11} className="text-amber-600 dark:text-amber-400" />
                          <span>{lang === 'am' ? 'በመጠባበቅ ላይ' : 'Pending'}</span>
                        </>
                      )}
                    </button>

                    {/* Edit Button */}
                    <button
                      onClick={() => openEditModal(c)}
                      className="p-1.5 text-slate-400 hover:text-brand-600 dark:hover:text-cyan-400 hover:bg-brand-50 dark:hover:bg-slate-800 rounded-lg transition-colors cursor-pointer"
                      title={lang === 'am' ? 'አርትዕ' : 'Edit club'}
                    >
                      <Edit2 size={14} />
                    </button>

                    {/* Delete Button */}
                    <button
                      onClick={() => setClubToDelete(c)}
                      className="p-1.5 text-slate-400 hover:text-rose-600 dark:hover:text-rose-400 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-lg transition-colors cursor-pointer"
                      title={lang === 'am' ? 'ክለቡን ሰርዝ' : 'Delete club'}
                    >
                      <Trash2 size={14} />
                    </button>
                  </div>
                </div>

                <h3 className="font-extrabold text-slate-900 dark:text-white text-base mb-1">{c.name}</h3>
                <p className="text-xs text-slate-600 dark:text-slate-400 line-clamp-3 leading-relaxed mb-4">{c.description}</p>

                <div className="space-y-1.5 text-xs text-slate-500 dark:text-slate-400">
                  {c.venue && (
                    <div className="flex items-center gap-1.5">
                      <MapPin size={13} className="text-slate-400 dark:text-slate-500" />
                      <span className="truncate">{c.venue}</span>
                    </div>
                  )}
                  {c.meetingTime && (
                    <div className="flex items-center gap-1.5">
                      <Calendar size={13} className="text-slate-400 dark:text-slate-500" />
                      <span>{c.meetingTime}</span>
                    </div>
                  )}
                </div>
              </div>

              <div className="pt-4 mt-4 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between text-xs">
                <span className="flex items-center gap-1 font-bold text-slate-700 dark:text-slate-300">
                  <Users size={14} className="text-brand-600 dark:text-cyan-400" />
                  {c.memberCount || 0} {lang === 'am' ? 'አባላት' : 'members'}
                </span>
                <button
                  onClick={() => openRoster(c)}
                  className="flex items-center gap-1 font-bold text-brand-600 dark:text-cyan-400 hover:underline cursor-pointer"
                >
                  <Eye size={13} />
                  {lang === 'am' ? 'አባላትን እይ' : 'View Roster'}
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Roster Modal */}
      {rosterModal.open && (
        <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-lg w-full max-h-[80vh] overflow-y-auto p-6 animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between pb-3 border-b border-slate-100 dark:border-slate-800">
              <div>
                <h3 className="text-base font-extrabold text-slate-900 dark:text-white">Member Roster</h3>
                <p className="text-xs text-slate-400 dark:text-slate-500">{rosterModal.clubName}</p>
              </div>
              <button
                onClick={() => setRosterModal({ open: false, clubName: '', members: [] })}
                className="p-1 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 cursor-pointer"
              >
                <X size={20} />
              </button>
            </div>

            <div className="mt-4 space-y-2">
              {rosterModal.members.map((m: any, idx: number) => (
                <div key={idx} className="p-2.5 rounded-xl bg-slate-50 dark:bg-slate-800/60 border border-slate-100 dark:border-slate-700/60 flex items-center justify-between text-xs">
                  <div>
                    <p className="font-bold text-slate-900 dark:text-white">{m.user?.displayName || 'Student'}</p>
                    <p className="text-[11px] text-slate-400 dark:text-slate-500">{m.user?.email}</p>
                  </div>
                  <span className="text-[10px] text-slate-400 dark:text-slate-500">
                    Joined {new Date(m.joinedAt).toLocaleDateString()}
                  </span>
                </div>
              ))}
              {rosterModal.members.length === 0 && (
                <p className="py-8 text-center text-xs text-slate-400 dark:text-slate-500 font-semibold">No students have joined this club yet.</p>
              )}
            </div>
          </div>
        </div>
      )}

      {/* Create / Edit Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-lg w-full p-6 md:p-8 animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between pb-3 border-b border-slate-100 dark:border-slate-800">
              <h3 className="text-lg font-extrabold text-slate-900 dark:text-white">
                {editingClub
                  ? (lang === 'am' ? 'የተማሪዎች ክለብን አርትዕ' : 'Edit Student Club')
                  : (lang === 'am' ? 'አዲስ የተማሪዎች ክለብ ፍጠር' : 'Register New Student Club')}
              </h3>
              <button onClick={() => setIsModalOpen(false)} className="p-1 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 cursor-pointer">
                <X size={20} />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="mt-4 space-y-3.5 text-xs md:text-sm">
              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                  {lang === 'am' ? 'የክለቡ ስም' : 'Club Name'}
                </label>
                <input
                  type="text"
                  required
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                  placeholder="e.g. Arada Youth Wellness Club"
                />
              </div>

              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                  {lang === 'am' ? 'ምድብ' : 'Category'}
                </label>
                <select
                  value={formData.category}
                  onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white font-medium focus:border-brand-500 focus:outline-none cursor-pointer"
                >
                  <option value="wellness">Wellness & Lifestyle</option>
                  <option value="mental_health">Mental Health & Stress</option>
                  <option value="srh">SRH & Peer Education</option>
                  <option value="leadership">Youth Leadership & Advocacy</option>
                </select>
              </div>

              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                  {lang === 'am' ? 'መግለጫ' : 'Description'}
                </label>
                <textarea
                  rows={3}
                  required
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl text-xs focus:border-brand-500 focus:outline-none"
                  placeholder="Purpose, activities, and goals..."
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    {lang === 'am' ? 'የመሰብሰቢያ ቦታ' : 'Meeting Venue'}
                  </label>
                  <input
                    type="text"
                    value={formData.venue}
                    onChange={(e) => setFormData({ ...formData, venue: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="e.g. School Hall / Library"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    {lang === 'am' ? 'የመሰብሰቢያ ሰዓት' : 'Meeting Schedule'}
                  </label>
                  <input
                    type="text"
                    value={formData.meetingTime}
                    onChange={(e) => setFormData({ ...formData, meetingTime: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="e.g. Every Wed at 4:30 PM"
                  />
                </div>
              </div>

              <div className="pt-1 flex items-center gap-2">
                <input
                  type="checkbox"
                  id="clubApproved"
                  checked={formData.isApproved}
                  onChange={(e) => setFormData({ ...formData, isApproved: e.target.checked })}
                  className="w-4 h-4 text-brand-600 rounded border-slate-300 focus:ring-brand-500"
                />
                <label htmlFor="clubApproved" className="text-xs font-bold text-slate-700 dark:text-slate-300 cursor-pointer">
                  {lang === 'am' ? 'ይህ ክለብ በይፋ እንዲታይ የተፈቀደ ነው (Approved)' : 'Club is officially approved and active'}
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
                  className="px-5 py-2 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl shadow-md shadow-brand-600/20 cursor-pointer"
                >
                  {editingClub
                    ? (lang === 'am' ? 'ለውጦችን መዝግብ' : 'Save Changes')
                    : (lang === 'am' ? 'ክለብ ፍጠር' : 'Create Club')}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
      {/* Delete Confirmation Modal */}
      <ConfirmModal
        isOpen={Boolean(clubToDelete)}
        onClose={() => setClubToDelete(null)}
        onConfirm={async () => {
          if (clubToDelete) {
            await onDeleteClub(clubToDelete.id);
          }
        }}
        title={lang === 'am' ? 'የተማሪዎች ክለብ ይሰረዝ?' : 'Delete Student Health Club?'}
        itemName={clubToDelete?.name || ''}
        message={
          lang === 'am'
            ? 'ይህ እርምጃ ክለቡንና የአባላት መዝገብን በቋሚነት ያጠፋል። ተማሪዎች ይህንን ክለብ በካምፓስ ማህበር ውስጥ አያገኙትም።'
            : 'This will permanently remove the student club chapter, its meeting schedule, and member roster.'
        }
        lang={lang}
      />
    </div>
  );
};
