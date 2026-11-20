import React, { useState, useMemo } from 'react';
import {
  Bell,
  Plus,
  Search,
  AlertTriangle,
  Lightbulb,
  BookOpen,
  Building2,
  Users,
  Info,
  Pin,
  Trash2,
  Flame,
  Radio,
  ExternalLink,
} from 'lucide-react';
import {
  BroadcastNotification,
  NotificationCategory,
} from '../types/index.js';
import { BroadcastNotificationModal } from '../components/notifications/BroadcastNotificationModal.js';
import { ConfirmModal } from '../components/common/ConfirmModal.js';

interface NotificationsPageProps {
  broadcasts: BroadcastNotification[];
  lang: 'en' | 'am';
  isLoading?: boolean;
  onBroadcast: (data: Partial<BroadcastNotification>) => Promise<void>;
  onDelete: (id: string) => Promise<void>;
}

export const NotificationsPage: React.FC<NotificationsPageProps> = ({
  broadcasts,
  lang,
  onBroadcast,
  onDelete,
}) => {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [search, setSearch] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('All');
  const [selectedCampus, setSelectedCampus] = useState<string>('All');
  const [deleteTargetId, setDeleteTargetId] = useState<string | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);

  // Filtered broadcast items
  const filteredBroadcasts = useMemo(() => {
    return broadcasts.filter((b) => {
      const matchSearch =
        search.trim() === '' ||
        b.titleEn.toLowerCase().includes(search.toLowerCase()) ||
        b.titleAm.includes(search) ||
        b.messageEn.toLowerCase().includes(search.toLowerCase()) ||
        b.messageAm.includes(search) ||
        (b.authorEmail && b.authorEmail.toLowerCase().includes(search.toLowerCase()));

      const matchCategory = selectedCategory === 'All' || b.type === selectedCategory;
      const matchCampus = selectedCampus === 'All' || b.targetCampus === selectedCampus || b.targetCampus === 'All';

      return matchSearch && matchCategory && matchCampus;
    });
  }, [broadcasts, search, selectedCategory, selectedCampus]);

  // Statistics
  const urgentCount = broadcasts.filter((b) => b.priority === 'urgent').length;
  const pinnedCount = broadcasts.filter((b) => b.isPinned).length;
  const healthTipsCount = broadcasts.filter((b) => b.type === 'healthTip').length;

  const getCategoryVisual = (type: NotificationCategory) => {
    switch (type) {
      case 'alert':
        return { icon: AlertTriangle, color: 'text-rose-500 bg-rose-50 dark:bg-rose-950/40 border-rose-200 dark:border-rose-800', labelEn: 'Urgent Alert', labelAm: 'አስቸኳይ' };
      case 'healthTip':
        return { icon: Lightbulb, color: 'text-emerald-500 bg-emerald-50 dark:bg-emerald-950/40 border-emerald-200 dark:border-emerald-800', labelEn: 'Health Tip', labelAm: 'የጤና ምክር' };
      case 'learning':
        return { icon: BookOpen, color: 'text-sky-500 bg-sky-50 dark:bg-sky-950/40 border-sky-200 dark:border-sky-800', labelEn: 'Learning', labelAm: 'ትምህርት' };
      case 'facility':
        return { icon: Building2, color: 'text-indigo-500 bg-indigo-50 dark:bg-indigo-950/40 border-indigo-200 dark:border-indigo-800', labelEn: 'Clinic', labelAm: 'ክሊኒክ' };
      case 'club':
        return { icon: Users, color: 'text-purple-500 bg-purple-50 dark:bg-purple-950/40 border-purple-200 dark:border-purple-800', labelEn: 'Club', labelAm: 'ክበብ' };
      case 'system':
      default:
        return { icon: Info, color: 'text-amber-500 bg-amber-50 dark:bg-amber-950/40 border-amber-200 dark:border-amber-800', labelEn: 'Bulletin', labelAm: 'መግለጫ' };
    }
  };

  const handleDeleteConfirm = async () => {
    if (!deleteTargetId) return;
    try {
      setIsDeleting(true);
      await onDelete(deleteTargetId);
      setDeleteTargetId(null);
    } finally {
      setIsDeleting(false);
    }
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-200">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <h1 className="text-2xl font-extrabold text-slate-900 dark:text-white tracking-tight">
              {lang === 'am' ? 'የካምፓስ ማሳወቂያዎች እና ብሮድካስት ማዕከል' : 'Campus Broadcasts & Notification Center'}
            </h1>
            <span className="px-2 py-0.5 rounded-full bg-indigo-500/10 text-indigo-600 dark:text-indigo-400 text-xs font-bold border border-indigo-500/20">
              Live Feed
            </span>
          </div>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            {lang === 'am'
              ? 'ለጎንደር ዩኒቨርሲቲ ተማሪዎች የጤና፣ የክሊኒክ እና የአስቸኳይ ጊዜ መረጃዎችን በቀጥታ ወደ ስልካቸው ያስተላልፉ'
              : 'Dispatch urgent health bulletins, clinic schedule changes, and learning guides directly to student mobile devices'}
          </p>
        </div>

        <button
          type="button"
          onClick={() => setIsModalOpen(true)}
          className="inline-flex items-center gap-2 px-4 py-2.5 rounded-2xl bg-indigo-600 hover:bg-indigo-700 text-white font-extrabold text-xs shadow-lg shadow-indigo-600/20 transition-all cursor-pointer"
        >
          <Plus size={16} />
          <span>{lang === 'am' ? 'አዲስ ማሳወቂያ ያስተላልፉ' : 'Send New Broadcast'}</span>
        </button>
      </div>

      {/* KPI Stats Cards */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="p-4 rounded-2xl bg-white dark:bg-slate-900 border border-slate-200/80 dark:border-slate-800 shadow-xs flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-indigo-500/10 text-indigo-600 dark:text-indigo-400 flex items-center justify-center shrink-0">
            <Radio size={20} />
          </div>
          <div>
            <div className="text-xl font-extrabold text-slate-900 dark:text-white">
              {broadcasts.length}
            </div>
            <div className="text-[11px] font-semibold text-slate-500 dark:text-slate-400">
              {lang === 'am' ? 'ጠቅላላ ማሳወቂያዎች' : 'Total Broadcasts'}
            </div>
          </div>
        </div>

        <div className="p-4 rounded-2xl bg-white dark:bg-slate-900 border border-slate-200/80 dark:border-slate-800 shadow-xs flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-rose-500/10 text-rose-600 dark:text-rose-400 flex items-center justify-center shrink-0">
            <Flame size={20} />
          </div>
          <div>
            <div className="text-xl font-extrabold text-slate-900 dark:text-white">
              {urgentCount}
            </div>
            <div className="text-[11px] font-semibold text-slate-500 dark:text-slate-400">
              {lang === 'am' ? 'አስቸኳይ ጥሪዎች' : 'Urgent Alerts'}
            </div>
          </div>
        </div>

        <div className="p-4 rounded-2xl bg-white dark:bg-slate-900 border border-slate-200/80 dark:border-slate-800 shadow-xs flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-amber-500/10 text-amber-600 dark:text-amber-400 flex items-center justify-center shrink-0">
            <Pin size={20} />
          </div>
          <div>
            <div className="text-xl font-extrabold text-slate-900 dark:text-white">
              {pinnedCount}
            </div>
            <div className="text-[11px] font-semibold text-slate-500 dark:text-slate-400">
              {lang === 'am' ? 'የተሰቀሉ ማሳወቂያዎች' : 'Pinned Notices'}
            </div>
          </div>
        </div>

        <div className="p-4 rounded-2xl bg-white dark:bg-slate-900 border border-slate-200/80 dark:border-slate-800 shadow-xs flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 flex items-center justify-center shrink-0">
            <Lightbulb size={20} />
          </div>
          <div>
            <div className="text-xl font-extrabold text-slate-900 dark:text-white">
              {healthTipsCount}
            </div>
            <div className="text-[11px] font-semibold text-slate-500 dark:text-slate-400">
              {lang === 'am' ? 'የጤና ምክሮች' : 'Health Tips'}
            </div>
          </div>
        </div>
      </div>

      {/* Filter and Search Bar */}
      <div className="p-4 rounded-2xl bg-white dark:bg-slate-900 border border-slate-200/80 dark:border-slate-800 shadow-xs space-y-3">
        <div className="flex flex-col sm:flex-row gap-3">
          <div className="relative flex-1">
            <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder={
                lang === 'am'
                  ? 'በርዕስ፣ በመልእክት ወይም በአስተዳዳሪ ኢሜይል ፈልግ...'
                  : 'Search notifications by title, message, or author email...'
              }
              className="w-full pl-10 pr-4 py-2 text-xs rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50/50 dark:bg-slate-800/50 text-slate-900 dark:text-white placeholder-slate-400 focus:outline-hidden focus:border-indigo-500"
            />
          </div>

          <div className="flex gap-2 shrink-0">
            <select
              value={selectedCategory}
              onChange={(e) => setSelectedCategory(e.target.value)}
              className="px-3 py-2 text-xs font-semibold rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-slate-900 dark:text-white focus:outline-hidden"
            >
              <option value="All">{lang === 'am' ? 'ሁሉም ዘርፎች' : 'All Categories'}</option>
              <option value="alert">{lang === 'am' ? 'አስቸኳይ' : 'Urgent Alert'}</option>
              <option value="healthTip">{lang === 'am' ? 'የጤና ምክር' : 'Health Tip'}</option>
              <option value="learning">{lang === 'am' ? 'የትምህርት መመሪያ' : 'Learning'}</option>
              <option value="facility">{lang === 'am' ? 'ክሊኒክ እና ተቋም' : 'Clinic'}</option>
              <option value="club">{lang === 'am' ? 'የተማሪዎች ክበብ' : 'Club'}</option>
              <option value="system">{lang === 'am' ? 'መግለጫ' : 'Bulletin'}</option>
            </select>

            <select
              value={selectedCampus}
              onChange={(e) => setSelectedCampus(e.target.value)}
              className="px-3 py-2 text-xs font-semibold rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-slate-900 dark:text-white focus:outline-hidden"
            >
              <option value="All">{lang === 'am' ? 'ሁሉም ካምፓሶች' : 'All Campuses'}</option>
              <option value="UoG - Maraki Campus">Maraki Campus</option>
              <option value="UoG - Atse Tewodros Campus">Atse Tewodros</option>
              <option value="UoG - Fasil Campus">Fasil Campus</option>
              <option value="UoG - Tseda Campus">Tseda Campus</option>
              <option value="UoG - GCMS Referral Hospital">GCMS Hospital</option>
            </select>
          </div>
        </div>
      </div>

      {/* Broadcast Feed / Table */}
      <div className="rounded-2xl bg-white dark:bg-slate-900 border border-slate-200/80 dark:border-slate-800 shadow-xs overflow-hidden">
        {filteredBroadcasts.length === 0 ? (
          <div className="p-12 text-center space-y-3">
            <div className="w-12 h-12 rounded-2xl bg-slate-100 dark:bg-slate-800 text-slate-400 flex items-center justify-center mx-auto">
              <Bell size={24} />
            </div>
            <h4 className="font-extrabold text-sm text-slate-900 dark:text-white">
              {lang === 'am' ? 'ምንም ማሳወቂያ አልተገኘም' : 'No Broadcast Notifications Found'}
            </h4>
            <p className="text-xs text-slate-500 dark:text-slate-400 max-w-sm mx-auto">
              {lang === 'am'
                ? 'የተማሪዎችን ስልክ በቀጥታ ለማሳወቅ "አዲስ ማሳወቂያ ያስተላልፉ" የሚለውን አዝራር ይጠቀሙ።'
                : 'Click "Send New Broadcast" to dispatch health advisories and bulletins directly to student mobile feeds.'}
            </p>
            <button
              type="button"
              onClick={() => setIsModalOpen(true)}
              className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-indigo-600 text-white text-xs font-bold hover:bg-indigo-700 transition-colors cursor-pointer"
            >
              <Plus size={14} />
              <span>{lang === 'am' ? 'የመጀመሪያ ማሳወቂያ ላክ' : 'Send First Broadcast'}</span>
            </button>
          </div>
        ) : (
          <div className="divide-y divide-slate-100 dark:divide-slate-800">
            {filteredBroadcasts.map((item) => {
              const visual = getCategoryVisual(item.type);
              const Icon = visual.icon;
              const formattedDate = new Date(item.createdAt).toLocaleDateString(
                lang === 'am' ? 'am-ET' : 'en-US',
                { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' }
              );

              return (
                <div
                  key={item.id}
                  className={`p-4 sm:p-5 hover:bg-slate-50/60 dark:hover:bg-slate-800/40 transition-colors flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 ${
                    item.isPinned ? 'bg-amber-500/[0.02]' : ''
                  }`}
                >
                  <div className="flex items-start gap-3.5 flex-1 min-w-0">
                    <div className={`p-2.5 rounded-2xl border ${visual.color} shrink-0 mt-0.5`}>
                      <Icon size={18} />
                    </div>

                    <div className="space-y-1 min-w-0 flex-1">
                      <div className="flex flex-wrap items-center gap-2">
                        <span className={`px-2 py-0.5 rounded-md text-[10px] font-extrabold uppercase tracking-wider border ${visual.color}`}>
                          {lang === 'am' ? visual.labelAm : visual.labelEn}
                        </span>

                        {item.priority === 'urgent' && (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-[10px] font-extrabold uppercase tracking-wider bg-rose-500/10 text-rose-600 dark:text-rose-400 border border-rose-500/20 animate-pulse">
                            <Flame size={11} />
                            <span>Urgent</span>
                          </span>
                        )}

                        {item.isPinned && (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-[10px] font-bold bg-amber-500/10 text-amber-600 dark:text-amber-400 border border-amber-500/20">
                            <Pin size={11} />
                            <span>Pinned</span>
                          </span>
                        )}

                        <span className="text-[11px] font-semibold text-slate-400">
                          • {item.targetCampus}
                        </span>
                        <span className="text-[11px] text-slate-400">
                          • {formattedDate}
                        </span>
                      </div>

                      <h4 className="font-extrabold text-sm text-slate-900 dark:text-white truncate">
                        {lang === 'am' ? item.titleAm : item.titleEn}
                      </h4>

                      <p className="text-xs text-slate-500 dark:text-slate-400 line-clamp-2 leading-relaxed">
                        {lang === 'am' ? item.messageAm : item.messageEn}
                      </p>

                      {item.routePayload && (
                        <div className="pt-1 flex items-center gap-1.5 text-[11px] font-bold text-indigo-600 dark:text-indigo-400">
                          <ExternalLink size={12} />
                          <span>Action: {item.actionLabelEn || item.routePayload}</span>
                        </div>
                      )}
                    </div>
                  </div>

                  {/* Actions */}
                  <div className="flex items-center gap-2 self-end sm:self-center shrink-0">
                    <button
                      type="button"
                      onClick={() => setDeleteTargetId(item.id)}
                      title="Delete notification"
                      className="p-2 rounded-xl text-slate-400 hover:text-rose-600 dark:hover:text-rose-400 hover:bg-rose-50 dark:hover:bg-rose-950/40 transition-colors cursor-pointer"
                    >
                      <Trash2 size={16} />
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Modal & Confirmation */}
      <BroadcastNotificationModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onBroadcast={onBroadcast}
        lang={lang}
      />

      <ConfirmModal
        isOpen={Boolean(deleteTargetId)}
        title={lang === 'am' ? 'ማሳወቂያውን ሰርዝ' : 'Delete Notification Broadcast'}
        message={
          lang === 'am'
            ? 'ይህን ማሳወቂያ መሰረዝ እርግጠኛ ነዎት? ከተማሪዎች ስልክ ላይ ወዲያውኑ ይነሳል።'
            : 'Are you sure you want to delete this broadcast? It will be removed from all student mobile notification centers.'
        }
        confirmLabel={lang === 'am' ? 'ሰርዝ' : 'Delete'}
        cancelLabel={lang === 'am' ? 'ይቅር' : 'Cancel'}
        lang={lang}
        isLoading={isDeleting}
        onConfirm={handleDeleteConfirm}
        onClose={() => setDeleteTargetId(null)}
      />
    </div>
  );
};
