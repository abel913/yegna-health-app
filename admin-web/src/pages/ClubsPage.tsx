import React, { useState, useMemo, useEffect } from 'react';
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
  Search,
  X,
  Phone,
  ShieldCheck,
  UserMinus,
  Mail,
  FileSpreadsheet,
  Megaphone,
} from 'lucide-react';
import { StudentClub } from '../types/index.js';
import { api } from '../services/api.js';
import { exportToCsv } from '../utils/csvExport.js';
import { useToast } from '../context/ToastContext.js';
import { EmptyState } from '../components/common/EmptyState.js';
import { ConfirmModal } from '../components/common/ConfirmModal.js';
import { ClubAnnouncementsModal } from '../components/clubs/ClubAnnouncementsModal.js';

interface ClubsPageProps {
  clubs: StudentClub[];
  lang: 'en' | 'am';
  isLoading?: boolean;
  onSaveClub: (data: Partial<StudentClub>, id?: string) => Promise<void>;
  onDeleteClub: (id: string) => Promise<void>;
  onToggleApproval: (club: StudentClub) => Promise<void>;
}

export const ClubsPage: React.FC<ClubsPageProps> = ({
  clubs,
  lang,
  isLoading = false,
  onSaveClub,
  onDeleteClub,
  onToggleApproval,
}) => {
  const { toast } = useToast();
  const [search, setSearch] = useState('');
  const [approvalFilter, setApprovalFilter] = useState<'all' | 'approved' | 'pending'>('all');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingClub, setEditingClub] = useState<StudentClub | null>(null);
  const [clubToDelete, setClubToDelete] = useState<StudentClub | null>(null);
  const [rosterModal, setRosterModal] = useState<{ open: boolean; clubId: string; clubName: string; members: any[] }>({
    open: false,
    clubId: '',
    clubName: '',
    members: [],
  });
  const [announcementsModal, setAnnouncementsModal] = useState<{ open: boolean; club: StudentClub | null }>({
    open: false,
    club: null,
  });

  const openAnnouncements = (club: StudentClub) => {
    setAnnouncementsModal({ open: true, club });
  };

  // Handle Escape key to dismiss modals
  useEffect(() => {
    if (isModalOpen || rosterModal.open) {
      const handleKeyDown = (e: KeyboardEvent) => {
        if (e.key === 'Escape') {
          if (rosterModal.open) setRosterModal((prev) => ({ ...prev, open: false }));
          if (isModalOpen) setIsModalOpen(false);
        }
      };
      window.addEventListener('keydown', handleKeyDown);
      return () => window.removeEventListener('keydown', handleKeyDown);
    }
  }, [isModalOpen, rosterModal.open]);
  const [rosterSearch, setRosterSearch] = useState('');
  const [memberToRemove, setMemberToRemove] = useState<{ userId: string; displayName: string } | null>(null);

  const defaultGuidelines = [
    'Maintain 100% confidentiality and respect peer privacy.',
    'Create an inclusive, judgment-free safe space.',
    'Active participation and support for all members.',
  ];

  const parseRules = (rules?: string[] | string): string[] => {
    if (!rules) return defaultGuidelines;
    if (Array.isArray(rules)) return rules;
    try {
      const parsed = JSON.parse(rules);
      if (Array.isArray(parsed)) return parsed;
    } catch {}
    return [rules];
  };

  const [formData, setFormData] = useState({
    name: '',
    description: '',
    category: 'wellness',
    venue: '',
    meetingTime: '',
    mentorName: '',
    mentorContact: '',
    rules: defaultGuidelines,
    isApproved: true,
  });

  // Filter computation
  const filteredClubs = useMemo(() => {
    return clubs.filter((c) => {
      const q = search.trim().toLowerCase();
      const matchesSearch =
        !q ||
        c.name.toLowerCase().includes(q) ||
        c.category.toLowerCase().includes(q) ||
        (c.venue && c.venue.toLowerCase().includes(q)) ||
        (c.meetingTime && c.meetingTime.toLowerCase().includes(q)) ||
        (c.description && c.description.toLowerCase().includes(q));

      const matchesApproval =
        approvalFilter === 'all' ||
        (approvalFilter === 'approved' && c.isApproved) ||
        (approvalFilter === 'pending' && !c.isApproved);

      return matchesSearch && matchesApproval;
    });
  }, [clubs, search, approvalFilter]);

  const totalCount = clubs.length;
  const approvedCount = useMemo(() => clubs.filter((c) => c.isApproved).length, [clubs]);
  const pendingCount = useMemo(() => clubs.filter((c) => !c.isApproved).length, [clubs]);

  const openCreateModal = () => {
    setEditingClub(null);
    setFormData({
      name: '',
      description: '',
      category: 'wellness',
      venue: '',
      meetingTime: '',
      mentorName: '',
      mentorContact: '',
      rules: defaultGuidelines,
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
      mentorName: c.mentorName || '',
      mentorContact: c.mentorContact || '',
      rules: parseRules(c.rules),
      isApproved: c.isApproved,
    });
    setIsModalOpen(true);
  };

  const openRoster = async (club: StudentClub) => {
    try {
      setRosterSearch('');
      const data = await api.getClubRoster(club.id);
      setRosterModal({
        open: true,
        clubId: club.id,
        clubName: data.clubName || club.name,
        members: data.roster || [],
      });
    } catch (err: any) {
      toast.error('Failed to load roster: ' + err.message, 'Roster Error');
    }
  };

  const handleRemoveMember = async (userId: string, displayName: string) => {
    if (!rosterModal.clubId) return;
    try {
      await api.removeClubMember(rosterModal.clubId, userId);
      setRosterModal((prev) => ({
        ...prev,
        members: prev.members.filter((m: any) => (m.userId || m.user?.id) !== userId),
      }));
      setMemberToRemove(null);
      toast.success(
        lang === 'am' ? `${displayName} ከክለቡ ተሰርዟል` : `Removed ${displayName} from club roster`,
        lang === 'am' ? 'ተወግዷል' : 'Member Removed'
      );
    } catch (err: any) {
      toast.error('Failed to remove member: ' + err.message, 'Action Failed');
    }
  };

  const handleExportClubRoster = () => {
    if (!rosterModal.members.length) return;
    exportToCsv(
      `${rosterModal.clubName.replace(/\s+/g, '_')}_Members`,
      [
        { header: 'Student Name', accessor: (m: any) => m.displayName || m.user?.displayName || 'Student' },
        { header: 'Email Address', accessor: (m: any) => m.email || m.user?.email || 'N/A' },
        { header: 'Role', accessor: (m: any) => m.role || 'MEMBER' },
        {
          header: 'Joined Date',
          accessor: (m: any) =>
            m.joinedAt
              ? `${new Date(m.joinedAt).toLocaleDateString()} ${new Date(m.joinedAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}`
              : 'N/A',
        },
      ],
      rosterModal.members
    );
    toast.success(
      lang === 'am' ? 'የአባላት ዝርዝር በተሳካ ሁኔታ ወርዷል' : 'Club member roster exported to CSV successfully',
      lang === 'am' ? 'ሪፖርት ተዘጋጅቷል' : 'Export Ready'
    );
  };

  const filteredRosterMembers = useMemo(() => {
    if (!rosterSearch.trim()) return rosterModal.members;
    const q = rosterSearch.trim().toLowerCase();
    return rosterModal.members.filter((m: any) => {
      const name = (m.displayName || m.user?.displayName || '').toLowerCase();
      const email = (m.email || m.user?.email || '').toLowerCase();
      return name.includes(q) || email.includes(q);
    });
  }, [rosterModal.members, rosterSearch]);

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
      filteredClubs
    );
    toast.success(
      lang === 'am' ? 'የክለቦች ሪፖርት ወደ CSV በተሳካ ሁኔታ ወርዷል' : 'Student clubs roster exported successfully',
      lang === 'am' ? 'ሪፖርት ተዘጋጅቷል' : 'Export Ready'
    );
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            <GraduationCap className="text-slate-900 dark:text-white" size={24} />
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
            className="flex items-center gap-2 px-4 py-2.5 bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 text-xs md:text-sm font-bold rounded-xl border border-slate-900 dark:border-white shadow-xs transition-all active:scale-[0.99] cursor-pointer"
          >
            <Plus size={16} />
            <span>{lang === 'am' ? '+ አዲስ ክለብ ፍጠር' : '+ Create Student Club'}</span>
          </button>
        </div>
      </div>

      {/* Search & Filter Bar */}
      {clubs.length > 0 && (
        <div className="bg-white dark:bg-slate-900 p-4 md:p-5 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs space-y-4">
          <div className="flex flex-col md:flex-row gap-3">
            <div className="relative flex-1">
              <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
              <input
                type="text"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                placeholder={
                  lang === 'am'
                    ? 'በክለብ ስም፣ በምድብ፣ በመሰብሰቢያ ቦታ ወይም በመርሃ-ግብር ፈልግ...'
                    : 'Search clubs by name, category, venue, schedule, or description...'
                }
                className="w-full pl-9 pr-9 py-2 text-xs md:text-sm bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white rounded-xl focus:bg-white dark:focus:bg-slate-850 focus:border-slate-900 dark:focus:border-white focus:outline-none transition-all placeholder:text-slate-400"
              />
              {search && (
                <button
                  onClick={() => setSearch('')}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 cursor-pointer"
                  aria-label="Clear search"
                >
                  <X size={15} />
                </button>
              )}
            </div>
          </div>

          {/* Approval Filter Pills */}
          <div className="flex flex-wrap items-center gap-2 pt-1 border-t border-slate-100 dark:border-slate-800">
            <span className="text-xs font-bold text-slate-400 dark:text-slate-500 mr-1">
              {lang === 'am' ? 'ሁኔታ:' : 'Approval:'}
            </span>
            <button
              onClick={() => setApprovalFilter('all')}
              className={`px-3 py-1 rounded-xl text-xs font-bold transition-all cursor-pointer ${
                approvalFilter === 'all'
                  ? 'bg-slate-950 dark:bg-white text-white dark:text-slate-950 shadow-xs'
                  : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-200/80 dark:hover:bg-slate-700'
              }`}
            >
              {lang === 'am' ? 'ሁሉም ክለቦች' : 'All Chapters'} ({totalCount})
            </button>
            <button
              onClick={() => setApprovalFilter('approved')}
              className={`px-3 py-1 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 cursor-pointer ${
                approvalFilter === 'approved'
                  ? 'bg-emerald-600 text-white shadow-xs'
                  : 'bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 hover:bg-emerald-100 dark:hover:bg-emerald-900/60 border border-emerald-200/60 dark:border-emerald-800'
              }`}
            >
              <CheckCircle2 size={13} />
              <span>{lang === 'am' ? 'የተፈቀዱ' : 'Approved'}</span> ({approvedCount})
            </button>
            <button
              onClick={() => setApprovalFilter('pending')}
              className={`px-3 py-1 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 cursor-pointer ${
                approvalFilter === 'pending'
                  ? 'bg-amber-600 text-white shadow-xs'
                  : 'bg-amber-50 dark:bg-amber-950/40 text-amber-700 dark:text-amber-300 hover:bg-amber-100 dark:hover:bg-amber-900/60 border border-amber-200/60 dark:border-amber-800'
              }`}
            >
              <Clock size={13} />
              <span>{lang === 'am' ? 'በመጠባበቅ ላይ' : 'Pending Approval'}</span> ({pendingCount})
            </button>
          </div>
        </div>
      )}

      {/* Clubs Grid, Skeleton, or Empty State */}
      {isLoading && clubs.length === 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {Array.from({ length: 6 }).map((_, idx) => (
            <div
              key={idx}
              className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-5 shadow-xs animate-pulse space-y-4"
            >
              <div className="flex items-center justify-between">
                <div className="h-5 bg-slate-200 dark:bg-slate-800 rounded w-20" />
                <div className="h-5 bg-slate-100 dark:bg-slate-800/60 rounded w-16" />
              </div>
              <div className="h-5 bg-slate-200 dark:bg-slate-800 rounded w-2/3" />
              <div className="h-10 bg-slate-100 dark:bg-slate-800/60 rounded w-full" />
              <div className="h-8 bg-slate-100 dark:bg-slate-800/60 rounded-xl" />
            </div>
          ))}
        </div>
      ) : clubs.length === 0 ? (
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
      ) : filteredClubs.length === 0 ? (
        <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-12 text-center shadow-xs">
          <div className="w-12 h-12 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-400 flex items-center justify-center mx-auto mb-3">
            <Search size={22} />
          </div>
          <h4 className="text-base font-extrabold text-slate-900 dark:text-white mb-1">
            {lang === 'am' ? 'ምንም ክለብ አልተገኘም' : 'No Chapters Match Your Filters'}
          </h4>
          <p className="text-xs text-slate-500 dark:text-slate-400 max-w-sm mx-auto mb-4">
            {lang === 'am'
              ? 'የተጠቀምከውን የፍለጋ ቃል ወይም ማጣሪያ ቀይረህ እንደገና ሞክር።'
              : 'Try adjusting your search query or switching to "All Chapters" to see full results.'}
          </p>
          <button
            onClick={() => {
              setSearch('');
              setApprovalFilter('all');
            }}
            className="px-4 py-2 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs font-bold rounded-xl transition-all cursor-pointer"
          >
            {lang === 'am' ? 'ማጣሪያዎችን አጽዳ' : 'Reset Filters'}
          </button>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {filteredClubs.map((c) => (
            <div
              key={c.id}
              className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-5 shadow-xs hover:shadow-md transition-all flex flex-col justify-between"
            >
              <div>
                <div className="flex items-center justify-between gap-2 mb-2.5">
                  <span className="text-[10px] font-extrabold uppercase px-2.5 py-0.5 rounded-md bg-slate-100 dark:bg-slate-800 text-slate-800 dark:text-slate-200 border border-slate-200 dark:border-slate-700">
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

                    {/* Announcements Button */}
                    <button
                      onClick={() => openAnnouncements(c)}
                      className="p-1.5 text-indigo-500 hover:text-indigo-700 dark:hover:text-indigo-300 hover:bg-indigo-50 dark:hover:bg-indigo-950/40 rounded-lg transition-colors cursor-pointer"
                      title={lang === 'am' ? 'የክበብ ማስታወቂያዎች' : 'Club announcements'}
                    >
                      <Megaphone size={14} />
                    </button>

                    {/* Edit Button */}
                    <button
                      onClick={() => openEditModal(c)}
                      className="p-1.5 text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition-colors cursor-pointer"
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
                  {c.mentorContact && (
                    <div className="flex items-center gap-1.5 text-slate-700 dark:text-slate-300 font-semibold">
                      <Phone size={13} />
                      <span className="truncate">{c.mentorName ? `${c.mentorName}: ` : ''}{c.mentorContact}</span>
                    </div>
                  )}
                  {c.rules && (
                    <div className="flex items-center gap-1.5 text-slate-500 dark:text-slate-400">
                      <ShieldCheck size={13} className="text-emerald-500" />
                      <span>{parseRules(c.rules).length} {lang === 'am' ? 'መመሪያዎች' : 'Guidelines'}</span>
                    </div>
                  )}
                </div>
              </div>

              <div className="pt-4 mt-4 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between text-xs">
                <span className="flex items-center gap-1 font-bold text-slate-700 dark:text-slate-300">
                  <Users size={14} className="text-slate-900 dark:text-white" />
                  {c.memberCount || 0} {lang === 'am' ? 'አባላት' : 'members'}
                </span>
                <div className="flex items-center gap-2.5">
                  <button
                    onClick={() => openAnnouncements(c)}
                    className="flex items-center gap-1 font-bold text-indigo-600 dark:text-indigo-400 hover:underline cursor-pointer"
                  >
                    <Megaphone size={13} />
                    {lang === 'am' ? 'ማስታወቂያዎች' : 'Notices'}
                    {c.announcements && c.announcements.length > 0 && (
                      <span className="px-1.5 py-0.2 rounded-full text-[10px] font-extrabold bg-indigo-100 dark:bg-indigo-950 text-indigo-700 dark:text-indigo-300">
                        {c.announcements.length}
                      </span>
                    )}
                  </button>
                  <span className="text-slate-300 dark:text-slate-700">•</span>
                  <button
                    onClick={() => openRoster(c)}
                    className="flex items-center gap-1 font-bold text-slate-900 dark:text-white hover:underline cursor-pointer"
                  >
                    <Eye size={13} />
                    {lang === 'am' ? 'አባላትን እይ' : 'View Roster'}
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Upgraded Member Roster Modal */}
      {rosterModal.open && (
        <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-3 md:p-4">
          <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-2xl w-full max-h-[85vh] flex flex-col overflow-hidden animate-in fade-in zoom-in-95">
            {/* Modal Header */}
            <div className="flex-shrink-0 flex items-center justify-between px-6 py-4 border-b border-slate-100 dark:border-slate-800 bg-white/95 dark:bg-slate-900/95 backdrop-blur-xs">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-2xl bg-slate-100 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 flex items-center justify-center text-slate-900 dark:text-white">
                  <Users size={20} />
                </div>
                <div>
                  <div className="flex items-center gap-2">
                    <h3 className="text-base md:text-lg font-extrabold text-slate-900 dark:text-white">
                      {lang === 'am' ? 'የክለቡ አባላት መዝገብ' : 'Student Member Roster'}
                    </h3>
                    <span className="px-2 py-0.5 rounded-full text-[11px] font-bold bg-slate-100 dark:bg-slate-800 text-slate-800 dark:text-slate-200">
                      {rosterModal.members.length} {lang === 'am' ? 'አባላት' : 'members'}
                    </span>
                  </div>
                  <p className="text-xs text-slate-500 dark:text-slate-400 truncate max-w-sm font-medium">
                    {rosterModal.clubName}
                  </p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                {rosterModal.members.length > 0 && (
                  <button
                    onClick={handleExportClubRoster}
                    className="flex items-center gap-1.5 px-3 py-1.5 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs font-bold rounded-xl border border-slate-200 dark:border-slate-700 transition-colors cursor-pointer"
                    title={lang === 'am' ? 'የአባላት ዝርዝር (CSV)' : 'Export roster to CSV'}
                  >
                    <FileSpreadsheet size={14} className="text-emerald-500" />
                    <span className="hidden sm:inline">{lang === 'am' ? 'አውርድ (CSV)' : 'Export CSV'}</span>
                  </button>
                )}
                <button
                  onClick={() => setRosterModal({ open: false, clubId: '', clubName: '', members: [] })}
                  className="p-1.5 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 cursor-pointer rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800"
                >
                  <X size={20} />
                </button>
              </div>
            </div>

            {/* Search filter if there are members */}
            {rosterModal.members.length > 0 && (
              <div className="flex-shrink-0 px-6 py-2.5 border-b border-slate-100 dark:border-slate-800 bg-slate-50/70 dark:bg-slate-850/50">
                <div className="relative">
                  <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
                  <input
                    type="text"
                    value={rosterSearch}
                    onChange={(e) => setRosterSearch(e.target.value)}
                    placeholder={
                      lang === 'am'
                        ? 'በተማሪው ስም ወይም ኢሜይል ፈልግ...'
                        : 'Search members by student name or email...'
                    }
                    className="w-full pl-8 pr-8 py-1.5 text-xs bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white rounded-xl focus:outline-none focus:border-slate-900 dark:focus:border-white transition-all placeholder:text-slate-400"
                  />
                  {rosterSearch && (
                    <button
                      onClick={() => setRosterSearch('')}
                      className="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 cursor-pointer"
                    >
                      <X size={13} />
                    </button>
                  )}
                </div>
              </div>
            )}

            {/* Member List */}
            <div className="flex-1 overflow-y-auto px-6 py-4 space-y-2.5">
              {filteredRosterMembers.map((m: any, idx: number) => {
                const displayName = m.displayName || m.user?.displayName || 'Registered Student';
                const email = m.email || m.user?.email || 'No email registered';
                const userId = m.userId || m.user?.id;
                const initials = displayName
                  .split(' ')
                  .filter(Boolean)
                  .slice(0, 2)
                  .map((p: string) => p[0]?.toUpperCase())
                  .join('') || 'ST';

                const joinedDate = m.joinedAt
                  ? new Date(m.joinedAt).toLocaleDateString(undefined, {
                      month: 'short',
                      day: 'numeric',
                      year: 'numeric',
                    })
                  : 'Recent';
                const joinedTime = m.joinedAt
                  ? new Date(m.joinedAt).toLocaleTimeString([], {
                      hour: '2-digit',
                      minute: '2-digit',
                    })
                  : '';

                return (
                  <div
                    key={userId || idx}
                    className="p-3.5 rounded-2xl bg-slate-50/80 dark:bg-slate-800/50 border border-slate-200/80 dark:border-slate-700/60 hover:border-slate-400 dark:hover:border-slate-600 transition-all flex items-center justify-between gap-3 group"
                  >
                    <div className="flex items-center gap-3 min-w-0">
                      <div className="w-10 h-10 rounded-full bg-slate-900 dark:bg-white text-white dark:text-slate-900 font-black text-xs flex items-center justify-center shadow-xs flex-shrink-0">
                        {initials}
                      </div>
                      <div className="min-w-0">
                        <div className="flex items-center gap-2">
                          <h4 className="font-extrabold text-xs md:text-sm text-slate-900 dark:text-white truncate">
                            {displayName}
                          </h4>
                          <span className="px-1.5 py-0.5 rounded-md text-[10px] font-bold bg-emerald-100 dark:bg-emerald-950/60 text-emerald-700 dark:text-emerald-300 flex-shrink-0">
                            {m.role || 'MEMBER'}
                          </span>
                        </div>
                        <div className="flex items-center gap-3 mt-0.5 text-[11px] text-slate-500 dark:text-slate-400">
                          <span className="flex items-center gap-1 truncate font-mono text-[10.5px]">
                            <Mail size={12} className="text-slate-400 flex-shrink-0" />
                            {email}
                          </span>
                          <span className="flex items-center gap-1 text-[10px] text-slate-400 dark:text-slate-500 flex-shrink-0">
                            <Clock size={11} className="text-slate-400" />
                            {joinedDate} {joinedTime && `• ${joinedTime}`}
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* Remove Member button */}
                    {userId && (
                      <button
                        onClick={() => setMemberToRemove({ userId, displayName })}
                        className="p-2 text-slate-400 hover:text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-xl transition-colors cursor-pointer flex-shrink-0"
                        title={lang === 'am' ? `${displayName}ን ከክለቡ አስወግድ` : `Remove ${displayName} from club`}
                        aria-label="Remove member"
                      >
                        <UserMinus size={15} />
                      </button>
                    )}
                  </div>
                );
              })}

              {rosterModal.members.length === 0 && (
                <div className="py-12 px-4 text-center">
                  <div className="w-12 h-12 mx-auto mb-3 rounded-2xl bg-slate-100 dark:bg-slate-800 text-slate-400 flex items-center justify-center">
                    <Users size={24} />
                  </div>
                  <h4 className="text-sm font-bold text-slate-800 dark:text-slate-200">
                    {lang === 'am' ? 'እስካሁን ምንም ተማሪ አልተቀላቀለም' : 'No Students Joined Yet'}
                  </h4>
                  <p className="text-xs text-slate-400 dark:text-slate-500 max-w-sm mx-auto mt-1">
                    {lang === 'am'
                      ? 'ተማሪዎች ከመተግበሪያው ሲቀላቀሉ የተረጋገጠ ስማቸው፣ ኢሜይላቸውና የተቀላቀሉበት ቀን እዚህ ይዘረዘራል።'
                      : 'When authenticated students tap "Join Club" in the mobile app, their verified names, emails, and join timestamps will appear here in real-time.'}
                  </p>
                </div>
              )}

              {rosterModal.members.length > 0 && filteredRosterMembers.length === 0 && (
                <div className="py-8 text-center text-xs text-slate-400 dark:text-slate-500">
                  <p className="font-semibold">{lang === 'am' ? 'ምንም የሚመሳሰል አባል አልተገኘም' : 'No members found matching your search.'}</p>
                  <button
                    onClick={() => setRosterSearch('')}
                    className="mt-2 text-slate-900 dark:text-white font-bold hover:underline cursor-pointer"
                  >
                    {lang === 'am' ? 'ፍለጋውን አጽዳ' : 'Clear search'}
                  </button>
                </div>
              )}
            </div>

            {/* Modal Footer */}
            <div className="flex-shrink-0 px-6 py-3 border-t border-slate-100 dark:border-slate-800 bg-slate-50 dark:bg-slate-900/60 flex items-center justify-between text-xs">
              <span className="text-slate-500 dark:text-slate-400">
                {lang === 'am'
                  ? `የሚታዩ አባላት: ${filteredRosterMembers.length} ከ ${rosterModal.members.length}`
                  : `Showing ${filteredRosterMembers.length} of ${rosterModal.members.length} member(s)`}
              </span>
              <button
                type="button"
                onClick={() => setRosterModal({ open: false, clubId: '', clubName: '', members: [] })}
                className="px-4 py-1.5 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 font-bold rounded-xl hover:bg-slate-100 dark:hover:bg-slate-800 cursor-pointer transition-colors"
              >
                {lang === 'am' ? 'ዝጋ' : 'Close'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Create / Edit Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-3 md:p-4">
          <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-lg w-full max-h-[90vh] flex flex-col overflow-hidden animate-in fade-in zoom-in-95">
            {/* Modal Header (Sticky / Pinned) */}
            <div className="flex-shrink-0 flex items-center justify-between px-6 py-4 border-b border-slate-100 dark:border-slate-800 bg-white/95 dark:bg-slate-900/95 backdrop-blur-xs z-10">
              <h3 className="text-lg font-extrabold text-slate-900 dark:text-white">
                {editingClub
                  ? (lang === 'am' ? 'የተማሪዎች ክለብን አርትዕ' : 'Edit Student Club')
                  : (lang === 'am' ? 'አዲስ የተማሪዎች ክለብ ፍጠር' : 'Register New Student Club')}
              </h3>
              <button
                type="button"
                onClick={() => setIsModalOpen(false)}
                className="p-1.5 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 cursor-pointer rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800"
              >
                <X size={20} />
              </button>
            </div>

            {/* Scrollable Form Body */}
            <form id="clubForm" onSubmit={handleSubmit} className="flex-1 overflow-y-auto px-6 py-5 space-y-4 text-xs md:text-sm">
              <div>
                <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                  {lang === 'am' ? 'የክለቡ ስም' : 'Club Name'}
                </label>
                <input
                  type="text"
                  required
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-slate-900 dark:focus:border-white focus:outline-none"
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
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white font-medium focus:border-slate-900 dark:focus:border-white focus:outline-none cursor-pointer"
                >
                  <option value="srh">SRH & Peer Education</option>
                  <option value="mental_health">Mental Health & Stress</option>
                  <option value="first_aid">First Aid & Emergency Response</option>
                  <option value="anti_substance">Anti-Substance & Tobacco Free</option>
                  <option value="girls_hygiene">Girls' Menstrual Hygiene & Dignity</option>
                  <option value="leadership">Youth Leadership & Advocacy</option>
                  <option value="wellness">Wellness & Healthy Lifestyle</option>
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
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl text-xs focus:border-slate-900 dark:focus:border-white focus:outline-none"
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
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-slate-900 dark:focus:border-white focus:outline-none"
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
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-slate-900 dark:focus:border-white focus:outline-none"
                    placeholder="e.g. Every Wed at 4:30 PM"
                  />
                </div>
              </div>

              {/* Counselor / Lead Mentor Contact */}
              <div className="grid grid-cols-2 gap-3 p-3 rounded-2xl bg-slate-50 dark:bg-slate-800/50 border border-slate-200/80 dark:border-slate-700/60">
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    {lang === 'am' ? 'የአማካሪው ስም' : 'Counselor / Mentor Name'}
                  </label>
                  <input
                    type="text"
                    value={formData.mentorName}
                    onChange={(e) => setFormData({ ...formData, mentorName: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-850 text-slate-900 dark:text-white rounded-xl focus:border-slate-900 dark:focus:border-white focus:outline-none"
                    placeholder="e.g. Sister Hanna / Dr. Almaz"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    {lang === 'am' ? 'የአማካሪው ስልክ ቁጥር *' : 'Counselor Phone Number *'}
                  </label>
                  <input
                    type="tel"
                    value={formData.mentorContact}
                    onChange={(e) => setFormData({ ...formData, mentorContact: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-850 text-slate-900 dark:text-white rounded-xl focus:border-slate-900 dark:focus:border-white focus:outline-none"
                    placeholder="+251 91 123 4567"
                  />
                  <p className="text-[10px] text-slate-400 dark:text-slate-500 mt-1">Direct phone line for youth counseling</p>
                </div>
              </div>

              {/* Community Guidelines & Safe Space Rules */}
              <div className="p-3 rounded-2xl bg-slate-50 dark:bg-slate-800/50 border border-slate-200/80 dark:border-slate-700/60">
                <div className="flex items-center justify-between mb-2">
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300">
                      {lang === 'am' ? 'የማህበረሰብ መመሪያዎች (Community Guidelines)' : 'Community Guidelines & Safe Space Rules'}
                    </label>
                    <p className="text-[10px] text-slate-400 dark:text-slate-500">Students must review these before joining</p>
                  </div>
                  <button
                    type="button"
                    onClick={() => setFormData({ ...formData, rules: [...formData.rules, ''] })}
                    className="text-xs text-slate-900 dark:text-white hover:underline font-bold cursor-pointer"
                  >
                    + Add Rule
                  </button>
                </div>
                <div className="space-y-1.5 max-h-40 overflow-y-auto pr-1">
                  {formData.rules.map((rule, idx) => (
                    <div key={idx} className="flex items-center gap-1.5">
                      <span className="text-[10px] w-4 text-center font-bold text-slate-400">{idx + 1}.</span>
                      <input
                        type="text"
                        value={rule}
                        onChange={(e) => {
                          const updated = [...formData.rules];
                          updated[idx] = e.target.value;
                          setFormData({ ...formData, rules: updated });
                        }}
                        className="flex-1 px-2.5 py-1.5 text-xs border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-850 text-slate-900 dark:text-white rounded-lg focus:border-slate-900 dark:focus:border-white focus:outline-none"
                        placeholder="Guideline / safe-space pledge..."
                      />
                      {formData.rules.length > 1 && (
                        <button
                          type="button"
                          onClick={() => {
                            const updated = formData.rules.filter((_, i) => i !== idx);
                            setFormData({ ...formData, rules: updated });
                          }}
                          className="p-1 text-rose-500 hover:text-rose-700 cursor-pointer"
                        >
                          <X size={14} />
                        </button>
                      )}
                    </div>
                  ))}
                </div>
              </div>

              <div className="pt-1 flex items-center gap-2">
                <input
                  type="checkbox"
                  id="clubApproved"
                  checked={formData.isApproved}
                  onChange={(e) => setFormData({ ...formData, isApproved: e.target.checked })}
                  className="w-4 h-4 text-slate-900 focus:ring-slate-900 dark:text-white dark:focus:ring-white rounded border-slate-300"
                />
                <label htmlFor="clubApproved" className="text-xs font-bold text-slate-700 dark:text-slate-300 cursor-pointer">
                  {lang === 'am' ? 'ይህ ክለብ በይፋ እንዲታይ የተፈቀደ ነው (Approved)' : 'Club is officially approved and active'}
                </label>
              </div>
            </form>

            {/* Modal Footer (Sticky / Pinned) */}
            <div className="flex-shrink-0 px-6 py-4 bg-white/95 dark:bg-slate-900/95 backdrop-blur-xs border-t border-slate-100 dark:border-slate-800 flex items-center justify-end gap-3 z-10">
              <button
                type="button"
                onClick={() => setIsModalOpen(false)}
                className="px-4 py-2 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 font-bold rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800 cursor-pointer transition-colors"
              >
                Cancel
              </button>
              <button
                type="submit"
                form="clubForm"
                className="px-5 py-2 bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 font-bold rounded-xl border border-slate-900 dark:border-white shadow-xs transition-all active:scale-[0.99] cursor-pointer"
              >
                {editingClub
                  ? (lang === 'am' ? 'ለውጦችን መዝግብ' : 'Save Changes')
                  : (lang === 'am' ? 'ክለብ ፍጠር' : 'Create Club')}
              </button>
            </div>
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

      {/* Remove Member Confirmation Modal */}
      <ConfirmModal
        isOpen={Boolean(memberToRemove)}
        onClose={() => setMemberToRemove(null)}
        onConfirm={async () => {
          if (memberToRemove) {
            await handleRemoveMember(memberToRemove.userId, memberToRemove.displayName);
          }
        }}
        title={lang === 'am' ? 'ተማሪው ከክለቡ ይወገድ?' : 'Remove Student from Club?'}
        itemName={memberToRemove?.displayName || ''}
        message={
          lang === 'am'
            ? 'ይህ ተማሪ ከዚህ ክለብ አባልነት ይሰረዛል። እንደገና ለመቀላቀል ከፈለገ ከስልኩ መተግበሪያ ማመልከት ይችላል።'
            : 'This will remove the student from this club roster. They can rejoin anytime through their mobile app.'
        }
        lang={lang}
      />

      {/* Club Announcements Modal */}
      <ClubAnnouncementsModal
        isOpen={announcementsModal.open}
        club={announcementsModal.club}
        onClose={() => setAnnouncementsModal({ open: false, club: null })}
        lang={lang}
      />
    </div>
  );
};
