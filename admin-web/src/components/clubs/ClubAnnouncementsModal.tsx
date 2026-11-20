import React, { useState, useEffect } from 'react';
import {
  X,
  Plus,
  Trash2,
  Pin,
  Megaphone,
  MapPin,
  Calendar,
  AlertTriangle,
  Send,
  Loader2,
  Clock,
} from 'lucide-react';
import { ClubAnnouncement, StudentClub } from '../../types/index.js';
import { api } from '../../services/api.js';
import { useToast } from '../../context/ToastContext.js';

interface ClubAnnouncementsModalProps {
  isOpen: boolean;
  club: StudentClub | null;
  onClose: () => void;
  lang: 'en' | 'am';
}

const CATEGORIES = [
  { id: 'general', labelEn: 'General', labelAm: 'አጠቃላይ', icon: Megaphone, color: 'text-emerald-500 bg-emerald-50 dark:bg-emerald-950/40 border-emerald-200 dark:border-emerald-800' },
  { id: 'venue_change', labelEn: 'Venue Change', labelAm: 'የቦታ ለውጥ', icon: MapPin, color: 'text-amber-500 bg-amber-50 dark:bg-amber-950/40 border-amber-200 dark:border-amber-800' },
  { id: 'event', labelEn: 'Special Event', labelAm: 'ልዩ ዝግጅት', icon: Calendar, color: 'text-sky-500 bg-sky-50 dark:bg-sky-950/40 border-sky-200 dark:border-sky-800' },
  { id: 'urgent', labelEn: 'Urgent Alert', labelAm: 'አስቸኳይ ማስታወቂያ', icon: AlertTriangle, color: 'text-rose-500 bg-rose-50 dark:bg-rose-950/40 border-rose-200 dark:border-rose-800' },
] as const;

export const ClubAnnouncementsModal: React.FC<ClubAnnouncementsModalProps> = ({
  isOpen,
  club,
  onClose,
  lang,
}) => {
  const { toast } = useToast();
  const [announcements, setAnnouncements] = useState<ClubAnnouncement[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [showCreateForm, setShowCreateForm] = useState(false);

  // Form State
  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');
  const [type, setType] = useState<'general' | 'venue_change' | 'event' | 'urgent'>('general');
  const [isPinned, setIsPinned] = useState(false);
  const [authorName, setAuthorName] = useState('Executive Admin');

  useEffect(() => {
    if (isOpen && club) {
      loadAnnouncements();
      setShowCreateForm(false);
      resetForm();
    }
  }, [isOpen, club]);

  const resetForm = () => {
    setTitle('');
    setContent('');
    setType('general');
    setIsPinned(false);
    setAuthorName('Executive Admin');
  };

  const loadAnnouncements = async () => {
    if (!club) return;
    setIsLoading(true);
    try {
      const res = await api.getClubAnnouncements(club.id);
      setAnnouncements(res.announcements || []);
    } catch (err: any) {
      toast.error(err.message || 'Failed to load announcements', 'Error');
    } finally {
      setIsLoading(false);
    }
  };

  const handleCreateAnnouncement = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!club) return;
    if (!title.trim() || !content.trim()) {
      toast.error('Please provide both title and announcement message.', 'Missing Fields');
      return;
    }

    setIsSubmitting(true);
    try {
      const res = await api.createClubAnnouncement(club.id, {
        title: title.trim(),
        content: content.trim(),
        type,
        isPinned,
        authorName: authorName.trim() || 'Club Coordinator',
      });

      setAnnouncements([res.announcement, ...announcements]);
      resetForm();
      setShowCreateForm(false);
      toast.success(`Announcement posted to ${club.name}. Members will receive notification.`, 'Broadcast Published');
    } catch (err: any) {
      toast.error(err.message || 'Could not save announcement', 'Failed to Post');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDeleteAnnouncement = async (announcementId: string) => {
    if (!club) return;
    try {
      await api.deleteClubAnnouncement(club.id, announcementId);
      setAnnouncements(announcements.filter((a) => a.id !== announcementId));
      toast.success('Announcement removed from club feed.', 'Deleted');
    } catch (err: any) {
      toast.error(err.message || 'Could not delete announcement', 'Delete Failed');
    }
  };

  if (!isOpen || !club) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="relative w-full max-w-2xl max-h-[90vh] flex flex-col bg-white dark:bg-slate-900 rounded-3xl shadow-2xl border border-slate-200/80 dark:border-slate-800 overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-5 border-b border-slate-100 dark:border-slate-800/80 bg-slate-50/50 dark:bg-slate-800/20">
          <div className="flex items-center gap-3">
            <div className="p-2.5 rounded-2xl bg-indigo-500/10 text-indigo-600 dark:text-indigo-400 border border-indigo-500/20">
              <Megaphone size={22} />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h2 className="text-lg font-bold text-slate-900 dark:text-white">
                  {club.name}
                </h2>
                <span className="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 dark:text-indigo-400 border border-indigo-200/60 dark:border-indigo-800/60">
                  {announcements.length} {announcements.length === 1 ? 'Notice' : 'Notices'}
                </span>
              </div>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {lang === 'am' ? 'የክበብ ማስታወቂያዎችን እና የአባላት ዝማኔዎችን ያስተዳድሩ' : 'Manage club announcements & real-time member broadcasts'}
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors"
          >
            <X size={20} />
          </button>
        </div>

        {/* Content Body */}
        <div className="flex-1 overflow-y-auto p-6 space-y-6">
          {/* Action Bar */}
          <div className="flex items-center justify-between">
            <h3 className="text-sm font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              {showCreateForm ? (lang === 'am' ? 'አዲስ ማስታወቂያ ይጻፉ' : 'Compose Broadcast') : (lang === 'am' ? 'የክበብ ማስታወቂያዎች' : 'Club Broadcast Feed')}
            </h3>
            <button
              onClick={() => setShowCreateForm(!showCreateForm)}
              className={`inline-flex items-center gap-2 px-3.5 py-2 rounded-xl text-xs font-bold transition-all shadow-sm ${
                showCreateForm
                  ? 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300'
                  : 'bg-gradient-to-r from-sky-500 to-indigo-600 text-white shadow-sky-500/20 hover:opacity-95'
              }`}
            >
              {showCreateForm ? (
                <>
                  <X size={15} />
                  <span>{lang === 'am' ? 'ሰርዝ' : 'Cancel Form'}</span>
                </>
              ) : (
                <>
                  <Plus size={15} />
                  <span>{lang === 'am' ? 'አዲስ ማስታወቂያ' : 'Post Announcement'}</span>
                </>
              )}
            </button>
          </div>

          {/* Create Announcement Form */}
          {showCreateForm && (
            <form onSubmit={handleCreateAnnouncement} className="p-5 rounded-2xl bg-slate-50 dark:bg-slate-800/40 border border-slate-200/80 dark:border-slate-800 space-y-4 animate-in slide-in-from-top-4 duration-200">
              <div>
                <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1.5">
                  {lang === 'am' ? 'የማስታወቂያው ርዕስ' : 'Announcement Title'}
                </label>
                <input
                  type="text"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  placeholder="e.g. Tomorrow's Session Venue Moved to Hall 4"
                  className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-sm font-medium text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-sky-500"
                  required
                />
              </div>

              {/* Category Pills */}
              <div>
                <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1.5">
                  {lang === 'am' ? 'የማስታወቂያ ምድብ' : 'Category / Type'}
                </label>
                <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
                  {CATEGORIES.map((cat) => {
                    const Icon = cat.icon;
                    const isSelected = type === cat.id;
                    return (
                      <button
                        key={cat.id}
                        type="button"
                        onClick={() => setType(cat.id as any)}
                        className={`flex items-center gap-2 p-2.5 rounded-xl border text-xs font-semibold transition-all ${
                          isSelected
                            ? `${cat.color} ring-2 ring-sky-500/40 shadow-sm font-bold`
                            : 'border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-400 hover:bg-slate-50'
                        }`}
                      >
                        <Icon size={14} />
                        <span>{lang === 'am' ? cat.labelAm : cat.labelEn}</span>
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Message Body */}
              <div>
                <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1.5">
                  {lang === 'am' ? 'የማስታወቂያው ዝርዝር መልዕክት' : 'Announcement Message'}
                </label>
                <textarea
                  value={content}
                  onChange={(e) => setContent(e.target.value)}
                  rows={3}
                  placeholder="Write clear instructions, meeting agenda, or details for club members..."
                  className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-sm font-medium text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-sky-500"
                  required
                />
              </div>

              {/* Options Row */}
              <div className="flex flex-wrap items-center justify-between gap-4 pt-2 border-t border-slate-200/60 dark:border-slate-700/60">
                <label className="inline-flex items-center gap-2 cursor-pointer select-none">
                  <input
                    type="checkbox"
                    checked={isPinned}
                    onChange={(e) => setIsPinned(e.target.checked)}
                    className="w-4 h-4 rounded text-sky-600 focus:ring-sky-500 border-slate-300 dark:border-slate-600"
                  />
                  <span className="text-xs font-semibold text-slate-700 dark:text-slate-300 inline-flex items-center gap-1">
                    <Pin size={13} className="text-amber-500" />
                    {lang === 'am' ? 'ከላይ ይለጠፍ (Pin to top)' : 'Pin to top of club page'}
                  </span>
                </label>

                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs font-bold bg-gradient-to-r from-sky-500 to-indigo-600 text-white hover:opacity-95 disabled:opacity-50 transition-all shadow-md shadow-sky-500/20"
                >
                  {isSubmitting ? (
                    <>
                      <Loader2 size={14} className="animate-spin" />
                      <span>{lang === 'am' ? 'እየተለጠፈ ነው...' : 'Publishing...'}</span>
                    </>
                  ) : (
                    <>
                      <Send size={14} />
                      <span>{lang === 'am' ? 'ማስታወቂያውን ልጥፍ' : 'Publish Broadcast'}</span>
                    </>
                  )}
                </button>
              </div>
            </form>
          )}

          {/* Feed List */}
          {isLoading ? (
            <div className="py-12 flex flex-col items-center justify-center text-slate-400 gap-2">
              <Loader2 className="animate-spin text-sky-500" size={28} />
              <p className="text-xs font-medium">{lang === 'am' ? 'ማስታወቂያዎችን በመጫን ላይ...' : 'Loading announcements...'}</p>
            </div>
          ) : announcements.length === 0 ? (
            <div className="py-12 text-center rounded-2xl border-2 border-dashed border-slate-200 dark:border-slate-800 bg-slate-50/50 dark:bg-slate-900/40 p-6">
              <Megaphone className="mx-auto text-slate-400 dark:text-slate-600 mb-2" size={32} />
              <p className="text-sm font-bold text-slate-700 dark:text-slate-300">
                {lang === 'am' ? 'ምንም ማስታወቂያ የለም' : 'No Announcements Yet'}
              </p>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1 max-w-sm mx-auto">
                {lang === 'am'
                  ? 'ለክበቡ አባላት አዲስ ዝማኔ፣ የስብሰባ ቦታ ለውጥ ወይም ዝግጅት ለመለጠፍ ከላይ ያለውን አዝራር ይጫኑ።'
                  : 'Post the first broadcast notice to keep club members informed about meetings, venues, and events.'}
              </p>
            </div>
          ) : (
            <div className="space-y-3">
              {announcements.map((ann) => {
                const cat = CATEGORIES.find((c) => c.id === ann.type) || CATEGORIES[0];
                const Icon = cat.icon;
                return (
                  <div
                    key={ann.id}
                    className={`relative p-4 rounded-2xl border transition-all ${
                      ann.isPinned
                        ? 'bg-amber-500/5 dark:bg-amber-500/10 border-amber-300/60 dark:border-amber-700/60 shadow-sm'
                        : 'bg-white dark:bg-slate-900 border-slate-200/80 dark:border-slate-800'
                    }`}
                  >
                    <div className="flex items-start justify-between gap-3">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 flex-wrap mb-1.5">
                          {ann.isPinned && (
                            <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-[10px] font-bold bg-amber-500/20 text-amber-600 dark:text-amber-400 border border-amber-500/30">
                              <Pin size={10} />
                              <span>{lang === 'am' ? 'የተሰካ' : 'PINNED'}</span>
                            </span>
                          )}
                          <span className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-[10px] font-bold border ${cat.color}`}>
                            <Icon size={10} />
                            <span>{lang === 'am' ? cat.labelAm : cat.labelEn}</span>
                          </span>
                          <span className="text-[11px] text-slate-400 flex items-center gap-1">
                            <Clock size={11} />
                            {new Date(ann.createdAt).toLocaleDateString(undefined, {
                              month: 'short',
                              day: 'numeric',
                              hour: '2-digit',
                              minute: '2-digit',
                            })}
                          </span>
                        </div>
                        <h4 className="text-sm font-bold text-slate-900 dark:text-white leading-snug">
                          {ann.title}
                        </h4>
                        <p className="text-xs text-slate-600 dark:text-slate-300 mt-1 whitespace-pre-wrap leading-relaxed">
                          {ann.content}
                        </p>
                        <div className="mt-2 text-[10px] text-slate-400 font-medium">
                          {lang === 'am' ? 'ደራሲ:' : 'Author:'} {ann.authorName || 'Club Coordinator'}
                        </div>
                      </div>

                      <button
                        onClick={() => handleDeleteAnnouncement(ann.id)}
                        className="p-1.5 text-slate-400 hover:text-rose-500 dark:hover:text-rose-400 rounded-lg hover:bg-rose-50 dark:hover:bg-rose-950/40 transition-colors"
                        title={lang === 'am' ? 'ማስታወቂያውን ሰርዝ' : 'Delete announcement'}
                      >
                        <Trash2 size={15} />
                      </button>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
