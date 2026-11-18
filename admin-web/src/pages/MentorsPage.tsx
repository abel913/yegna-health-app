import React, { useState, useMemo } from 'react';
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
  Search,
  Download,
  MapPin,
  Clock,
  Award,
  MessageCircle,
  Building2,
  ShieldCheck,
  UserCheck,
  Loader2,
  Globe,
  Tag,
  Calendar,
  Sparkles,
} from 'lucide-react';
import { Mentor, WeeklySchedule, DaySchedule } from '../types/index.js';
import { EmptyState } from '../components/common/EmptyState.js';
import { ConfirmModal } from '../components/common/ConfirmModal.js';
import { exportToCsv } from '../utils/csvExport.js';
import { useToast } from '../context/ToastContext.js';

export const UOG_CAMPUSES = [
  { value: 'Atse Fasil Campus', labelEn: 'Atse Fasil Campus (አጼ ፋሲል ግቢ)', labelAm: 'አጼ ፋሲል ግቢ' },
  { value: 'Atse Tewodros Campus', labelEn: 'Atse Tewodros Campus (አጼ ቴዎድሮስ ግቢ)', labelAm: 'አጼ ቴዎድሮስ ግቢ' },
  { value: 'CMHS / Health College', labelEn: 'CMHS / Health Sciences College (የጤና ሳይንስ ኮሌጅ)', labelAm: 'የጤና ሳይንስ ኮሌጅ ግቢ' },
  { value: 'Maraki Campus', labelEn: 'Maraki Campus (ማራኪ ግቢ)', labelAm: 'ማራኪ ግቢ' },
  { value: 'Teda Campus', labelEn: 'Teda Campus (ተዳ ግቢ)', labelAm: 'ተዳ ግቢ' },
  { value: 'Central Directorate / All Campuses', labelEn: 'Central Directorate / All Campuses (ማዕከላዊ ዳይሬክቶሬት)', labelAm: 'ማዕከላዊ ዳይሬክቶሬት / ሁሉም ግቢዎች' },
];

export const PRESET_LANGUAGES = ['Amharic', 'English', 'Afaan Oromoo', 'Tigrinya', 'Somali'];

export const PRESET_SPECIALTIES = [
  { tag: '#MentalHealth', label: 'Mental Health & Wellbeing' },
  { tag: '#SRH', label: 'Sexual & Reproductive Health' },
  { tag: '#Puberty', label: 'Puberty & Adolescence' },
  { tag: '#SubstanceAbuse', label: 'Substance Abuse & Addiction' },
  { tag: '#GBV', label: 'Gender-Based Violence' },
];

export const WEEKDAYS = [
  { key: 'monday' as const, short: 'Mo', labelEn: 'Monday', fullEn: 'Monday', fullAm: 'ሰኞ' },
  { key: 'tuesday' as const, short: 'Tu', labelEn: 'Tuesday', fullEn: 'Tuesday', fullAm: 'ማክሰኞ' },
  { key: 'wednesday' as const, short: 'We', labelEn: 'Wednesday', fullEn: 'Wednesday', fullAm: 'ረቡዕ' },
  { key: 'thursday' as const, short: 'Th', labelEn: 'Thursday', fullEn: 'Thursday', fullAm: 'ሐሙስ' },
  { key: 'friday' as const, short: 'Fr', labelEn: 'Friday', fullEn: 'Friday', fullAm: 'ዓርብ' },
  { key: 'saturday' as const, short: 'Sa', labelEn: 'Saturday', fullEn: 'Saturday', fullAm: 'ቅዳሜ' },
  { key: 'sunday' as const, short: 'Su', labelEn: 'Sunday', fullEn: 'Sunday', fullAm: 'እሑድ' },
];

export const TIME_SLOTS = [
  { value: '08:00', label: '8:00 AM' },
  { value: '08:30', label: '8:30 AM' },
  { value: '09:00', label: '9:00 AM' },
  { value: '09:30', label: '9:30 AM' },
  { value: '10:00', label: '10:00 AM' },
  { value: '10:30', label: '10:30 AM' },
  { value: '11:00', label: '11:00 AM' },
  { value: '11:30', label: '11:30 AM' },
  { value: '12:00', label: '12:00 PM' },
  { value: '12:30', label: '12:30 PM' },
  { value: '13:00', label: '1:00 PM' },
  { value: '13:30', label: '1:30 PM' },
  { value: '14:00', label: '2:00 PM' },
  { value: '14:30', label: '2:30 PM' },
  { value: '15:00', label: '3:00 PM' },
  { value: '15:30', label: '3:30 PM' },
  { value: '16:00', label: '4:00 PM' },
  { value: '16:30', label: '4:30 PM' },
  { value: '17:00', label: '5:00 PM' },
  { value: '17:30', label: '5:30 PM' },
  { value: '18:00', label: '6:00 PM' },
];

export const DEFAULT_WEEKLY_SCHEDULE: WeeklySchedule = {
  monday: { enabled: true, start: '08:30', end: '17:30' },
  tuesday: { enabled: true, start: '08:30', end: '17:30' },
  wednesday: { enabled: true, start: '08:30', end: '17:30' },
  thursday: { enabled: true, start: '08:30', end: '17:30' },
  friday: { enabled: true, start: '08:30', end: '17:30' },
  saturday: { enabled: false, start: '09:00', end: '13:00' },
  sunday: { enabled: false, start: '09:00', end: '13:00' },
};

function formatTimeLabel(val: string): string {
  const match = TIME_SLOTS.find((s) => s.value === val);
  if (match) return match.label;
  const [h, m] = val.split(':').map(Number);
  if (isNaN(h)) return val;
  const ampm = h >= 12 ? 'PM' : 'AM';
  const hour12 = h % 12 === 0 ? 12 : h % 12;
  return `${hour12}:${String(m || 0).padStart(2, '0')} ${ampm}`;
}

function generateWorkingHoursSummaries(schedule: WeeklySchedule): { en: string; am: string } {
  const isMonFri =
    schedule.monday.enabled &&
    schedule.tuesday.enabled &&
    schedule.wednesday.enabled &&
    schedule.thursday.enabled &&
    schedule.friday.enabled &&
    !schedule.saturday.enabled &&
    !schedule.sunday.enabled;

  const isMonSat =
    schedule.monday.enabled &&
    schedule.tuesday.enabled &&
    schedule.wednesday.enabled &&
    schedule.thursday.enabled &&
    schedule.friday.enabled &&
    schedule.saturday.enabled &&
    !schedule.sunday.enabled;

  const isAllDays = Object.values(schedule).every((d) => d.enabled);

  const startFmt = formatTimeLabel(schedule.monday.start);
  const endFmt = formatTimeLabel(schedule.monday.end);

  if (isMonFri) {
    return {
      en: `Mon – Fri: ${startFmt} – ${endFmt}`,
      am: `ከሰኞ – ዓርብ፡ 2:30 – 11:30`,
    };
  } else if (isMonSat) {
    return {
      en: `Mon – Sat: ${startFmt} – ${endFmt}`,
      am: `ከሰኞ – ቅዳሜ፡ 3:00 – 12:00`,
    };
  } else if (isAllDays) {
    return {
      en: `Daily (All Week): ${startFmt} – ${endFmt}`,
      am: `በየቀኑ (ሙሉ ሳምንት)፡ 2:30 – 11:30`,
    };
  }

  const enabledDays = WEEKDAYS.filter((w) => schedule[w.key].enabled);
  if (enabledDays.length === 0) {
    return {
      en: `Currently Offline / On Leave`,
      am: `በአሁኑ ሰዓት እረፍት ላይ`,
    };
  }
  const dayNames = enabledDays.map((d) => d.labelEn).join(', ');
  return {
    en: `${dayNames}: ${startFmt} – ${endFmt}`,
    am: `${dayNames}፡ 2:30 – 11:30`,
  };
}

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
  const { toast } = useToast();
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState<'all' | 'available' | 'offline' | 'verified'>('all');
  const [campusFilter, setCampusFilter] = useState<string>('all');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingMentor, setEditingMentor] = useState<Mentor | null>(null);
  const [mentorToDelete, setMentorToDelete] = useState<Mentor | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [customLanguage, setCustomLanguage] = useState('');
  const [customSpecialty, setCustomSpecialty] = useState('');
  const [weeklySchedule, setWeeklySchedule] = useState<WeeklySchedule>(DEFAULT_WEEKLY_SCHEDULE);
  const [activeDayKey, setActiveDayKey] = useState<keyof WeeklySchedule>('monday');

  const [formData, setFormData] = useState({
    name: '',
    organization: 'University of Gondar & Marie Stopes',
    campus: 'Atse Fasil Campus',
    roleTitleEn: 'Certified Youth Peer Counselor',
    roleTitleAm: 'የተረጋገጠ የወጣቶች አቻ አማካሪ',
    phone: '+2519',
    whatsapp: '',
    telegramHandle: '',
    email: '',
    experienceYears: 2,
    sessionsCount: 120,
    workingHoursEn: 'Mon – Fri: 8:30 AM – 5:30 PM',
    workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
    bioEn: 'Certified youth mentor offering confidential, stigma-free guidance on emotional wellness and health.',
    bioAm: 'ሚስጥራዊ፣ ነፃ እና ፍረጃ የሌለበት የስነ-ልቦና እና የስነ-ተዋልዶ ጤና የምክር አገልግሎት የሚሰጥ የተረጋገጠ አቻ አማካሪ።',
    languages: ['Amharic', 'English'],
    specialties: ['#MentalHealth', '#SRH'],
    isAvailable: true,
    isVerified: true,
  });

  // Filtered mentors computation
  const filteredMentors = useMemo(() => {
    return mentors.filter((m) => {
      const q = search.trim().toLowerCase();
      const matchesSearch =
        !q ||
        m.name.toLowerCase().includes(q) ||
        m.organization.toLowerCase().includes(q) ||
        (m.campus && m.campus.toLowerCase().includes(q)) ||
        m.phone.toLowerCase().includes(q) ||
        (m.whatsapp && m.whatsapp.toLowerCase().includes(q)) ||
        (m.telegramHandle && m.telegramHandle.toLowerCase().includes(q)) ||
        (m.specialties && m.specialties.some((s) => s.toLowerCase().includes(q)));

      const matchesStatus =
        statusFilter === 'all' ||
        (statusFilter === 'available' && m.isAvailable) ||
        (statusFilter === 'offline' && !m.isAvailable) ||
        (statusFilter === 'verified' && m.isVerified);

      const matchesCampus =
        campusFilter === 'all' || (m.campus || 'Atse Fasil Campus') === campusFilter;

      return matchesSearch && matchesStatus && matchesCampus;
    });
  }, [mentors, search, statusFilter, campusFilter]);

  // Counts for status pills
  const totalCount = mentors.length;
  const availableCount = useMemo(() => mentors.filter((m) => m.isAvailable).length, [mentors]);
  const offlineCount = useMemo(() => mentors.filter((m) => !m.isAvailable).length, [mentors]);
  const verifiedCount = useMemo(() => mentors.filter((m) => m.isVerified).length, [mentors]);

  const handleExportCsv = () => {
    exportToCsv(
      'Yegna_Health_Mentors_Roster',
      [
        { header: 'Counselor Name', accessor: (m) => m.name },
        { header: 'UoG Campus', accessor: (m) => m.campus || 'Atse Fasil Campus' },
        { header: 'Role Title (EN)', accessor: (m) => m.roleTitleEn || 'Certified Youth Peer Counselor' },
        { header: 'Organization', accessor: (m) => m.organization },
        { header: 'Phone / Hotline', accessor: (m) => m.phone },
        { header: 'WhatsApp', accessor: (m) => m.whatsapp || 'N/A' },
        { header: 'Telegram Handle', accessor: (m) => m.telegramHandle || 'N/A' },
        { header: 'Email', accessor: (m) => m.email || 'N/A' },
        { header: 'Experience (Years)', accessor: (m) => String(m.experienceYears ?? 2) },
        { header: 'Sessions Done', accessor: (m) => String(m.sessionsCount ?? 120) },
        { header: 'Available Hours', accessor: (m) => m.workingHoursEn || 'Mon – Fri: 8:30 AM – 5:30 PM' },
        { header: 'Languages', accessor: (m) => (m.languages || []).join('; ') },
        { header: 'Availability', accessor: (m) => (m.isAvailable ? 'AVAILABLE_ONLINE' : 'OFFLINE') },
        { header: 'Verification', accessor: (m) => (m.isVerified ? 'VERIFIED' : 'STANDARD') },
        { header: 'Specialties', accessor: (m) => (m.specialties || []).join('; ') },
      ],
      filteredMentors
    );
    toast.success(
      lang === 'am' ? 'የአማካሪዎች ዝርዝር ወደ CSV በተሳካ ሁኔታ ወርዷል' : 'Mentors roster exported successfully',
      lang === 'am' ? 'ሪፖርት ተዘጋጅቷል' : 'Export Ready'
    );
  };

  const openCreateModal = () => {
    setEditingMentor(null);
    setFormData({
      name: '',
      organization: 'University of Gondar & Marie Stopes',
      campus: 'Atse Fasil Campus',
      roleTitleEn: 'Certified Youth Peer Counselor',
      roleTitleAm: 'የተረጋገጠ የወጣቶች አቻ አማካሪ',
      phone: '+2519',
      whatsapp: '',
      telegramHandle: '',
      email: '',
      experienceYears: 2,
      sessionsCount: 120,
      workingHoursEn: 'Mon – Fri: 8:30 AM – 5:30 PM',
      workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
      bioEn: 'Certified youth mentor offering confidential, stigma-free guidance on emotional wellness and health.',
      bioAm: 'ሚስጥራዊ፣ ነፃ እና ፍረጃ የሌለበት የስነ-ልቦና እና የስነ-ተዋልዶ ጤና የምክር አገልግሎት የሚሰጥ የተረጋገጠ አቻ አማካሪ።',
      languages: ['Amharic', 'English'],
      specialties: ['#MentalHealth', '#SRH'],
      isAvailable: true,
      isVerified: true,
    });
    setIsModalOpen(true);
    setWeeklySchedule(DEFAULT_WEEKLY_SCHEDULE);
    setActiveDayKey('monday');
  };

  const openEditModal = (m: Mentor) => {
    setEditingMentor(m);
    const initialSchedule: WeeklySchedule = m.weeklySchedule
      ? { ...DEFAULT_WEEKLY_SCHEDULE, ...m.weeklySchedule }
      : DEFAULT_WEEKLY_SCHEDULE;
    setWeeklySchedule(initialSchedule);
    setActiveDayKey('monday');
    setFormData({
      name: m.name,
      organization: m.organization || 'University of Gondar & Marie Stopes',
      campus: m.campus || 'Atse Fasil Campus',
      roleTitleEn: m.roleTitleEn || 'Certified Youth Peer Counselor',
      roleTitleAm: m.roleTitleAm || 'የተረጋገጠ የወጣቶች አቻ አማካሪ',
      phone: m.phone,
      whatsapp: m.whatsapp || '',
      telegramHandle: (m.telegramHandle || '').replace(/^@+/, ''),
      email: m.email || '',
      experienceYears: m.experienceYears ?? 2,
      sessionsCount: m.sessionsCount ?? 120,
      workingHoursEn: m.workingHoursEn || 'Mon – Fri: 8:30 AM – 5:30 PM',
      workingHoursAm: m.workingHoursAm || 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
      bioEn: m.bioEn || 'Certified youth mentor offering confidential, stigma-free guidance on emotional wellness and health.',
      bioAm: m.bioAm || 'ሚስጥራዊ፣ ነፃ እና ፍረጃ የሌለበት የስነ-ልቦና እና የስነ-ተዋልዶ ጤና የምክር አገልግሎት የሚሰጥ የተረጋገጠ አቻ አማካሪ።',
      languages: m.languages || ['Amharic', 'English'],
      specialties: m.specialties || ['#MentalHealth', '#SRH'],
      isAvailable: m.isAvailable ?? true,
      isVerified: m.isVerified ?? true,
    });
    setIsModalOpen(true);
    setCustomLanguage('');
    setCustomSpecialty('');
  };

  const handleToggleLanguage = (langName: string) => {
    const current = formData.languages || [];
    if (current.includes(langName)) {
      setFormData({ ...formData, languages: current.filter((l) => l !== langName) });
    } else {
      setFormData({ ...formData, languages: [...current, langName] });
    }
  };

  const handleAddCustomLanguage = (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    const trimmed = customLanguage.trim();
    if (!trimmed) return;
    const current = formData.languages || [];
    if (!current.includes(trimmed)) {
      setFormData({ ...formData, languages: [...current, trimmed] });
    }
    setCustomLanguage('');
  };

  const handleRemoveLanguage = (langName: string) => {
    setFormData({ ...formData, languages: (formData.languages || []).filter((l) => l !== langName) });
  };

  const handleToggleSpecialty = (tag: string) => {
    const formattedTag = tag.startsWith('#') ? tag : `#${tag}`;
    const current = formData.specialties || [];
    if (current.includes(formattedTag)) {
      setFormData({ ...formData, specialties: current.filter((s) => s !== formattedTag) });
    } else {
      setFormData({ ...formData, specialties: [...current, formattedTag] });
    }
  };

  const handleAddCustomSpecialty = (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    let trimmed = customSpecialty.trim();
    if (!trimmed) return;
    if (!trimmed.startsWith('#')) trimmed = `#${trimmed}`;
    const current = formData.specialties || [];
    if (!current.includes(trimmed)) {
      setFormData({ ...formData, specialties: [...current, trimmed] });
    }
    setCustomSpecialty('');
  };

  const handleRemoveSpecialty = (tag: string) => {
    setFormData({ ...formData, specialties: (formData.specialties || []).filter((s) => s !== tag) });
  };

  const updateActiveDaySchedule = (patch: Partial<DaySchedule>) => {
    setWeeklySchedule((prev) => {
      const updated = {
        ...prev,
        [activeDayKey]: {
          ...prev[activeDayKey],
          ...patch,
        },
      };
      const summaries = generateWorkingHoursSummaries(updated);
      setFormData((f) => ({
        ...f,
        workingHoursEn: summaries.en,
        workingHoursAm: summaries.am,
      }));
      return updated;
    });
  };

  const applyPreset = (preset: 'mon_fri' | 'mon_sat' | 'all') => {
    let newSched: WeeklySchedule;
    if (preset === 'mon_fri') {
      newSched = {
        monday: { enabled: true, start: '08:30', end: '17:30' },
        tuesday: { enabled: true, start: '08:30', end: '17:30' },
        wednesday: { enabled: true, start: '08:30', end: '17:30' },
        thursday: { enabled: true, start: '08:30', end: '17:30' },
        friday: { enabled: true, start: '08:30', end: '17:30' },
        saturday: { enabled: false, start: '09:00', end: '13:00' },
        sunday: { enabled: false, start: '09:00', end: '13:00' },
      };
    } else if (preset === 'mon_sat') {
      newSched = {
        monday: { enabled: true, start: '09:00', end: '18:00' },
        tuesday: { enabled: true, start: '09:00', end: '18:00' },
        wednesday: { enabled: true, start: '09:00', end: '18:00' },
        thursday: { enabled: true, start: '09:00', end: '18:00' },
        friday: { enabled: true, start: '09:00', end: '18:00' },
        saturday: { enabled: true, start: '09:00', end: '14:00' },
        sunday: { enabled: false, start: '09:00', end: '13:00' },
      };
    } else {
      newSched = {
        monday: { enabled: true, start: '08:30', end: '17:30' },
        tuesday: { enabled: true, start: '08:30', end: '17:30' },
        wednesday: { enabled: true, start: '08:30', end: '17:30' },
        thursday: { enabled: true, start: '08:30', end: '17:30' },
        friday: { enabled: true, start: '08:30', end: '17:30' },
        saturday: { enabled: true, start: '08:30', end: '17:30' },
        sunday: { enabled: true, start: '08:30', end: '17:30' },
      };
    }
    setWeeklySchedule(newSched);
    const summaries = generateWorkingHoursSummaries(newSched);
    setFormData((f) => ({
      ...f,
      workingHoursEn: summaries.en,
      workingHoursAm: summaries.am,
    }));
  };

  const copyActiveDayToWeekdays = () => {
    const active = weeklySchedule[activeDayKey];
    setWeeklySchedule((prev) => {
      const updated = {
        ...prev,
        monday: { ...active },
        tuesday: { ...active },
        wednesday: { ...active },
        thursday: { ...active },
        friday: { ...active },
      };
      const summaries = generateWorkingHoursSummaries(updated);
      setFormData((f) => ({
        ...f,
        workingHoursEn: summaries.en,
        workingHoursAm: summaries.am,
      }));
      return updated;
    });
    const dayLabel = WEEKDAYS.find((w) => w.key === activeDayKey)?.labelEn;
    toast.success(`Copied ${dayLabel} hours to Mon–Fri`);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (isSubmitting) return;
    setIsSubmitting(true);
    try {
      const cleanedPayload = {
        ...formData,
        weeklySchedule,
        telegramHandle: formData.telegramHandle.replace(/^@+/, '').trim() || null,
        whatsapp: formData.whatsapp.trim() || null,
        email: formData.email.trim() || null,
        experienceYears: Number(formData.experienceYears) || 0,
        sessionsCount: Number(formData.sessionsCount) || 0,
      };
      await onSave(cleanedPayload as any, editingMentor ? editingMentor.id : undefined);
      setIsModalOpen(false);
    } catch (err: any) {
      toast.error(err?.message || 'Failed to save mentor profile');
    } finally {
      setIsSubmitting(false);
    }
  };

  const getCleanWhatsappUrl = (val?: string) => {
    if (!val) return null;
    const cleanNum = val.replace(/[^\d]/g, '');
    return `https://wa.me/${cleanNum}`;
  };

  const getCleanTelegramUrl = (val?: string) => {
    if (!val) return null;
    const cleanHandle = val.replace(/^@+/, '').trim();
    return `https://t.me/${cleanHandle}`;
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            <Users2 className="text-brand-600 dark:text-cyan-400" size={24} />
            <span>{lang === 'am' ? 'የተመሰከረላቸው የዩኦጂ እና አቻ አማካሪዎች' : 'UoG Campuses Certified Peer Mentors & Counselors'}</span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1">
            {lang === 'am'
              ? 'የጎንደር ዩኒቨርሲቲ 4 ግቢዎች እና አጋር ድርጅቶች የምክር አገልግሎት ሰጪዎችን፣ ዋትስአፕ፣ ቴሌግራም እና የስራ ሰዓት ያስተዳድሩ።'
              : 'Manage counselor profiles across UoG campuses (Atse Fasil, Tewodros, CMHS, Maraki), Telegram handles, WhatsApp, working hours, and bios.'}
          </p>
        </div>
        <div className="flex items-center gap-2 self-start sm:self-auto">
          <button
            onClick={handleExportCsv}
            className="flex items-center gap-1.5 px-3.5 py-2.5 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs md:text-sm font-bold rounded-xl border border-slate-200 dark:border-slate-700 transition-all cursor-pointer shadow-2xs"
            title={lang === 'am' ? 'የአማካሪዎች ሪፖርት (CSV) አውርድ' : 'Export mentors to Excel CSV'}
          >
            <Download size={15} />
            <span>{lang === 'am' ? 'ሪፖርት (CSV)' : 'Export CSV'}</span>
          </button>
          <button
            onClick={openCreateModal}
            className="flex items-center gap-2 px-4 py-2.5 bg-brand-600 hover:bg-brand-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md shadow-brand-600/20 transition-all cursor-pointer"
          >
            <Plus size={16} />
            <span>{lang === 'am' ? '+ አዲስ አማካሪ መዝግብ' : '+ Add New Mentor'}</span>
          </button>
        </div>
      </div>

      {/* Search & Filter Controls */}
      {mentors.length > 0 && (
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
                    ? 'በአማካሪ ስም፣ በግቢ፣ በስልክ ቁጥር፣ በዋትስአፕ ወይም በልዩ ሙያ ፈልግ...'
                    : 'Search counselors by name, campus, phone, WhatsApp, @telegram, or specialty...'
                }
                className="w-full pl-9 pr-9 py-2 text-xs md:text-sm bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white rounded-xl focus:bg-white dark:focus:bg-slate-850 focus:border-brand-500 focus:outline-none transition-all placeholder:text-slate-400"
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

            {/* Campus Selector Filter */}
            <div className="w-full md:w-64">
              <select
                value={campusFilter}
                onChange={(e) => setCampusFilter(e.target.value)}
                className="w-full px-3 py-2 text-xs md:text-sm bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
              >
                <option value="all">
                  {lang === 'am' ? '🏢 ሁሉም የዩኦጂ ግቢዎች (All Campuses)' : '🏢 All UoG Campuses'}
                </option>
                {UOG_CAMPUSES.map((c) => (
                  <option key={c.value} value={c.value}>
                    {lang === 'am' ? c.labelAm : c.value}
                  </option>
                ))}
              </select>
            </div>
          </div>

          {/* Status Filter Pills */}
          <div className="flex flex-wrap items-center gap-2 pt-1 border-t border-slate-100 dark:border-slate-800">
            <span className="text-xs font-bold text-slate-400 dark:text-slate-500 mr-1">
              {lang === 'am' ? 'ሁኔታ:' : 'Status:'}
            </span>
            <button
              onClick={() => setStatusFilter('all')}
              className={`px-3 py-1 rounded-xl text-xs font-bold transition-all cursor-pointer ${
                statusFilter === 'all'
                  ? 'bg-slate-900 dark:bg-brand-600 text-white shadow-xs'
                  : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-200/80 dark:hover:bg-slate-700'
              }`}
            >
              {lang === 'am' ? 'ሁሉም አማካሪዎች' : 'All Mentors'} ({totalCount})
            </button>
            <button
              onClick={() => setStatusFilter('available')}
              className={`px-3 py-1 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 cursor-pointer ${
                statusFilter === 'available'
                  ? 'bg-emerald-600 text-white shadow-xs'
                  : 'bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 hover:bg-emerald-100 dark:hover:bg-emerald-900/60 border border-emerald-200/60 dark:border-emerald-800'
              }`}
            >
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-400" />
              <span>{lang === 'am' ? 'አሁን ዝግጁ የሆኑ' : 'Available Now'}</span> ({availableCount})
            </button>
            <button
              onClick={() => setStatusFilter('offline')}
              className={`px-3 py-1 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 cursor-pointer ${
                statusFilter === 'offline'
                  ? 'bg-slate-600 text-white shadow-xs'
                  : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 hover:bg-slate-200/80 dark:hover:bg-slate-700'
              }`}
            >
              <span>{lang === 'am' ? 'ከመስመር ውጭ' : 'Offline'}</span> ({offlineCount})
            </button>
            <button
              onClick={() => setStatusFilter('verified')}
              className={`px-3 py-1 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 cursor-pointer ${
                statusFilter === 'verified'
                  ? 'bg-brand-600 text-white shadow-xs'
                  : 'bg-brand-50 dark:bg-brand-950/40 text-brand-700 dark:text-cyan-400 hover:bg-brand-100 dark:hover:bg-brand-900/60 border border-brand-200/60 dark:border-brand-800'
              }`}
            >
              <CheckCircle2 size={13} />
              <span>{lang === 'am' ? 'የተረጋገጡ ብቻ' : 'Verified Only'}</span> ({verifiedCount})
            </button>
          </div>
        </div>
      )}

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
      ) : filteredMentors.length === 0 ? (
        <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-12 text-center shadow-xs">
          <div className="w-12 h-12 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-400 flex items-center justify-center mx-auto mb-3">
            <Search size={22} />
          </div>
          <h4 className="text-base font-extrabold text-slate-900 dark:text-white mb-1">
            {lang === 'am' ? 'ምንም አማካሪ አልተገኘም' : 'No Counselors Match Your Filters'}
          </h4>
          <p className="text-xs text-slate-500 dark:text-slate-400 max-w-sm mx-auto mb-4">
            {lang === 'am'
              ? 'የተጠቀምከውን የፍለጋ ቃል ወይም ማጣሪያ ቀይረህ እንደገና ሞክር።'
              : 'Try adjusting your search query or switching to "All Mentors" to see full results.'}
          </p>
          <button
            onClick={() => {
              setSearch('');
              setStatusFilter('all');
              setCampusFilter('all');
            }}
            className="px-4 py-2 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs font-bold rounded-xl transition-all cursor-pointer"
          >
            {lang === 'am' ? 'ማጣሪያዎችን አጽዳ' : 'Reset Filters'}
          </button>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {filteredMentors.map((m) => (
            <div
              key={m.id}
              className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 p-5 shadow-xs hover:shadow-md transition-all flex flex-col justify-between"
            >
              <div>
                {/* Header Info */}
                <div className="flex items-start justify-between gap-3 mb-3">
                  <div className="flex items-center gap-3">
                    <div className="w-12 h-12 rounded-full bg-gradient-to-tr from-cyan-500 via-blue-600 to-indigo-600 text-white font-extrabold text-sm flex items-center justify-center shadow-sm flex-shrink-0">
                      {m.name.slice(0, 2).toUpperCase()}
                    </div>
                    <div>
                      <div className="flex items-center gap-1.5 flex-wrap">
                        <h3 className="font-bold text-slate-900 dark:text-white text-sm leading-tight">{m.name}</h3>
                        {m.isVerified && <CheckCircle2 size={14} className="text-brand-600 dark:text-cyan-400 flex-shrink-0" />}
                      </div>
                      <p className="text-xs font-semibold text-brand-600 dark:text-cyan-400 mt-0.5">
                        {lang === 'am' ? (m.roleTitleAm || m.roleTitleEn || 'የተረጋገጠ አማካሪ') : (m.roleTitleEn || 'Certified Youth Peer Counselor')}
                      </p>
                      <p className="text-[11px] text-slate-500 dark:text-slate-400">{m.organization}</p>
                    </div>
                  </div>

                  <div className="flex items-center gap-1">
                    <button
                      onClick={() => openEditModal(m)}
                      className="p-1.5 text-slate-400 hover:text-brand-600 dark:hover:text-cyan-400 hover:bg-slate-50 dark:hover:bg-slate-800 rounded-lg cursor-pointer transition-colors"
                      title={lang === 'am' ? 'አማካሪን አርትዕ' : 'Edit Counselor'}
                    >
                      <Edit2 size={14} />
                    </button>
                    <button
                      onClick={() => setMentorToDelete(m)}
                      className="p-1.5 text-slate-400 hover:text-rose-600 dark:hover:text-rose-400 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-lg cursor-pointer transition-colors"
                      title={lang === 'am' ? 'አማካሪን ሰርዝ' : 'Delete Mentor'}
                    >
                      <Trash2 size={14} />
                    </button>
                  </div>
                </div>

                {/* Campus & Experience Badges */}
                <div className="flex flex-wrap items-center gap-2 mb-3">
                  <span className="inline-flex items-center gap-1 text-[11px] font-bold px-2.5 py-0.5 rounded-lg bg-indigo-50 dark:bg-indigo-950/50 text-indigo-700 dark:text-indigo-300 border border-indigo-200/60 dark:border-indigo-800">
                    <MapPin size={11} className="text-indigo-500" />
                    <span>{m.campus || 'Atse Fasil Campus'}</span>
                  </span>
                  <span className="inline-flex items-center gap-1 text-[11px] font-semibold px-2 py-0.5 rounded-lg bg-amber-50 dark:bg-amber-950/40 text-amber-700 dark:text-amber-300 border border-amber-200/60 dark:border-amber-800">
                    <Award size={11} className="text-amber-500" />
                    <span>{m.experienceYears ?? 2} yrs • {m.sessionsCount ?? 120}+ sess</span>
                  </span>
                </div>

                {/* Status & Available Hours */}
                <div className="space-y-1.5 mb-3 text-xs">
                  <div className="flex items-center gap-2">
                    <span
                      className={`inline-flex items-center gap-1.5 text-[11px] font-bold px-2 py-0.5 rounded-full ${
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
                    <span className="text-[11px] text-slate-400 dark:text-slate-500 flex items-center gap-1">
                      <Languages size={11} />
                      {(m.languages || []).join(' • ')}
                    </span>
                  </div>

                  <div className="flex items-center gap-1 text-[11px] text-slate-500 dark:text-slate-400">
                    <Clock size={11} className="text-slate-400 flex-shrink-0" />
                    <span className="truncate">
                      {lang === 'am' ? (m.workingHoursAm || m.workingHoursEn || 'ከሰኞ – ዓርብ፡ 2:30 – 11:30') : (m.workingHoursEn || 'Mon – Fri: 8:30 AM – 5:30 PM')}
                    </span>
                  </div>

                  {/* 7-Day Weekly Availability Pills */}
                  <div className="flex items-center gap-1 pt-0.5">
                    {WEEKDAYS.map((w) => {
                      const isEnabled = m.weeklySchedule
                        ? !!m.weeklySchedule[w.key]?.enabled
                        : (w.key !== 'saturday' && w.key !== 'sunday');
                      return (
                        <span
                          key={w.key}
                          title={`${w.labelEn}: ${isEnabled ? 'Active' : 'Off'}`}
                          className={`text-[9px] font-bold px-1.5 py-0.5 rounded transition-all ${
                            isEnabled
                              ? 'bg-brand-50 dark:bg-slate-800 text-brand-700 dark:text-cyan-400 border border-brand-200/60 dark:border-brand-800/60'
                              : 'bg-slate-100 dark:bg-slate-850 text-slate-400 dark:text-slate-600 opacity-60'
                          }`}
                        >
                          {w.short}
                        </span>
                      );
                    })}
                  </div>
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
              <div className="pt-3 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between text-xs gap-2 flex-wrap">
                <a
                  href={`tel:${m.phone}`}
                  className="inline-flex items-center gap-1 font-bold text-slate-700 dark:text-slate-300 hover:text-brand-600 dark:hover:text-cyan-400"
                  title="Direct Phone Call"
                >
                  <Phone size={13} className="text-slate-400" />
                  <span>{m.phone}</span>
                </a>

                <div className="flex items-center gap-2">
                  {m.whatsapp && (
                    <a
                      href={getCleanWhatsappUrl(m.whatsapp) || '#'}
                      target="_blank"
                      rel="noreferrer"
                      className="inline-flex items-center gap-1 font-bold text-emerald-600 dark:text-emerald-400 hover:underline"
                      title={`WhatsApp: ${m.whatsapp}`}
                    >
                      <MessageCircle size={13} />
                      <span>WhatsApp</span>
                    </a>
                  )}
                  {m.telegramHandle && (
                    <a
                      href={getCleanTelegramUrl(m.telegramHandle) || '#'}
                      target="_blank"
                      rel="noreferrer"
                      className="inline-flex items-center gap-1 font-bold text-sky-600 dark:text-sky-400 hover:underline"
                      title={`Telegram: @${m.telegramHandle.replace(/^@+/, '')}`}
                    >
                      <Send size={12} />
                      <span>@{m.telegramHandle.replace(/^@+/, '')}</span>
                    </a>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Enhanced Multi-Section Modal Dialog */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-3 md:p-4">
          <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-2xl w-full max-h-[92vh] overflow-y-auto p-5 md:p-7 animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between pb-4 border-b border-slate-100 dark:border-slate-800 sticky top-0 bg-white/95 dark:bg-slate-900/95 backdrop-blur-xs z-10">
              <div>
                <h3 className="text-lg font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
                  <UserCheck className="text-brand-600 dark:text-cyan-400" size={20} />
                  <span>{editingMentor ? 'Edit Counselor Profile & Campus Sync' : 'Register New Certified Mentor'}</span>
                </h3>
                <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
                  Configure UoG campus, WhatsApp, Telegram, working hours, and biography.
                </p>
              </div>
              <button onClick={() => setIsModalOpen(false)} className="p-1.5 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 cursor-pointer rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800">
                <X size={20} />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="mt-5 space-y-6 text-xs md:text-sm">
              {/* SECTION 1: Personal & Campus Affiliation */}
              <div className="bg-slate-50 dark:bg-slate-850 p-4 rounded-2xl border border-slate-200/70 dark:border-slate-800 space-y-3.5">
                <div className="flex items-center gap-2 text-xs font-bold text-brand-600 dark:text-cyan-400 uppercase tracking-wider">
                  <Building2 size={14} />
                  <span>1. Counselor Identity & Campus Affiliation</span>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-3.5">
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                      Full Name <span className="text-rose-500">*</span>
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.name}
                      onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                      placeholder="e.g. Dr. Hanna Bekele"
                    />
                  </div>

                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                      UoG Campus Affiliation <span className="text-rose-500">*</span>
                    </label>
                    <select
                      value={formData.campus}
                      onChange={(e) => setFormData({ ...formData, campus: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none font-semibold text-xs md:text-sm"
                    >
                      {UOG_CAMPUSES.map((c) => (
                        <option key={c.value} value={c.value}>
                          {c.labelEn}
                        </option>
                      ))}
                    </select>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-3.5">
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                      Professional Role / Title (EN)
                    </label>
                    <input
                      type="text"
                      value={formData.roleTitleEn}
                      onChange={(e) => setFormData({ ...formData, roleTitleEn: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                      placeholder="Certified Youth Peer Counselor"
                    />
                  </div>
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                      Professional Role / Title (AM)
                    </label>
                    <input
                      type="text"
                      value={formData.roleTitleAm}
                      onChange={(e) => setFormData({ ...formData, roleTitleAm: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                      placeholder="የተረጋገጠ የወጣቶች አቻ አማካሪ"
                    />
                  </div>
                </div>

                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    Organization / Center <span className="text-rose-500">*</span>
                  </label>
                  <input
                    type="text"
                    required
                    value={formData.organization}
                    onChange={(e) => setFormData({ ...formData, organization: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="e.g. University of Gondar & Marie Stopes Ethiopia"
                  />
                </div>
              </div>

              {/* SECTION 2: Direct Contact Channels */}
              <div className="bg-slate-50 dark:bg-slate-850 p-4 rounded-2xl border border-slate-200/70 dark:border-slate-800 space-y-3.5">
                <div className="flex items-center gap-2 text-xs font-bold text-brand-600 dark:text-cyan-400 uppercase tracking-wider">
                  <Phone size={14} />
                  <span>2. Direct Contact Channels (Hotline, WhatsApp & Telegram)</span>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-3.5">
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                      Voice Call / Hotline <span className="text-rose-500">*</span>
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.phone}
                      onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                      placeholder="+251913456789"
                    />
                  </div>

                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 flex items-center gap-1.5">
                      <MessageCircle size={14} className="text-emerald-500" />
                      <span>WhatsApp Number or Username</span>
                    </label>
                    <input
                      type="text"
                      value={formData.whatsapp}
                      onChange={(e) => setFormData({ ...formData, whatsapp: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                      placeholder="+251913456789 or username"
                    />
                    <p className="text-[10px] text-slate-400 mt-0.5">Students can click to chat directly via WhatsApp.</p>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-3.5">
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 flex items-center gap-1.5">
                      <Send size={13} className="text-sky-500" />
                      <span>Telegram Handle</span>
                    </label>
                    <div className="relative">
                      <span className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 font-bold">@</span>
                      <input
                        type="text"
                        value={formData.telegramHandle}
                        onChange={(e) => setFormData({ ...formData, telegramHandle: e.target.value.replace(/^@+/, '') })}
                        className="w-full pl-8 pr-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none font-mono text-xs md:text-sm"
                        placeholder="dr_hanna_ms"
                      />
                    </div>
                    <p className="text-[10px] text-slate-400 mt-0.5">No need to type @, it is cleaned automatically.</p>
                  </div>

                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                      Email Address (Optional)
                    </label>
                    <input
                      type="email"
                      value={formData.email}
                      onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                      placeholder="hanna@mariestopes.org.et"
                    />
                  </div>
                </div>
              </div>

              {/* SECTION 3: Experience, Sessions & Weekly Working Hours Schedule */}
              <div className="bg-slate-50 dark:bg-slate-850 p-4 rounded-2xl border border-slate-200/70 dark:border-slate-800 space-y-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2 text-xs font-bold text-brand-600 dark:text-cyan-400 uppercase tracking-wider">
                    <Clock size={14} />
                    <span>3. Experience Credentials & Weekly Availability Schedule</span>
                  </div>
                  <span className="text-[11px] font-semibold text-slate-500 dark:text-slate-400 flex items-center gap-1">
                    <Calendar size={13} className="text-brand-500" />
                    Interactive Day & Time Slot Manager
                  </span>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-3.5">
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                      Years of Experience
                    </label>
                    <input
                      type="number"
                      min={0}
                      value={formData.experienceYears}
                      onChange={(e) => setFormData({ ...formData, experienceYears: Number(e.target.value) })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                      placeholder="2"
                    />
                  </div>

                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                      Total Counseling Sessions Count
                    </label>
                    <input
                      type="number"
                      min={0}
                      value={formData.sessionsCount}
                      onChange={(e) => setFormData({ ...formData, sessionsCount: Number(e.target.value) })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                      placeholder="120"
                    />
                  </div>
                </div>

                {/* Interactive Weekly Schedule Board (Matching Mockup: Calendar & Time Slots) */}
                <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/90 dark:border-slate-750 p-4 shadow-xs space-y-3.5">
                  {/* Presets Bar */}
                  <div className="flex items-center justify-between flex-wrap gap-2 pb-3 border-b border-slate-100 dark:border-slate-800">
                    <span className="text-[11px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider flex items-center gap-1">
                      <Sparkles size={12} className="text-amber-500" />
                      Quick Presets:
                    </span>
                    <div className="flex items-center gap-1.5 flex-wrap">
                      <button
                        type="button"
                        onClick={() => applyPreset('mon_fri')}
                        className="px-2.5 py-1 text-[11px] font-bold bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 rounded-lg transition-all cursor-pointer border border-slate-200 dark:border-slate-700"
                      >
                        Mon – Fri (8:30 – 5:30)
                      </button>
                      <button
                        type="button"
                        onClick={() => applyPreset('mon_sat')}
                        className="px-2.5 py-1 text-[11px] font-bold bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 rounded-lg transition-all cursor-pointer border border-slate-200 dark:border-slate-700"
                      >
                        Mon – Sat (9:00 – 6:00)
                      </button>
                      <button
                        type="button"
                        onClick={() => applyPreset('all')}
                        className="px-2.5 py-1 text-[11px] font-bold bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 rounded-lg transition-all cursor-pointer border border-slate-200 dark:border-slate-700"
                      >
                        All 7 Days
                      </button>
                    </div>
                  </div>

                  {/* 2-Column Calendar & Time Slot Matrix */}
                  <div className="grid grid-cols-1 md:grid-cols-12 gap-4 items-start">
                    {/* Left: Weekday Calendar Matrix (Mo, Tu, We, Th, Fr, Sa, Su) */}
                    <div className="md:col-span-6 space-y-3">
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-bold text-slate-800 dark:text-slate-200">
                          Select Day to Schedule
                        </span>
                        <span className="text-[10px] text-slate-400">
                          Dots indicate active hours
                        </span>
                      </div>

                      {/* Weekday Capsules Row */}
                      <div className="grid grid-cols-7 gap-1.5 p-2 bg-slate-50 dark:bg-slate-800/60 rounded-2xl border border-slate-100 dark:border-slate-800">
                        {WEEKDAYS.map((w) => {
                          const isSelected = activeDayKey === w.key;
                          const isDayEnabled = weeklySchedule[w.key].enabled;
                          return (
                            <button
                              key={w.key}
                              type="button"
                              onClick={() => setActiveDayKey(w.key)}
                              className={`flex flex-col items-center justify-center py-2.5 rounded-xl transition-all cursor-pointer ${
                                isSelected
                                  ? 'bg-slate-900 text-white dark:bg-white dark:text-slate-900 shadow-md font-extrabold scale-102 ring-2 ring-slate-900/10 dark:ring-white/20'
                                  : 'hover:bg-white dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300 font-semibold'
                              }`}
                            >
                              <span className="text-[11px] uppercase tracking-wide">{w.short}</span>
                              <span
                                className={`w-1.5 h-1.5 rounded-full mt-1.5 transition-all ${
                                  isDayEnabled
                                    ? isSelected
                                      ? 'bg-cyan-400 dark:bg-brand-600'
                                      : 'bg-emerald-500'
                                    : 'bg-transparent'
                                }`}
                              />
                            </button>
                          );
                        })}
                      </div>

                      {/* Active Day Status & Toggle Switch */}
                      <div className="flex items-center justify-between p-3 bg-slate-50 dark:bg-slate-800/40 rounded-xl border border-slate-200/60 dark:border-slate-800">
                        <div className="flex items-center gap-2">
                          <label className="text-xs font-bold text-slate-800 dark:text-slate-200">
                            Available on {WEEKDAYS.find((w) => w.key === activeDayKey)?.labelEn}
                          </label>
                          <span
                            className={`text-[10px] font-bold px-1.5 py-0.5 rounded-md ${
                              weeklySchedule[activeDayKey].enabled
                                ? 'bg-emerald-100 dark:bg-emerald-950/60 text-emerald-700 dark:text-emerald-300'
                                : 'bg-slate-200 dark:bg-slate-700 text-slate-500'
                            }`}
                          >
                            {weeklySchedule[activeDayKey].enabled ? 'ACTIVE' : 'OFF'}
                          </span>
                        </div>
                        <input
                          type="checkbox"
                          checked={weeklySchedule[activeDayKey].enabled}
                          onChange={(e) => updateActiveDaySchedule({ enabled: e.target.checked })}
                          className="w-4 h-4 text-brand-600 rounded focus:ring-brand-500 cursor-pointer"
                        />
                      </div>
                    </div>

                    {/* Right: Time Slot Pickers (Start & End Slots) */}
                    <div className="md:col-span-6 space-y-3">
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-bold text-slate-800 dark:text-slate-200">
                          {WEEKDAYS.find((w) => w.key === activeDayKey)?.labelEn} Time Slots
                        </span>
                        {weeklySchedule[activeDayKey].enabled && (
                          <span className="text-[11px] font-semibold text-brand-600 dark:text-cyan-400">
                            {formatTimeLabel(weeklySchedule[activeDayKey].start)} – {formatTimeLabel(weeklySchedule[activeDayKey].end)}
                          </span>
                        )}
                      </div>

                      {weeklySchedule[activeDayKey].enabled ? (
                        <div className="space-y-2.5">
                          <div>
                            <label className="block text-[11px] font-semibold text-slate-500 dark:text-slate-400 mb-1">
                              Session Starts At:
                            </label>
                            <select
                              value={weeklySchedule[activeDayKey].start}
                              onChange={(e) => updateActiveDaySchedule({ start: e.target.value })}
                              className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none font-bold text-xs"
                            >
                              {TIME_SLOTS.map((t) => (
                                <option key={`start_${t.value}`} value={t.value}>
                                  {t.label}
                                </option>
                              ))}
                            </select>
                          </div>

                          <div>
                            <label className="block text-[11px] font-semibold text-slate-500 dark:text-slate-400 mb-1">
                              Session Ends At:
                            </label>
                            <select
                              value={weeklySchedule[activeDayKey].end}
                              onChange={(e) => updateActiveDaySchedule({ end: e.target.value })}
                              className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none font-bold text-xs"
                            >
                              {TIME_SLOTS.map((t) => (
                                <option key={`end_${t.value}`} value={t.value}>
                                  {t.label}
                                </option>
                              ))}
                            </select>
                          </div>
                        </div>
                      ) : (
                        <div className="p-6 bg-slate-50 dark:bg-slate-800/40 rounded-xl border border-dashed border-slate-200 dark:border-slate-700 text-center">
                          <p className="text-xs text-slate-500 dark:text-slate-400">
                            Mentor is marked <span className="font-bold text-rose-500">OFF</span> on this day.
                          </p>
                          <button
                            type="button"
                            onClick={() => updateActiveDaySchedule({ enabled: true })}
                            className="mt-2 text-xs font-bold text-brand-600 dark:text-cyan-400 hover:underline cursor-pointer"
                          >
                            + Enable working hours for {WEEKDAYS.find((w) => w.key === activeDayKey)?.labelEn}
                          </button>
                        </div>
                      )}
                    </div>
                  </div>

                  {/* Bottom Action Bar matching Mockup Footer (Badge & Action Button) */}
                  <div className="flex items-center justify-between flex-wrap gap-2 pt-3 border-t border-slate-100 dark:border-slate-800">
                    <div className="flex items-center gap-2 px-3 py-1.5 bg-slate-100 dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700">
                      <Clock size={13} className="text-brand-500" />
                      <span className="text-xs font-extrabold text-slate-800 dark:text-slate-200">
                        {weeklySchedule[activeDayKey].enabled
                          ? `${WEEKDAYS.find((w) => w.key === activeDayKey)?.labelEn}: ${formatTimeLabel(weeklySchedule[activeDayKey].start)} – ${formatTimeLabel(weeklySchedule[activeDayKey].end)}`
                          : `${WEEKDAYS.find((w) => w.key === activeDayKey)?.labelEn}: Off`}
                      </span>
                    </div>

                    <button
                      type="button"
                      onClick={copyActiveDayToWeekdays}
                      className="px-3 py-1.5 text-xs font-bold text-brand-600 dark:text-cyan-400 hover:bg-brand-50 dark:hover:bg-slate-800 rounded-xl transition-all cursor-pointer border border-brand-200 dark:border-brand-800"
                    >
                      Apply this time to Mon – Fri
                    </button>
                  </div>
                </div>

                {/* Auto-Synchronized Working Hours Summaries for App & Profile */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-3.5 pt-1">
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                      Available Hours Summary (EN)
                    </label>
                    <input
                      type="text"
                      value={formData.workingHoursEn}
                      onChange={(e) => setFormData({ ...formData, workingHoursEn: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                      placeholder="Mon – Fri: 8:30 AM – 5:30 PM"
                    />
                  </div>

                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                      Available Hours Summary (AM)
                    </label>
                    <input
                      type="text"
                      value={formData.workingHoursAm}
                      onChange={(e) => setFormData({ ...formData, workingHoursAm: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                      placeholder="ከሰኞ – ዓርብ፡ 2:30 – 11:30"
                    />
                  </div>
                </div>
              </div>

              {/* SECTION 4: About Counselor Bio & Verification */}
              <div className="bg-slate-50 dark:bg-slate-850 p-4 rounded-2xl border border-slate-200/70 dark:border-slate-800 space-y-3.5">
                <div className="flex items-center gap-2 text-xs font-bold text-brand-600 dark:text-cyan-400 uppercase tracking-wider">
                  <ShieldCheck size={14} />
                  <span>4. Biography & Platform Status</span>
                </div>

                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    About Counselor Bio (EN)
                  </label>
                  <textarea
                    rows={2}
                    value={formData.bioEn}
                    onChange={(e) => setFormData({ ...formData, bioEn: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none resize-none"
                    placeholder="Certified youth mentor offering confidential, stigma-free guidance on emotional wellness and health."
                  />
                </div>

                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    About Counselor Bio (AM)
                  </label>
                  <textarea
                    rows={2}
                    value={formData.bioAm}
                    onChange={(e) => setFormData({ ...formData, bioAm: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none resize-none"
                    placeholder="ሚስጥራዊ፣ ነፃ እና ፍረጃ የሌለበት የስነ-ልቦና እና የስነ-ተዋልዶ ጤና የምክር አገልግሎት የሚሰጥ የተረጋገጠ አቻ አማካሪ።"
                  />
                </div>

                <div className="flex items-center gap-6 pt-2">
                  <label className="flex items-center gap-2 cursor-pointer text-xs font-bold text-slate-700 dark:text-slate-300">
                    <input
                      type="checkbox"
                      checked={formData.isAvailable}
                      onChange={(e) => setFormData({ ...formData, isAvailable: e.target.checked })}
                      className="rounded text-brand-600 focus:ring-brand-500 w-4 h-4 cursor-pointer"
                    />
                    <span>Available Now (Online)</span>
                  </label>
                  <label className="flex items-center gap-2 cursor-pointer text-xs font-bold text-slate-700 dark:text-slate-300">
                    <input
                      type="checkbox"
                      checked={formData.isVerified}
                      onChange={(e) => setFormData({ ...formData, isVerified: e.target.checked })}
                      className="rounded text-brand-600 focus:ring-brand-500 w-4 h-4 cursor-pointer"
                    />
                    <span>Verified Badge</span>
                  </label>
                </div>
              </div>

              {/* SECTION 5: Languages Spoken & Focus Areas / Specialties */}
              <div className="bg-slate-50 dark:bg-slate-850 p-4 rounded-2xl border border-slate-200/70 dark:border-slate-800 space-y-4">
                <div className="flex items-center gap-2 text-xs font-bold text-brand-600 dark:text-cyan-400 uppercase tracking-wider">
                  <Languages size={14} />
                  <span>5. Languages Spoken & Focus Areas</span>
                </div>

                {/* Subsection A: Languages Spoken */}
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1.5 flex items-center justify-between">
                    <span className="flex items-center gap-1.5">
                      <Globe size={13} className="text-brand-500" />
                      <span>Languages Spoken</span>
                    </span>
                    <span className="text-[11px] font-normal text-slate-400">
                      {(formData.languages || []).length} selected
                    </span>
                  </label>

                  {/* Preset Language Chips */}
                  <div className="flex flex-wrap gap-1.5 mb-2.5">
                    {PRESET_LANGUAGES.map((langName) => {
                      const isSelected = (formData.languages || []).includes(langName);
                      return (
                        <button
                          key={langName}
                          type="button"
                          onClick={() => handleToggleLanguage(langName)}
                          className={`px-2.5 py-1 text-xs rounded-lg font-semibold transition-all cursor-pointer flex items-center gap-1 ${
                            isSelected
                              ? 'bg-brand-600 text-white shadow-sm'
                              : 'bg-white dark:bg-slate-800 text-slate-700 dark:text-slate-300 border border-slate-200 dark:border-slate-700 hover:border-brand-300'
                          }`}
                        >
                          {isSelected && <CheckCircle2 size={12} />}
                          <span>{langName}</span>
                        </button>
                      );
                    })}
                  </div>

                  {/* Custom Language Add Input */}
                  <div className="flex gap-2">
                    <input
                      type="text"
                      value={customLanguage}
                      onChange={(e) => setCustomLanguage(e.target.value)}
                      onKeyDown={(e) => {
                        if (e.key === 'Enter') {
                          e.preventDefault();
                          handleAddCustomLanguage();
                        }
                      }}
                      placeholder="Add other language (e.g. Sidama, Gurage, French)..."
                      className="flex-1 px-3 py-1.5 text-xs border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-none"
                    />
                    <button
                      type="button"
                      onClick={handleAddCustomLanguage}
                      className="px-3 py-1.5 text-xs bg-slate-200 dark:bg-slate-700 hover:bg-brand-600 hover:text-white text-slate-700 dark:text-slate-200 font-bold rounded-xl transition-all cursor-pointer flex items-center gap-1"
                    >
                      <Plus size={13} />
                      <span>Add</span>
                    </button>
                  </div>

                  {/* Selected Language Badges */}
                  <div className="flex flex-wrap gap-1.5 mt-2">
                    {(formData.languages || []).map((l) => (
                      <span
                        key={l}
                        className="inline-flex items-center gap-1 px-2.5 py-1 text-xs bg-brand-50 dark:bg-brand-950/40 text-brand-700 dark:text-cyan-300 border border-brand-200 dark:border-brand-800 rounded-lg font-medium"
                      >
                        {l}
                        <button
                          type="button"
                          onClick={() => handleRemoveLanguage(l)}
                          className="hover:text-rose-500 cursor-pointer ml-0.5"
                          title="Remove language"
                        >
                          <X size={12} />
                        </button>
                      </span>
                    ))}
                  </div>
                </div>

                {/* Subsection B: Focus Areas / Specialties */}
                <div className="pt-2 border-t border-slate-200/60 dark:border-slate-800">
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1.5 flex items-center justify-between">
                    <span className="flex items-center gap-1.5">
                      <Tag size={13} className="text-indigo-500" />
                      <span>Focus Areas & Counseling Topics</span>
                    </span>
                    <span className="text-[11px] font-normal text-slate-400">
                      {(formData.specialties || []).length} selected
                    </span>
                  </label>

                  {/* Preset Focus Area Chips */}
                  <div className="flex flex-wrap gap-1.5 mb-2.5">
                    {PRESET_SPECIALTIES.map((spec) => {
                      const isSelected = (formData.specialties || []).includes(spec.tag);
                      return (
                        <button
                          key={spec.tag}
                          type="button"
                          onClick={() => handleToggleSpecialty(spec.tag)}
                          className={`px-2.5 py-1 text-xs rounded-lg font-semibold transition-all cursor-pointer flex items-center gap-1 ${
                            isSelected
                              ? 'bg-indigo-600 text-white shadow-sm'
                              : 'bg-white dark:bg-slate-800 text-slate-700 dark:text-slate-300 border border-slate-200 dark:border-slate-700 hover:border-indigo-300'
                          }`}
                        >
                          {isSelected && <CheckCircle2 size={12} />}
                          <span>{spec.tag}</span>
                          <span className="text-[10px] opacity-75 font-normal">({spec.label.split(' ')[0]})</span>
                        </button>
                      );
                    })}
                  </div>

                  {/* Custom Focus Area Tag Add Input */}
                  <div className="flex gap-2">
                    <input
                      type="text"
                      value={customSpecialty}
                      onChange={(e) => setCustomSpecialty(e.target.value)}
                      onKeyDown={(e) => {
                        if (e.key === 'Enter') {
                          e.preventDefault();
                          handleAddCustomSpecialty();
                        }
                      }}
                      placeholder="Add custom topic (e.g. #AcademicStress, #Nutrition)..."
                      className="flex-1 px-3 py-1.5 text-xs border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-indigo-500 focus:outline-none"
                    />
                    <button
                      type="button"
                      onClick={handleAddCustomSpecialty}
                      className="px-3 py-1.5 text-xs bg-slate-200 dark:bg-slate-700 hover:bg-indigo-600 hover:text-white text-slate-700 dark:text-slate-200 font-bold rounded-xl transition-all cursor-pointer flex items-center gap-1"
                    >
                      <Plus size={13} />
                      <span>Add Tag</span>
                    </button>
                  </div>

                  {/* Selected Topic Badges */}
                  <div className="flex flex-wrap gap-1.5 mt-2">
                    {(formData.specialties || []).map((s) => (
                      <span
                        key={s}
                        className="inline-flex items-center gap-1 px-2.5 py-1 text-xs bg-indigo-50 dark:bg-indigo-950/40 text-indigo-700 dark:text-indigo-300 border border-indigo-200 dark:border-indigo-800 rounded-lg font-bold font-mono"
                      >
                        {s}
                        <button
                          type="button"
                          onClick={() => handleRemoveSpecialty(s)}
                          className="hover:text-rose-500 cursor-pointer ml-0.5"
                          title="Remove topic"
                        >
                          <X size={12} />
                        </button>
                      </span>
                    ))}
                  </div>
                </div>
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-slate-100 dark:border-slate-800">
                <button
                  type="button"
                  disabled={isSubmitting}
                  onClick={() => setIsModalOpen(false)}
                  className="px-4 py-2 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 font-bold rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800 disabled:opacity-50 disabled:cursor-not-allowed cursor-pointer transition-all"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="px-6 py-2 bg-brand-600 hover:bg-brand-700 disabled:opacity-50 disabled:cursor-not-allowed text-white font-bold rounded-xl shadow-md cursor-pointer transition-all flex items-center gap-2"
                >
                  {isSubmitting && <Loader2 size={16} className="animate-spin" />}
                  <span>{isSubmitting ? (lang === 'am' ? 'በማስቀመጥ ላይ...' : 'Saving...') : (lang === 'am' ? 'አማካሪን አስቀምጥ' : 'Save Counselor Profile')}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      <ConfirmModal
        isOpen={Boolean(mentorToDelete)}
        onClose={() => setMentorToDelete(null)}
        onConfirm={async () => {
          if (mentorToDelete) {
            await onDelete(mentorToDelete.id);
          }
        }}
        title={lang === 'am' ? 'የወጣቶች አማካሪው ይሰረዝ?' : 'Delete Youth Peer Counselor?'}
        itemName={mentorToDelete?.name || ''}
        message={
          lang === 'am'
            ? 'ይህ አማካሪ ከሲስተሙ በቋሚነት ይሰረዛል። ተማሪዎች ይህንን አማካሪ በቴሌግራም ወይም በስልክ ማግኘት አይችሉም።'
            : 'This certified peer counselor will be removed from the active directory. Students will no longer see their contact handle or hotline.'
        }
        lang={lang}
      />
    </div>
  );
};
