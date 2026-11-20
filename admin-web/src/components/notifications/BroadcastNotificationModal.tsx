import React, { useState } from 'react';
import {
  Bell,
  X,
  Send,
  Sparkles,
  Smartphone,
  AlertTriangle,
  Lightbulb,
  BookOpen,
  Building2,
  Users,
  Info,
  Pin,
  ExternalLink,
  Flame,
} from 'lucide-react';
import {
  BroadcastNotification,
  NotificationCategory,
  NotificationPriority,
} from '../../types/index.js';

interface BroadcastNotificationModalProps {
  isOpen: boolean;
  onClose: () => void;
  onBroadcast: (data: Partial<BroadcastNotification>) => Promise<void>;
  lang: 'en' | 'am';
}

const TEMPLATES = [
  {
    nameEn: 'Campus Health & STI Screening Week',
    nameAm: 'የካምፓስ የጤና እና የምርመራ ሳምንት',
    titleEn: 'Free Confidential Health & STI Screening Week',
    titleAm: 'ነፃ ሚስጥራዊ የጤና እና የኤችአይቪ/የአባላዘር ምርመራ ሳምንት',
    messageEn: 'Free youth-friendly consultations, rapid testing, and reproductive guidance available at Maraki & Tewodros student clinics.',
    messageAm: 'በማራኪ እና ቴዎድሮስ የተማሪዎች ክሊኒኮች ነፃ የወጣቶች የምክር አገልግሎት፣ ምርመራ እና መመሪያዎችን ያግኙ።',
    type: 'facility' as NotificationCategory,
    priority: 'urgent' as NotificationPriority,
    targetCampus: 'All',
    routePayload: 'facility:clinic',
    actionLabelEn: 'Find Clinic',
    actionLabelAm: 'ክሊኒክ ይፈልጉ',
    isPinned: true,
  },
  {
    nameEn: 'Exam Stress & Mental Wellness Workshop',
    nameAm: 'የፈተና ጭንቀት እና የአእምሮ ጤና ስልጠና',
    titleEn: 'Managing Academic Stress & Mental Well-being',
    titleAm: 'የአካዳሚክ ጭንቀትን መቆጣጠር እና የአእምሮ ጤንነት',
    messageEn: 'Learn evidence-based breathing techniques, sleep hygiene tips, and time management strategies before final exams.',
    messageAm: 'ከፈተና በፊት ጭንቀትን ለመቀነስ የሚያግዙ ሳይንሳዊ የመተንፈሻ እና የእንቅልፍ ምክሮችን ይማሩ።',
    type: 'learning' as NotificationCategory,
    priority: 'high' as NotificationPriority,
    targetCampus: 'All',
    routePayload: 'learn:mental_health',
    actionLabelEn: 'Start Guide',
    actionLabelAm: 'መመሪያውን ይክፈቱ',
    isPinned: false,
  },
  {
    nameEn: 'Daily Youth Health Tip: Hydration & Rest',
    nameAm: 'የዕለቱ የወጣቶች ጤና ምክር፡ ውሀ እና እረፍት',
    titleEn: 'Hydration & Adequate Sleep Boost Campus Focus',
    titleAm: 'በቂ ውሀ መጠጣት እና በቂ እንቅልፍ ማግኘት ትኩረትን ይጨምራል',
    messageEn: 'Drinking at least 2 liters of clean water and aiming for 7-8 hours of sleep strengthens cognitive resilience and immunity.',
    messageAm: 'ቢያንስ 2 ሊትር ንፁህ ውሀ መጠጣት እና 7-8 ሰዓት መተኛት የአእምሮ ንቃትን እና የበሽታ መከላከያ አቅምን ያጠናክራል።',
    type: 'healthTip' as NotificationCategory,
    priority: 'normal' as NotificationPriority,
    targetCampus: 'All',
    routePayload: 'learn',
    actionLabelEn: 'Read More',
    actionLabelAm: 'ተጨማሪ ያንብቡ',
    isPinned: false,
  },
];

const CATEGORIES: { id: NotificationCategory; labelEn: string; labelAm: string; icon: any; color: string }[] = [
  { id: 'alert', labelEn: 'Urgent Alert', labelAm: 'አስቸኳይ ማስጠንቀቂያ', icon: AlertTriangle, color: 'text-rose-500 bg-rose-50 dark:bg-rose-950/40 border-rose-200 dark:border-rose-800' },
  { id: 'healthTip', labelEn: 'Health Tip', labelAm: 'የጤና ምክር', icon: Lightbulb, color: 'text-emerald-500 bg-emerald-50 dark:bg-emerald-950/40 border-emerald-200 dark:border-emerald-800' },
  { id: 'learning', labelEn: 'Learning Guide', labelAm: 'የትምህርት መመሪያ', icon: BookOpen, color: 'text-sky-500 bg-sky-50 dark:bg-sky-950/40 border-sky-200 dark:border-sky-800' },
  { id: 'facility', labelEn: 'Clinic & Facility', labelAm: 'ክሊኒክ እና ተቋም', icon: Building2, color: 'text-indigo-500 bg-indigo-50 dark:bg-indigo-950/40 border-indigo-200 dark:border-indigo-800' },
  { id: 'club', labelEn: 'Peer Club', labelAm: 'የተማሪዎች ክበብ', icon: Users, color: 'text-purple-500 bg-purple-50 dark:bg-purple-950/40 border-purple-200 dark:border-purple-800' },
  { id: 'system', labelEn: 'Campus Bulletin', labelAm: 'ይፋዊ መግለጫ', icon: Info, color: 'text-amber-500 bg-amber-50 dark:bg-amber-950/40 border-amber-200 dark:border-amber-800' },
];

const CAMPUSES = [
  { id: 'All', nameEn: 'All Campuses', nameAm: 'ሁሉም ካምፓሶች' },
  { id: 'UoG - Maraki Campus', nameEn: 'UoG - Maraki Campus', nameAm: 'ዩኦጂ ማራኪ ካምፓስ' },
  { id: 'UoG - Atse Tewodros Campus', nameEn: 'UoG - Atse Tewodros Campus', nameAm: 'ዩኦጂ አፄ ቴዎድሮስ ካምፓስ' },
  { id: 'UoG - Fasil Campus', nameEn: 'UoG - Fasil Campus', nameAm: 'ዩኦጂ ፋሲል ካምፓስ' },
  { id: 'UoG - Tseda Campus', nameEn: 'UoG - Tseda Campus', nameAm: 'ዩኦጂ ጼዳ ካምፓስ' },
  { id: 'UoG - GCMS Referral Hospital', nameEn: 'UoG - GCMS Referral Hospital', nameAm: 'ዩኦጂ ሪፈራል ሆስፒታል' },
];

export const BroadcastNotificationModal: React.FC<BroadcastNotificationModalProps> = ({
  isOpen,
  onClose,
  onBroadcast,
  lang,
}) => {
  const [titleEn, setTitleEn] = useState('');
  const [titleAm, setTitleAm] = useState('');
  const [messageEn, setMessageEn] = useState('');
  const [messageAm, setMessageAm] = useState('');
  const [type, setType] = useState<NotificationCategory>('system');
  const [priority, setPriority] = useState<NotificationPriority>('normal');
  const [targetCampus, setTargetCampus] = useState('All');
  const [routePayload, setRoutePayload] = useState('learn');
  const [actionLabelEn, setActionLabelEn] = useState('');
  const [actionLabelAm, setActionLabelAm] = useState('');
  const [isPinned, setIsPinned] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [previewTab, setPreviewTab] = useState<'card' | 'toast'>('toast');

  if (!isOpen) return null;

  const handleApplyTemplate = (tpl: typeof TEMPLATES[0]) => {
    setTitleEn(tpl.titleEn);
    setTitleAm(tpl.titleAm);
    setMessageEn(tpl.messageEn);
    setMessageAm(tpl.messageAm);
    setType(tpl.type);
    setPriority(tpl.priority);
    setTargetCampus(tpl.targetCampus);
    setRoutePayload(tpl.routePayload);
    setActionLabelEn(tpl.actionLabelEn);
    setActionLabelAm(tpl.actionLabelAm);
    setIsPinned(tpl.isPinned);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!titleEn.trim() || !titleAm.trim() || !messageEn.trim() || !messageAm.trim()) {
      return;
    }

    try {
      setIsSubmitting(true);
      await onBroadcast({
        titleEn: titleEn.trim(),
        titleAm: titleAm.trim(),
        messageEn: messageEn.trim(),
        messageAm: messageAm.trim(),
        type,
        priority,
        targetCampus,
        routePayload: routePayload || undefined,
        actionLabelEn: actionLabelEn.trim() || undefined,
        actionLabelAm: actionLabelAm.trim() || undefined,
        isPinned,
      });
      onClose();
    } finally {
      setIsSubmitting(false);
    }
  };

  const activeCategory = CATEGORIES.find((c) => c.id === type) || CATEGORIES[0];
  const CategoryIcon = activeCategory.icon;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-xs overflow-y-auto animate-in fade-in duration-200">
      <div className="relative w-full max-w-5xl bg-white dark:bg-slate-900 rounded-3xl shadow-2xl border border-slate-200 dark:border-slate-800 my-8 overflow-hidden flex flex-col max-h-[90vh]">
        {/* Modal Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-slate-100 dark:border-slate-800 bg-slate-50/50 dark:bg-slate-800/50">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-indigo-600/10 dark:bg-indigo-500/20 text-indigo-600 dark:text-indigo-400 flex items-center justify-center">
              <Bell size={20} />
            </div>
            <div>
              <h3 className="font-extrabold text-slate-900 dark:text-white text-base">
                {lang === 'am' ? 'ይፋዊ የተማሪዎች ማሳወቂያ ያስተላልፉ' : 'Dispatch Student Notification'}
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {lang === 'am'
                  ? 'በካምፓስ ለሚገኙ ተማሪዎች የጤና፣ የክሊኒክ ወይም የአስቸኳይ ጊዜ መረጃዎችን በቀጥታ ያድርሱ'
                  : 'Broadcast bilingual updates, clinical notices, or health alerts directly to students'}
              </p>
            </div>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer"
          >
            <X size={18} />
          </button>
        </div>

        {/* Modal Body: Split Screen (Left: Composer, Right: Mobile Live Preview) */}
        <div className="grid grid-cols-1 lg:grid-cols-12 flex-1 overflow-y-auto">
          {/* Left Column: Form Controls (7 cols) */}
          <form onSubmit={handleSubmit} className="lg:col-span-7 p-6 space-y-5 border-r border-slate-100 dark:border-slate-800">
            {/* Quick Preset Templates */}
            <div>
              <label className="block text-xs font-bold text-slate-600 dark:text-slate-400 uppercase tracking-wider mb-2 flex items-center gap-1.5">
                <Sparkles size={13} className="text-amber-500" />
                <span>{lang === 'am' ? 'ፈጣን የአብነት ምርጫዎች (1-ጠቅታ)' : 'Quick Preset Templates'}</span>
              </label>
              <div className="flex flex-wrap gap-2">
                {TEMPLATES.map((tpl, i) => (
                  <button
                    key={i}
                    type="button"
                    onClick={() => handleApplyTemplate(tpl)}
                    className="px-2.5 py-1 text-xs rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:border-indigo-500 hover:text-indigo-600 dark:hover:text-indigo-400 transition-all font-semibold cursor-pointer"
                  >
                    {lang === 'am' ? tpl.nameAm : tpl.nameEn}
                  </button>
                ))}
              </div>
            </div>

            {/* Category Selector */}
            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-2">
                {lang === 'am' ? 'የማሳወቂያ ዘርፍ' : 'Notification Category'}
              </label>
              <div className="grid grid-cols-3 gap-2">
                {CATEGORIES.map((cat) => {
                  const Icon = cat.icon;
                  const isSelected = type === cat.id;
                  return (
                    <button
                      key={cat.id}
                      type="button"
                      onClick={() => setType(cat.id)}
                      className={`flex items-center gap-2 p-2.5 rounded-xl border text-xs font-bold transition-all cursor-pointer ${
                        isSelected
                          ? 'border-indigo-600 bg-indigo-50 dark:bg-indigo-950/40 text-indigo-700 dark:text-indigo-300 shadow-xs'
                          : 'border-slate-200 dark:border-slate-700 hover:border-slate-300 dark:hover:border-slate-600 text-slate-600 dark:text-slate-400'
                      }`}
                    >
                      <Icon size={14} className={isSelected ? 'text-indigo-600 dark:text-indigo-400' : 'text-slate-400'} />
                      <span className="truncate">{lang === 'am' ? cat.labelAm : cat.labelEn}</span>
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Priority & Target Campus Grid */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                  {lang === 'am' ? 'የቅድሚያ ደረጃ' : 'Priority Level'}
                </label>
                <div className="flex gap-2">
                  {(['normal', 'high', 'urgent'] as NotificationPriority[]).map((p) => {
                    const isSelected = priority === p;
                    return (
                      <button
                        key={p}
                        type="button"
                        onClick={() => setPriority(p)}
                        className={`flex-1 py-1.5 px-2 rounded-xl text-xs font-bold uppercase tracking-wider border transition-all cursor-pointer ${
                          isSelected
                            ? p === 'urgent'
                              ? 'bg-rose-500 border-rose-500 text-white shadow-xs'
                              : p === 'high'
                              ? 'bg-amber-500 border-amber-500 text-white shadow-xs'
                              : 'bg-slate-900 dark:bg-white border-slate-900 dark:border-white text-white dark:text-slate-900'
                            : 'border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-400'
                        }`}
                      >
                        {p}
                      </button>
                    );
                  })}
                </div>
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                  {lang === 'am' ? 'ዒላማ ካምፓስ' : 'Target Campus Scope'}
                </label>
                <select
                  value={targetCampus}
                  onChange={(e) => setTargetCampus(e.target.value)}
                  className="w-full px-3 py-2 text-xs font-semibold rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:outline-hidden focus:border-indigo-500"
                >
                  {CAMPUSES.map((c) => (
                    <option key={c.id} value={c.id}>
                      {lang === 'am' ? c.nameAm : c.nameEn}
                    </option>
                  ))}
                </select>
              </div>
            </div>

            {/* Bilingual Titles */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                  {lang === 'am' ? 'ርዕስ (እንግሊዝኛ)' : 'Title (English)'}
                </label>
                <input
                  type="text"
                  required
                  value={titleEn}
                  onChange={(e) => setTitleEn(e.target.value)}
                  placeholder="e.g. Free Confidential STI Screening Week"
                  className="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:outline-hidden focus:border-indigo-500"
                />
              </div>
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                  {lang === 'am' ? 'ርዕስ (በአማርኛ)' : 'Title (Amharic)'}
                </label>
                <input
                  type="text"
                  required
                  value={titleAm}
                  onChange={(e) => setTitleAm(e.target.value)}
                  placeholder="ምሳሌ፡ ነፃ ሚስጥራዊ የጤና እና የምርመራ ሳምንት"
                  className="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:outline-hidden focus:border-indigo-500"
                />
              </div>
            </div>

            {/* Bilingual Messages */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                  {lang === 'am' ? 'መልእክት (እንግሊዝኛ)' : 'Message (English)'}
                </label>
                <textarea
                  rows={3}
                  required
                  value={messageEn}
                  onChange={(e) => setMessageEn(e.target.value)}
                  placeholder="Detailed youth health bulletin for student notifications..."
                  className="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:outline-hidden focus:border-indigo-500 resize-none"
                />
              </div>
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                  {lang === 'am' ? 'መልእክት (በአማርኛ)' : 'Message (Amharic)'}
                </label>
                <textarea
                  rows={3}
                  required
                  value={messageAm}
                  onChange={(e) => setMessageAm(e.target.value)}
                  placeholder="የተሟላ የጤና ማሳወቂያ መልእክት እዚህ ይፃፉ..."
                  className="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:outline-hidden focus:border-indigo-500 resize-none"
                />
              </div>
            </div>

            {/* Deep-link Action Selector & Pinning */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2 border-t border-slate-100 dark:border-slate-800">
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                  {lang === 'am' ? 'ቀጥታ መዳረሻ (Deep-Link)' : 'Deep-Link In-App Action'}
                </label>
                <select
                  value={routePayload}
                  onChange={(e) => setRoutePayload(e.target.value)}
                  className="w-full px-3 py-2 text-xs font-semibold rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:outline-hidden focus:border-indigo-500"
                >
                  <option value="">{lang === 'am' ? 'ምንም (ተራ መልእክት)' : 'None (Read only)'}</option>
                  <option value="learn">{lang === 'am' ? 'ወደ ትምህርት ገጽ (Learning Hub)' : 'Open Learning Hub'}</option>
                  <option value="learn:puberty">{lang === 'am' ? 'የጉርምስና ትምህርት ክፍል' : 'Puberty & Changes Module'}</option>
                  <option value="learn:hiv_sti">{lang === 'am' ? 'የኤችአይቪ/አባላዘር ትምህርት ክፍል' : 'HIV & STI Prevention Module'}</option>
                  <option value="learn:mental_health">{lang === 'am' ? 'የአእምሮ ጤና ትምህርት ክፍል' : 'Mental Health Module'}</option>
                  <option value="facility:clinic">{lang === 'am' ? 'የካምፓስ ክሊኒኮች ዝርዝር' : 'Nearest Campus Clinic'}</option>
                  <option value="club:general">{lang === 'am' ? 'የተማሪዎች ክበባት' : 'Student Clubs Hub'}</option>
                </select>
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                  {lang === 'am' ? 'የአዝራር ጽሑፍ (Call-to-Action)' : 'Button Label (CTA)'}
                </label>
                <input
                  type="text"
                  value={actionLabelEn}
                  onChange={(e) => setActionLabelEn(e.target.value)}
                  placeholder="e.g. View Clinic Details"
                  className="w-full px-3 py-2 text-xs rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:outline-hidden focus:border-indigo-500"
                />
              </div>
            </div>

            {/* Pinned to Top Switch */}
            <div className="flex items-center justify-between p-3 rounded-2xl bg-slate-50 dark:bg-slate-800/60 border border-slate-200/80 dark:border-slate-700/80">
              <div className="flex items-center gap-2.5">
                <div className="p-1.5 rounded-lg bg-amber-500/10 text-amber-600 dark:text-amber-400">
                  <Pin size={16} />
                </div>
                <div>
                  <h4 className="text-xs font-extrabold text-slate-900 dark:text-white">
                    {lang === 'am' ? 'ከላይ ይሰቀል (Pin to Top)' : 'Pin to Top of Student Feed'}
                  </h4>
                  <p className="text-[11px] text-slate-500 dark:text-slate-400">
                    {lang === 'am' ? 'በተማሪዎች የማሳወቂያ ዝርዝር ውስጥ የመጀመሪያው ሆኖ ይታያል' : 'Remains at the top of the in-app notification center'}
                  </p>
                </div>
              </div>
              <input
                type="checkbox"
                checked={isPinned}
                onChange={(e) => setIsPinned(e.target.checked)}
                className="w-4 h-4 rounded text-indigo-600 focus:ring-indigo-500 border-slate-300 dark:border-slate-600 cursor-pointer"
              />
            </div>

            {/* Action Buttons */}
            <div className="flex items-center justify-end gap-3 pt-3 border-t border-slate-100 dark:border-slate-800">
              <button
                type="button"
                onClick={onClose}
                className="px-4 py-2 text-xs font-bold rounded-xl border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer"
              >
                {lang === 'am' ? 'ይቅር' : 'Cancel'}
              </button>
              <button
                type="submit"
                disabled={isSubmitting || !titleEn.trim() || !titleAm.trim()}
                className="flex items-center gap-2 px-5 py-2 text-xs font-bold rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white shadow-md shadow-indigo-600/20 disabled:opacity-50 transition-all cursor-pointer"
              >
                <Send size={14} />
                <span>{isSubmitting ? (lang === 'am' ? 'በመላክ ላይ...' : 'Broadcasting...') : (lang === 'am' ? 'ማሳወቂያውን ላክ' : 'Send Broadcast')}</span>
              </button>
            </div>
          </form>

          {/* Right Column: Live Mobile Mockup Preview (5 cols) */}
          <div className="lg:col-span-5 p-6 bg-slate-50/60 dark:bg-slate-950/40 flex flex-col items-center justify-center">
            <div className="w-full max-w-[320px] flex flex-col items-center">
              <div className="flex items-center gap-2 mb-3 text-xs font-bold text-slate-500 dark:text-slate-400">
                <Smartphone size={14} />
                <span>{lang === 'am' ? 'የተማሪ ስልክ የቀጥታ እይታ' : 'Student Device Live Preview'}</span>
              </div>

              {/* Toggle Preview Mode */}
              <div className="flex gap-1 p-1 mb-4 rounded-xl bg-slate-200 dark:bg-slate-800 w-full text-[11px] font-bold">
                <button
                  type="button"
                  onClick={() => setPreviewTab('toast')}
                  className={`flex-1 py-1 rounded-lg transition-all ${
                    previewTab === 'toast'
                      ? 'bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-xs'
                      : 'text-slate-500 hover:text-slate-700 dark:hover:text-slate-300'
                  }`}
                >
                  {lang === 'am' ? 'ተንሳፋፊ ባነር (Toast)' : 'Floating Banner'}
                </button>
                <button
                  type="button"
                  onClick={() => setPreviewTab('card')}
                  className={`flex-1 py-1 rounded-lg transition-all ${
                    previewTab === 'card'
                      ? 'bg-white dark:bg-slate-700 text-slate-900 dark:text-white shadow-xs'
                      : 'text-slate-500 hover:text-slate-700 dark:hover:text-slate-300'
                  }`}
                >
                  {lang === 'am' ? 'የማሳወቂያ ካርድ (Feed)' : 'Notification Card'}
                </button>
              </div>

              {/* Realistic Mobile Mockup Shell */}
              <div className="w-full rounded-[36px] bg-slate-900 p-3 shadow-2xl border-4 border-slate-800 text-white">
                {/* Dynamic Island / Speaker Notch */}
                <div className="w-24 h-4 bg-black rounded-full mx-auto mb-3" />

                {/* Mobile Screen Surface */}
                <div className="w-full min-h-[360px] rounded-[24px] bg-gradient-to-b from-slate-900 via-slate-900/90 to-indigo-950/60 p-3 flex flex-col justify-start space-y-3 relative overflow-hidden">
                  {/* Subtle Background Glow */}
                  <div className="absolute top-0 right-0 w-32 h-32 bg-indigo-500/10 rounded-full blur-2xl pointer-events-none" />

                  {previewTab === 'toast' ? (
                    /* Floating Heads-Up Banner Toast Preview */
                    <div className="animate-in slide-in-from-top duration-300">
                      <div className={`p-3 rounded-2xl border backdrop-blur-md shadow-lg flex items-start gap-2.5 ${
                        priority === 'urgent'
                          ? 'bg-rose-950/80 border-rose-500/50 shadow-rose-900/40'
                          : 'bg-slate-800/90 border-slate-700/80 shadow-black/40'
                      }`}>
                        <div className="p-2 rounded-xl bg-indigo-600 text-white shrink-0 mt-0.5 shadow-md">
                          <CategoryIcon size={16} />
                        </div>
                        <div className="flex-1 min-w-0">
                          <div className="flex items-center justify-between gap-1 mb-0.5">
                            <h5 className="font-extrabold text-[12px] text-white truncate">
                              {titleEn || (lang === 'am' ? 'የማሳወቂያ ርዕስ...' : 'Notification Title...')}
                            </h5>
                            <span className="text-[10px] text-slate-400 shrink-0">Now</span>
                          </div>
                          <p className="text-[11px] text-slate-300 line-clamp-2 leading-tight">
                            {messageEn || (lang === 'am' ? 'የማሳወቂያ ዝርዝር መልእክት...' : 'Notification message preview will appear here...')}
                          </p>
                          {priority === 'urgent' && (
                            <div className="mt-1.5 flex items-center gap-1 text-[10px] font-extrabold text-rose-400">
                              <Flame size={11} />
                              <span>Urgent Campus Advisory</span>
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                  ) : (
                    /* Notification Card Feed Preview */
                    <div className="animate-in fade-in duration-200">
                      <div className={`p-3 rounded-2xl border backdrop-blur-md shadow-md space-y-2 ${
                        priority === 'urgent'
                          ? 'bg-slate-800/80 border-rose-500/50 shadow-rose-900/20'
                          : 'bg-slate-800/60 border-slate-700/70'
                      }`}>
                        <div className="flex items-center justify-between">
                          <div className="flex items-center gap-1.5">
                            <span className={`px-2 py-0.5 rounded-lg text-[9px] font-extrabold uppercase tracking-wider border ${activeCategory.color}`}>
                              {activeCategory.labelEn}
                            </span>
                            {isPinned && (
                              <span className="px-1.5 py-0.5 rounded-md bg-amber-500/20 text-amber-400 text-[9px] font-bold">
                                Pinned
                              </span>
                            )}
                          </div>
                          <span className="text-[10px] text-slate-400">10m ago</span>
                        </div>

                        <h5 className="font-extrabold text-xs text-white">
                          {titleEn || 'Notification Title'}
                        </h5>

                        <p className="text-[11px] text-slate-300 line-clamp-3 leading-relaxed">
                          {messageEn || 'Your detailed broadcast text will display neatly formatted on the student mobile feed.'}
                        </p>

                        {(actionLabelEn || routePayload) && (
                          <div className="pt-1.5 flex justify-end">
                            <div className="inline-flex items-center gap-1 px-2.5 py-1 rounded-xl bg-indigo-600/30 border border-indigo-500/40 text-indigo-300 text-[10px] font-bold">
                              <span>{actionLabelEn || 'Explore Now'}</span>
                              <ExternalLink size={10} />
                            </div>
                          </div>
                        )}
                      </div>
                    </div>
                  )}

                  {/* Mock Background UI Content */}
                  <div className="opacity-20 space-y-2 pt-4">
                    <div className="h-3 w-3/4 bg-slate-700 rounded-full" />
                    <div className="h-2.5 w-1/2 bg-slate-700 rounded-full" />
                    <div className="h-16 w-full bg-slate-800/50 rounded-xl" />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
