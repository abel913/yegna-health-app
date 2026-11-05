import React, { useState, useEffect, useRef, useMemo } from 'react';
import {
  Search,
  LayoutDashboard,
  Hospital,
  Users2,
  BookOpen,
  HelpCircle,
  GraduationCap,
  ShieldAlert,
  History,
  LogOut,
  Globe,
  CornerDownLeft,
  X,
  FileSpreadsheet,
  PlusCircle,
} from 'lucide-react';
import { Facility, Mentor, Module, StudentClub } from '../types/index.js';

export interface CommandPaletteProps {
  isOpen: boolean;
  onClose: () => void;
  currentTab: string;
  onNavigate: (tabId: string) => void;
  lang: 'en' | 'am';
  onToggleLang: () => void;
  onLogout: () => void;
  facilities?: Facility[];
  mentors?: Mentor[];
  modules?: Module[];
  clubs?: StudentClub[];
  onOpenAddFacility?: () => void;
  onExportCsv?: () => void;
}

interface PaletteItem {
  id: string;
  groupId: 'navigation' | 'actions' | 'facilities' | 'modules' | 'mentors' | 'clubs';
  groupLabel: string;
  title: string;
  subtitle?: string;
  badge?: string;
  icon: React.ComponentType<{ size?: number; className?: string }>;
  iconBgColor: string;
  iconColor: string;
  onSelect: () => void;
}

export const CommandPalette: React.FC<CommandPaletteProps> = ({
  isOpen,
  onClose,
  onNavigate,
  lang,
  onToggleLang,
  onLogout,
  facilities = [],
  mentors = [],
  modules = [],
  clubs = [],
  onOpenAddFacility,
  onExportCsv,
}) => {
  const [query, setQuery] = useState('');
  const [selectedIndex, setSelectedIndex] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);
  const listRef = useRef<HTMLDivElement>(null);

  // Focus input when opened & reset search
  useEffect(() => {
    if (isOpen) {
      setQuery('');
      setSelectedIndex(0);
      setTimeout(() => {
        inputRef.current?.focus();
      }, 50);
    }
  }, [isOpen]);

  // Construct items
  const allItems: PaletteItem[] = useMemo(() => {
    const items: PaletteItem[] = [];

    // 1. Navigation Pages
    const pages = [
      {
        id: 'nav-dashboard',
        tab: 'dashboard',
        title: lang === 'am' ? 'ዳሽቦርድ' : 'Dashboard Overview',
        subtitle: lang === 'am' ? 'የመድረኩ ጠቅላላ መረጃና ስታቲስቲክስ' : 'Platform KPIs, visual trends & live activity',
        icon: LayoutDashboard,
      },
      {
        id: 'nav-facilities',
        tab: 'facilities',
        title: lang === 'am' ? 'የጤና ተቋማትና ክሊኒኮች' : 'Health Clinics & Facilities',
        subtitle: lang === 'am' ? 'የጎንደር ዩኒቨርሲቲና የክልል ጤና ጣቢያዎች' : 'UoG campuses & regional youth clinics',
        icon: Hospital,
      },
      {
        id: 'nav-mentors',
        tab: 'mentors',
        title: lang === 'am' ? 'አማካሪዎችና ባለሙያዎች' : 'Peer Mentors & Counselors',
        subtitle: lang === 'am' ? 'የስነ-አዕምሮና የወጣቶች ጤና አማካሪዎች' : 'Verified youth counselors & availability',
        icon: Users2,
      },
      {
        id: 'nav-modules',
        tab: 'modules',
        title: lang === 'am' ? 'የትምህርት ሞጁሎች CMS' : 'Learning Curriculum CMS',
        subtitle: lang === 'am' ? 'ባለ ሁለት ቋንቋ የጤና ትምህርቶች' : 'Bilingual health education & live markdown preview',
        icon: BookOpen,
      },
      {
        id: 'nav-quizzes',
        tab: 'quizzes',
        title: lang === 'am' ? 'ፈተናዎችና ምዘናዎች' : 'Quizzes & Clinical Assessments',
        subtitle: lang === 'am' ? 'የተማሪዎች እውቀት መመዘኛ ጥያቄዎች' : 'Interactive multiple-choice tests with doctor notes',
        icon: HelpCircle,
      },
      {
        id: 'nav-clubs',
        tab: 'clubs',
        title: lang === 'am' ? 'የተማሪዎች ጤና ክለቦች' : 'Student Health Clubs',
        subtitle: lang === 'am' ? 'የካምፓስ ወጣቶች ክለቦችና አባላት' : 'Campus chapters, member rosters & approval',
        icon: GraduationCap,
      },
      {
        id: 'nav-users',
        tab: 'users',
        title: lang === 'am' ? 'የተጠቃሚዎች ደህንነት ቁጥጥር' : 'User Governance & Roles',
        subtitle: lang === 'am' ? 'ሚና ማሳደግ፣ ፍለጋና እገዳ' : 'Search, role elevation, suspension & Zero-Knowledge privacy',
        icon: ShieldAlert,
      },
      {
        id: 'nav-audit',
        tab: 'audit',
        title: lang === 'am' ? 'የኦዲትና ቁጥጥር መዝገብ' : 'Immutable Audit Logs',
        subtitle: lang === 'am' ? 'የአስተዳዳሪዎች እንቅስቃሴ ታሪክ' : 'Traceable administrative history trail',
        icon: History,
      },
    ];

    pages.forEach((p) => {
      items.push({
        id: p.id,
        groupId: 'navigation',
        groupLabel: lang === 'am' ? 'ገጾችና ክፍሎች' : 'Navigation Pages',
        title: p.title,
        subtitle: p.subtitle,
        badge: lang === 'am' ? 'ገጽ' : 'Page',
        icon: p.icon,
        iconBgColor: 'bg-brand-50 text-brand-600',
        iconColor: 'text-brand-600',
        onSelect: () => {
          onNavigate(p.tab);
          onClose();
        },
      });
    });

    // 2. Global Actions
    items.push({
      id: 'act-lang',
      groupId: 'actions',
      groupLabel: lang === 'am' ? 'ፈጣን ትዕዛዛት' : 'Quick Actions',
      title: lang === 'am' ? 'ወደ እንግሊዝኛ ቀይር (Switch to English)' : 'Switch to Amharic (ወደ አማርኛ ቀይር)',
      subtitle: lang === 'am' ? 'የሲስተሙን ቋንቋ ወደ እንግሊዝኛ ይቀይራል' : 'Switch admin portal UI language to Amharic',
      badge: 'Language',
      icon: Globe,
      iconBgColor: 'bg-emerald-50 text-emerald-600',
      iconColor: 'text-emerald-600',
      onSelect: () => {
        onToggleLang();
        onClose();
      },
    });

    if (onOpenAddFacility) {
      items.push({
        id: 'act-add-facility',
        groupId: 'actions',
        groupLabel: lang === 'am' ? 'ፈጣን ትዕዛዛት' : 'Quick Actions',
        title: lang === 'am' ? 'አዲስ የጤና ተቋም መዝግብ' : 'Add New Health Facility',
        subtitle: lang === 'am' ? 'የጎንደር ዩኒቨርሲቲ ወይም የክልል ክሊኒክ ያክሉ' : 'Register UoG campus clinic or regional youth center',
        badge: 'Create',
        icon: PlusCircle,
        iconBgColor: 'bg-cyan-50 text-cyan-600',
        iconColor: 'text-cyan-600',
        onSelect: () => {
          onNavigate('facilities');
          onOpenAddFacility();
          onClose();
        },
      });
    }

    if (onExportCsv) {
      items.push({
        id: 'act-export-csv',
        groupId: 'actions',
        groupLabel: lang === 'am' ? 'ፈጣን ትዕዛዛት' : 'Quick Actions',
        title: lang === 'am' ? 'የመድረኩን ሪፖርት አውርድ (CSV)' : 'Export Platform Report (CSV)',
        subtitle: lang === 'am' ? 'ለዩኒቨርሲቲና ለለጋሾች የሚሆን ኤክሴል ፋይል' : 'Download comprehensive institutional summary for Excel',
        badge: 'Excel CSV',
        icon: FileSpreadsheet,
        iconBgColor: 'bg-emerald-50 text-emerald-600',
        iconColor: 'text-emerald-600',
        onSelect: () => {
          onExportCsv();
          onClose();
        },
      });
    }

    items.push({
      id: 'act-logout',
      groupId: 'actions',
      groupLabel: lang === 'am' ? 'ፈጣን ትዕዛዛት' : 'Quick Actions',
      title: lang === 'am' ? 'ከሲስተሙ ውጣ (Sign Out)' : 'Sign Out of Admin Portal',
      subtitle: lang === 'am' ? 'የአስተዳዳሪ ክፍለ-ጊዜን ያቋርጣል' : 'End current administrative session securely',
      badge: 'Auth',
      icon: LogOut,
      iconBgColor: 'bg-rose-50 text-rose-600',
      iconColor: 'text-rose-600',
      onSelect: () => {
        onLogout();
        onClose();
      },
    });

    // 3. Searchable Clinics / Facilities
    facilities.forEach((f) => {
      items.push({
        id: `fac-${f.id}`,
        groupId: 'facilities',
        groupLabel: lang === 'am' ? 'የጤና ተቋማት' : 'Healthcare Clinics',
        title: lang === 'am' ? f.nameAm || f.nameEn : f.nameEn,
        subtitle: `${f.subCity} • ${f.phone || 'No phone'}`,
        badge: f.subCity,
        icon: Hospital,
        iconBgColor: 'bg-blue-50 text-blue-600',
        iconColor: 'text-blue-600',
        onSelect: () => {
          onNavigate('facilities');
          onClose();
        },
      });
    });

    // 4. Searchable Learning Modules
    modules.forEach((m) => {
      items.push({
        id: `mod-${m.id}`,
        groupId: 'modules',
        groupLabel: lang === 'am' ? 'የትምህርት ሞጁሎች' : 'Learning Curriculum',
        title: lang === 'am' ? m.titleAm || m.titleEn : m.titleEn,
        subtitle: `${m.category.toUpperCase()} • ${m.readTimeMin} min read`,
        badge: m.category.toUpperCase(),
        icon: BookOpen,
        iconBgColor: 'bg-purple-50 text-purple-600',
        iconColor: 'text-purple-600',
        onSelect: () => {
          onNavigate('modules');
          onClose();
        },
      });
    });

    // 5. Searchable Mentors
    mentors.forEach((men) => {
      items.push({
        id: `men-${men.id}`,
        groupId: 'mentors',
        groupLabel: lang === 'am' ? 'አማካሪዎች' : 'Peer Mentors',
        title: men.name,
        subtitle: `${men.organization} • ${men.phone}`,
        badge: men.isAvailable ? 'Available' : 'Busy',
        icon: Users2,
        iconBgColor: 'bg-amber-50 text-amber-600',
        iconColor: 'text-amber-600',
        onSelect: () => {
          onNavigate('mentors');
          onClose();
        },
      });
    });

    // 6. Searchable Student Clubs
    clubs.forEach((c) => {
      items.push({
        id: `club-${c.id}`,
        groupId: 'clubs',
        groupLabel: lang === 'am' ? 'የተማሪዎች ክለቦች' : 'Student Clubs',
        title: c.name,
        subtitle: `${c.venue || 'Campus'} • ${c.category}`,
        badge: c.isApproved ? 'Approved' : 'Pending',
        icon: GraduationCap,
        iconBgColor: 'bg-emerald-50 text-emerald-600',
        iconColor: 'text-emerald-600',
        onSelect: () => {
          onNavigate('clubs');
          onClose();
        },
      });
    });

    return items;
  }, [
    lang,
    facilities,
    modules,
    mentors,
    clubs,
    onNavigate,
    onToggleLang,
    onLogout,
    onOpenAddFacility,
    onExportCsv,
    onClose,
  ]);

  // Filter items according to search query
  const filteredItems = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) {
      // Default initial view: show Navigation and Actions
      return allItems.filter((i) => i.groupId === 'navigation' || i.groupId === 'actions');
    }
    return allItems.filter((item) => {
      const matchTitle = item.title.toLowerCase().includes(q);
      const matchSub = item.subtitle?.toLowerCase().includes(q);
      const matchBadge = item.badge?.toLowerCase().includes(q);
      const matchGroup = item.groupLabel.toLowerCase().includes(q);
      return matchTitle || matchSub || matchBadge || matchGroup;
    });
  }, [allItems, query]);

  // Reset selected index when filtered items change
  useEffect(() => {
    setSelectedIndex(0);
  }, [filteredItems.length]);

  // Handle keyboard navigation
  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      setSelectedIndex((prev) => (filteredItems.length > 0 ? (prev + 1) % filteredItems.length : 0));
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      setSelectedIndex((prev) =>
        filteredItems.length > 0 ? (prev - 1 + filteredItems.length) % filteredItems.length : 0
      );
    } else if (e.key === 'Enter') {
      e.preventDefault();
      if (filteredItems[selectedIndex]) {
        filteredItems[selectedIndex].onSelect();
      }
    } else if (e.key === 'Escape') {
      e.preventDefault();
      onClose();
    }
  };

  // Group filtered items for clean visual sectioning
  const groupedResults = useMemo(() => {
    const groups: { [key: string]: { label: string; items: { item: PaletteItem; flatIndex: number }[] } } = {};

    filteredItems.forEach((item, flatIndex) => {
      if (!groups[item.groupId]) {
        groups[item.groupId] = {
          label: item.groupLabel,
          items: [],
        };
      }
      groups[item.groupId].items.push({ item, flatIndex });
    });

    return Object.values(groups);
  }, [filteredItems]);

  if (!isOpen) return null;

  return (
    <div
      className="fixed inset-0 z-50 flex items-start justify-center pt-16 md:pt-24 px-4 bg-slate-900/50 backdrop-blur-sm animate-in fade-in duration-150"
      onClick={onClose}
    >
      <div
        className="w-full max-w-2xl bg-white rounded-2xl shadow-2xl border border-slate-200 overflow-hidden animate-in zoom-in-95 duration-150 flex flex-col max-h-[80vh]"
        onClick={(e) => e.stopPropagation()}
        onKeyDown={handleKeyDown}
      >
        {/* Search Input Bar */}
        <div className="relative flex items-center px-4 py-3.5 border-b border-slate-100 bg-white">
          <Search size={20} className="text-slate-400 mr-3 flex-shrink-0" />
          <input
            ref={inputRef}
            type="text"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder={
              lang === 'am'
                ? 'ገጽ፣ ክሊኒክ፣ ሞጁል ወይም ትዕዛዝ ፈልግ... (ለምሳሌ: Gondar, SRH, ክሊኒክ)'
                : 'Search pages, facilities, modules, actions... (e.g. Gondar, SRH, Clinics)'
            }
            className="w-full text-sm font-semibold text-slate-800 placeholder:text-slate-400 bg-transparent border-none outline-none"
          />
          {query ? (
            <button
              onClick={() => {
                setQuery('');
                inputRef.current?.focus();
              }}
              className="p-1 text-slate-400 hover:text-slate-600 rounded-md hover:bg-slate-100 mr-2 transition-colors"
            >
              <X size={16} />
            </button>
          ) : null}
          <kbd
            onClick={onClose}
            className="hidden sm:inline-flex items-center px-2 py-0.5 rounded-md bg-slate-100 border border-slate-200 text-[10px] font-bold text-slate-500 shadow-2xs cursor-pointer hover:bg-slate-200 transition-colors"
          >
            ESC
          </kbd>
        </div>

        {/* Scrollable Results List */}
        <div ref={listRef} className="overflow-y-auto p-2 divide-y divide-slate-50 flex-1">
          {filteredItems.length === 0 ? (
            <div className="py-12 px-6 text-center">
              <div className="w-12 h-12 rounded-2xl bg-slate-100 text-slate-400 flex items-center justify-center mx-auto mb-3">
                <Search size={22} />
              </div>
              <p className="text-sm font-bold text-slate-800">
                {lang === 'am' ? `ምንም አልተገኘም "${query}"` : `No results found for "${query}"`}
              </p>
              <p className="text-xs text-slate-400 mt-1 max-w-sm mx-auto">
                {lang === 'am'
                  ? 'እባክዎ የተለየ ቃል፣ የካምፓስ ስም (Gondar) ወይም የትምህርት ርዕስ ይሞክሩ።'
                  : 'Try searching for campus names like "Maraki", topics like "SRH", or navigation tabs.'}
              </p>
            </div>
          ) : (
            groupedResults.map((group) => (
              <div key={group.label} className="py-1.5 first:pt-0 last:pb-0">
                <div className="px-3 py-1 text-[10px] font-extrabold uppercase tracking-wider text-slate-400">
                  {group.label}
                </div>
                <div className="space-y-0.5 mt-0.5">
                  {group.items.map(({ item, flatIndex }) => {
                    const isSelected = flatIndex === selectedIndex;
                    const Icon = item.icon;
                    return (
                      <div
                        key={item.id}
                        onClick={item.onSelect}
                        onMouseEnter={() => setSelectedIndex(flatIndex)}
                        className={`flex items-center justify-between px-3 py-2 rounded-xl text-xs cursor-pointer transition-all ${
                          isSelected
                            ? 'bg-slate-100/90 text-slate-900 font-semibold shadow-2xs'
                            : 'text-slate-600 hover:bg-slate-50'
                        }`}
                      >
                        <div className="flex items-center gap-3 min-w-0 flex-1">
                          <div
                            className={`w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0 ${item.iconBgColor}`}
                          >
                            <Icon size={16} />
                          </div>
                          <div className="min-w-0 flex-1">
                            <p className="text-xs font-bold text-slate-900 truncate">{item.title}</p>
                            {item.subtitle && (
                              <p className="text-[11px] text-slate-400 truncate">{item.subtitle}</p>
                            )}
                          </div>
                        </div>

                        <div className="flex items-center gap-2 flex-shrink-0 ml-3">
                          {item.badge && (
                            <span className="px-2 py-0.5 rounded-md bg-slate-100 text-slate-600 font-bold text-[10px] border border-slate-200/60">
                              {item.badge}
                            </span>
                          )}
                          {isSelected && (
                            <div className="hidden sm:flex items-center gap-1 text-[11px] font-bold text-brand-600">
                              <span>Select</span>
                              <CornerDownLeft size={12} />
                            </div>
                          )}
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            ))
          )}
        </div>

        {/* Footer Keyboard Guide */}
        <div className="px-4 py-2.5 bg-slate-50 border-t border-slate-100 flex items-center justify-between text-[11px] text-slate-500 font-medium">
          <div className="flex items-center gap-4">
            <span className="inline-flex items-center gap-1">
              <kbd className="px-1.5 py-0.5 rounded bg-white border border-slate-200 text-[10px] font-bold text-slate-600 shadow-2xs">
                ↑
              </kbd>
              <kbd className="px-1.5 py-0.5 rounded bg-white border border-slate-200 text-[10px] font-bold text-slate-600 shadow-2xs">
                ↓
              </kbd>
              <span className="ml-0.5">{lang === 'am' ? 'ለማሰስ' : 'to navigate'}</span>
            </span>
            <span className="inline-flex items-center gap-1">
              <kbd className="px-1.5 py-0.5 rounded bg-white border border-slate-200 text-[10px] font-bold text-slate-600 shadow-2xs">
                ↵
              </kbd>
              <span className="ml-0.5">{lang === 'am' ? 'ለመምረጥ' : 'to select'}</span>
            </span>
            <span className="hidden sm:inline-flex items-center gap-1">
              <kbd className="px-1.5 py-0.5 rounded bg-white border border-slate-200 text-[10px] font-bold text-slate-600 shadow-2xs">
                esc
              </kbd>
              <span className="ml-0.5">{lang === 'am' ? 'ለመዝጋት' : 'to close'}</span>
            </span>
          </div>

          <div className="text-[10px] font-semibold text-slate-400">
            Yegna Health Spotlight v2.0
          </div>
        </div>
      </div>
    </div>
  );
};
