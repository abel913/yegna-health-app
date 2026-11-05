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
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 flex items-center gap-2">
            <GraduationCap className="text-brand-600" size={24} />
            <span>{lang === 'am' ? 'የተማሪዎች ጤና ክለቦች' : 'Student Health Clubs & Chapters'}</span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 mt-1">
            {lang === 'am'
              ? 'የትምህርት ቤት የወጣቶች ጤና ክለቦችን፣ የአባላት ዝርዝርና የመሰብሰቢያ ሰዓቶችን ያስተዳድሩ።'
              : 'Moderate student peer support chapters, meeting schedules, and member rosters.'}
          </p>
        </div>
        <div className="flex items-center gap-2 self-start sm:self-auto">
          <button
            onClick={handleExportCsv}
            className="flex items-center gap-1.5 px-3.5 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs md:text-sm font-bold rounded-xl border border-slate-200 transition-all cursor-pointer"
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

      {/* Clubs Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        {clubs.map((c) => (
          <div
            key={c.id}
            className="bg-white rounded-2xl border border-slate-200/80 p-5 shadow-xs hover:shadow-md transition-all flex flex-col justify-between"
          >
            <div>
              <div className="flex items-center justify-between gap-2 mb-2.5">
                <span className="text-[10px] font-extrabold uppercase px-2.5 py-0.5 rounded-md bg-brand-50 text-brand-700">
                  {c.category}
                </span>

                <div className="flex items-center gap-1.5">
                  {/* Inline 1-Click Approval Toggle */}
                  <button
                    onClick={() => onToggleApproval(c)}
                    className={`px-2 py-0.5 rounded-full text-[10px] font-bold flex items-center gap-1 transition-colors cursor-pointer ${
                      c.isApproved
                        ? 'bg-emerald-50 text-emerald-700 hover:bg-emerald-100 border border-emerald-200'
                        : 'bg-amber-50 text-amber-700 hover:bg-amber-100 border border-amber-200'
                    }`}
                    title={lang === 'am' ? 'የፍቃድ ሁኔታን ለመቀየር ይጫኑ' : 'Click to toggle approval'}
                  >
                    {c.isApproved ? (
                      <>
                        <CheckCircle2 size={11} className="text-emerald-600" />
                        <span>{lang === 'am' ? 'የተፈቀደ' : 'Approved'}</span>
                      </>
                    ) : (
                      <>
                        <Clock size={11} className="text-amber-600" />
                        <span>{lang === 'am' ? 'በመጠባበቅ ላይ' : 'Pending'}</span>
                      </>
                    )}
                  </button>

                  {/* Edit Button */}
                  <button
                    onClick={() => openEditModal(c)}
                    className="p-1.5 text-slate-400 hover:text-brand-600 hover:bg-brand-50 rounded-lg transition-colors"
                    title={lang === 'am' ? 'አርትዕ' : 'Edit club'}
                  >
                    <Edit2 size={14} />
                  </button>

                  {/* Delete Button */}
                  <button
                    onClick={() => {
                      if (confirm(lang === 'am' ? `ክለብ "${c.name}" ይሰረዝ?` : `Delete club "${c.name}"?`)) {
                        onDeleteClub(c.id);
                      }
                    }}
                    className="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg transition-colors"
                    title={lang === 'am' ? 'ሰርዝ' : 'Delete club'}
                  >
                    <Trash2 size={14} />
                  </button>
                </div>
              </div>

              <h3 className="font-extrabold text-slate-900 text-base mb-1">{c.name}</h3>
              <p className="text-xs text-slate-600 line-clamp-3 leading-relaxed mb-4">{c.description}</p>

              <div className="space-y-1.5 text-xs text-slate-500">
                {c.venue && (
                  <div className="flex items-center gap-1.5">
                    <MapPin size={13} className="text-slate-400" />
                    <span className="truncate">{c.venue}</span>
                  </div>
                )}
                {c.meetingTime && (
                  <div className="flex items-center gap-1.5">
                    <Calendar size={13} className="text-slate-400" />
                    <span>{c.meetingTime}</span>
                  </div>
                )}
              </div>
            </div>

            <div className="pt-4 mt-4 border-t border-slate-100 flex items-center justify-between text-xs">
              <span className="flex items-center gap-1 font-bold text-slate-700">
                <Users size={14} className="text-brand-600" />
                {c.memberCount || 0} {lang === 'am' ? 'አባላት' : 'members'}
              </span>
              <button
                onClick={() => openRoster(c)}
                className="flex items-center gap-1 font-bold text-brand-600 hover:underline"
              >
                <Eye size={13} />
                {lang === 'am' ? 'አባላትን እይ' : 'View Roster'}
              </button>
            </div>
          </div>
        ))}
      </div>

      {/* Roster Modal */}
      {rosterModal.open && (
        <div className="fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl border border-slate-200 shadow-2xl max-w-lg w-full max-h-[80vh] overflow-y-auto p-6 animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between pb-3 border-b border-slate-100">
              <div>
                <h3 className="text-base font-extrabold text-slate-900">Member Roster</h3>
                <p className="text-xs text-slate-400">{rosterModal.clubName}</p>
              </div>
              <button
                onClick={() => setRosterModal({ open: false, clubName: '', members: [] })}
                className="p-1 text-slate-400 hover:text-slate-600"
              >
                <X size={20} />
              </button>
            </div>

            <div className="mt-4 space-y-2">
              {rosterModal.members.map((m: any, idx: number) => (
                <div key={idx} className="p-2.5 rounded-xl bg-slate-50 border border-slate-100 flex items-center justify-between text-xs">
                  <div>
                    <p className="font-bold text-slate-900">{m.user?.displayName || 'Student'}</p>
                    <p className="text-[11px] text-slate-400">{m.user?.email}</p>
                  </div>
                  <span className="text-[10px] text-slate-400">
                    Joined {new Date(m.joinedAt).toLocaleDateString()}
                  </span>
                </div>
              ))}
              {rosterModal.members.length === 0 && (
                <p className="py-8 text-center text-xs text-slate-400 font-semibold">No students have joined this club yet.</p>
              )}
            </div>
          </div>
        </div>
      )}

      {/* Create / Edit Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl border border-slate-200 shadow-2xl max-w-lg w-full p-6 md:p-8 animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between pb-3 border-b border-slate-100">
              <h3 className="text-lg font-extrabold text-slate-900">
                {editingClub
                  ? (lang === 'am' ? 'የተማሪዎች ክለብን አርትዕ' : 'Edit Student Club')
                  : (lang === 'am' ? 'አዲስ የተማሪዎች ክለብ ፍጠር' : 'Register New Student Club')}
              </h3>
              <button onClick={() => setIsModalOpen(false)} className="p-1 text-slate-400 hover:text-slate-600">
                <X size={20} />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="mt-4 space-y-3.5 text-xs md:text-sm">
              <div>
                <label className="block font-bold text-slate-700 mb-1">
                  {lang === 'am' ? 'የክለቡ ስም' : 'Club Name'}
                </label>
                <input
                  type="text"
                  required
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl"
                  placeholder="e.g. Arada Youth Wellness Club"
                />
              </div>

              <div>
                <label className="block font-bold text-slate-700 mb-1">
                  {lang === 'am' ? 'ምድብ' : 'Category'}
                </label>
                <select
                  value={formData.category}
                  onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl bg-white font-medium"
                >
                  <option value="wellness">Wellness & Lifestyle</option>
                  <option value="mental_health">Mental Health & Stress</option>
                  <option value="srh">SRH & Peer Education</option>
                  <option value="leadership">Youth Leadership & Advocacy</option>
                </select>
              </div>

              <div>
                <label className="block font-bold text-slate-700 mb-1">
                  {lang === 'am' ? 'መግለጫ' : 'Description'}
                </label>
                <textarea
                  rows={3}
                  required
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl text-xs"
                  placeholder="Purpose, activities, and goals..."
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">
                    {lang === 'am' ? 'የመሰብሰቢያ ቦታ' : 'Meeting Venue'}
                  </label>
                  <input
                    type="text"
                    value={formData.venue}
                    onChange={(e) => setFormData({ ...formData, venue: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl"
                    placeholder="e.g. School Hall / Library"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">
                    {lang === 'am' ? 'የመሰብሰቢያ ሰዓት' : 'Meeting Schedule'}
                  </label>
                  <input
                    type="text"
                    value={formData.meetingTime}
                    onChange={(e) => setFormData({ ...formData, meetingTime: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl"
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
                  className="w-4 h-4 text-brand-600 rounded border-slate-300"
                />
                <label htmlFor="clubApproved" className="text-xs font-bold text-slate-700">
                  {lang === 'am' ? 'ይህ ክለብ በይፋ እንዲታይ የተፈቀደ ነው (Approved)' : 'Club is officially approved and active'}
                </label>
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
                  className="px-5 py-2 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl shadow-md shadow-brand-600/20"
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
    </div>
  );
};
