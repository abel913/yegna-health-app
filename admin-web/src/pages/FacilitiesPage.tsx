import React, { useState, useMemo, useEffect, useRef } from 'react';
import {
  Plus,
  Search,
  CheckCircle2,
  Phone,
  MapPin,
  Edit2,
  Trash2,
  X,
  GraduationCap,
  Building2,
  Download,
  Stethoscope,
  HeartHandshake,
  BookOpen,
  Dumbbell,
  Accessibility,
  Clock,
  Lock,
  UserCheck,
  ChevronDown,
  Check,
  RotateCcw,
} from 'lucide-react';
import { Facility, FacilityCategory } from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';
import { SortableHeader, SortOrder } from '../components/common/SortableHeader.js';
import { EmptyState } from '../components/common/EmptyState.js';
import { ConfirmModal } from '../components/common/ConfirmModal.js';
import { CampusMapPicker } from '../components/common/CampusMapPicker.js';
import { TagInputManager } from '../components/common/TagInputManager.js';
import { TableSkeleton } from '../components/common/TableSkeleton.js';

interface FacilitiesPageProps {
  facilities: Facility[];
  lang: 'en' | 'am';
  isLoading?: boolean;
  onSave: (data: Partial<Facility>, id?: string) => Promise<void>;
  onDelete: (id: string) => Promise<void>;
}

export interface LocationPreset {
  id: string;
  nameEn: string;
  nameAm: string;
  defaultLat: number;
  defaultLng: number;
}

export const LOCATION_PRESETS: LocationPreset[] = [
  { id: 'UoG - Maraki Campus', nameEn: 'UoG - Maraki Campus', nameAm: 'ዩኦጂ ማራኪ ካምፓስ', defaultLat: 12.6075, defaultLng: 37.4589 },
  { id: 'UoG - Atse Tewodros Campus', nameEn: 'UoG - Atse Tewodros Campus', nameAm: 'ዩኦጂ አፄ ቴዎድሮስ ካምፓስ', defaultLat: 12.6092, defaultLng: 37.4611 },
  { id: 'UoG - GCMS Referral Hospital', nameEn: 'UoG - GCMS Referral Hospital / CMHS', nameAm: 'ዩኦጂ ሪፈራል ሆስፒታል / CMHS', defaultLat: 12.6033, defaultLng: 37.4522 },
  { id: 'UoG - Fasil Campus', nameEn: 'UoG - Fasil Campus', nameAm: 'ዩኦጂ ፋሲል ካምፓስ', defaultLat: 12.6135, defaultLng: 37.4720 },
  { id: 'UoG - Tseda Campus', nameEn: 'UoG - Tseda Campus', nameAm: 'ዩኦጂ ጼዳ ካምፓስ', defaultLat: 12.5312, defaultLng: 37.4728 },
];

export const FACILITY_CATEGORIES: {
  id: FacilityCategory;
  nameEn: string;
  nameAm: string;
  icon: any;
}[] = [
  { id: 'clinical', nameEn: 'Health & Clinic', nameAm: 'ጤና እና ክሊኒክ', icon: Stethoscope },
  { id: 'counseling', nameEn: 'Counseling & Guidance', nameAm: 'ምክር እና ስነ-ልቦና', icon: HeartHandshake },
  { id: 'academic', nameEn: 'Academic & Library', nameAm: 'ትምህርትና ቤተ-መጽሐፍት', icon: BookOpen },
  { id: 'student_affairs', nameEn: 'Student Affairs', nameAm: 'የተማሪዎች አገልግሎት', icon: Building2 },
  { id: 'sports_dining', nameEn: 'Sports & Dining', nameAm: 'ስፖርትና ካፌ', icon: Dumbbell },
  { id: 'accessibility', nameEn: 'Accessibility & Support', nameAm: 'ማካተትና ልዩ ድጋፍ', icon: Accessibility },
];

const HOURS_PRESETS = ['Open 24/7', '08:00 - 18:00', '08:30 - 17:30', '08:00 - 20:00', '09:00 - 17:00'];

export const FacilitiesPage: React.FC<FacilitiesPageProps> = ({
  facilities,
  lang,
  isLoading = false,
  onSave,
  onDelete,
}) => {
  const [search, setSearch] = useState('');
  const [selectedCampus, setSelectedCampus] = useState('All');
  const [selectedCategory, setSelectedCategory] = useState<string>('All');
  const [activeDropdown, setActiveDropdown] = useState<'campus' | 'category' | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingFacility, setEditingFacility] = useState<Facility | null>(null);
  const [facilityToDelete, setFacilityToDelete] = useState<Facility | null>(null);

  const campusDropdownRef = useRef<HTMLDivElement>(null);
  const categoryDropdownRef = useRef<HTMLDivElement>(null);
  const searchInputRef = useRef<HTMLInputElement>(null);

  // Close dropdowns on click outside & support Escape and / keyboard shortcuts
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      const target = event.target as Node;
      if (
        campusDropdownRef.current &&
        !campusDropdownRef.current.contains(target) &&
        categoryDropdownRef.current &&
        !categoryDropdownRef.current.contains(target)
      ) {
        setActiveDropdown(null);
      }
    };

    const handleGlobalKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        setActiveDropdown(null);
      } else if (
        event.key === '/' &&
        document.activeElement?.tagName !== 'INPUT' &&
        document.activeElement?.tagName !== 'TEXTAREA'
      ) {
        event.preventDefault();
        searchInputRef.current?.focus();
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    window.addEventListener('keydown', handleGlobalKeyDown);
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
      window.removeEventListener('keydown', handleGlobalKeyDown);
    };
  }, []);

  // Lock body scroll when modal is open and handle Escape key
  useEffect(() => {
    if (isModalOpen) {
      document.body.style.overflow = 'hidden';
      const handleKeyDown = (e: KeyboardEvent) => {
        if (e.key === 'Escape') {
          setIsModalOpen(false);
        }
      };
      window.addEventListener('keydown', handleKeyDown);
      return () => {
        document.body.style.overflow = '';
        window.removeEventListener('keydown', handleKeyDown);
      };
    } else {
      document.body.style.overflow = '';
    }
  }, [isModalOpen]);

  // Form State
  const [formData, setFormData] = useState({
    nameEn: '',
    nameAm: '',
    category: 'clinical' as FacilityCategory,
    subCity: 'UoG - Maraki Campus',
    customSubCity: '',
    woreda: 'Student Health Wing',
    buildingEn: '',
    buildingAm: '',
    landmarkEn: '',
    landmarkAm: '',
    focalPerson: '',
    focalPhone: '',
    telegramHandle: '',
    addressEn: '',
    addressAm: '',
    phone: '+251',
    latitude: 12.6075,
    longitude: 37.4589,
    operatingHours: '08:30 - 17:30',
    isVerified: true,
    isWheelchairAccessible: false,
    hasPrivateRoom: false,
    services: ['#Health_Clinic', '#Youth_Friendly', '#SRH_Counseling'],
  });

  const [isCustomLocation, setIsCustomLocation] = useState(false);

  const matchesCampusPredicate = (f: Facility, campusId: string) => {
    if (campusId === 'All') return true;
    const sc = f.subCity.toLowerCase();
    const target = campusId.toLowerCase();
    return (
      sc === target ||
      (target.includes('maraki') && sc.includes('maraki')) ||
      (target.includes('tewodros') && sc.includes('tewodros')) ||
      (target.includes('gcms') && (sc.includes('gcms') || sc.includes('hospital') || sc.includes('cmhs'))) ||
      (target.includes('fasil') && sc.includes('fasil')) ||
      (target.includes('tseda') && sc.includes('tseda'))
    );
  };

  const campusCounts = useMemo(() => {
    const counts: Record<string, number> = { All: facilities.length };
    for (const preset of LOCATION_PRESETS) {
      counts[preset.id] = facilities.filter((f) => matchesCampusPredicate(f, preset.id)).length;
    }
    return counts;
  }, [facilities]);

  const categoryCounts = useMemo(() => {
    const counts: Record<string, number> = { All: facilities.length };
    for (const cat of FACILITY_CATEGORIES) {
      counts[cat.id] = facilities.filter((f) => (f.category || 'clinical') === cat.id).length;
    }
    return counts;
  }, [facilities]);

  const activeCampusPreset = LOCATION_PRESETS.find((p) => p.id === selectedCampus);
  const activeCampusLabel =
    selectedCampus === 'All'
      ? lang === 'am'
        ? 'ሁሉም ካምፓሶች'
        : 'All Campuses'
      : lang === 'am'
      ? activeCampusPreset?.nameAm || selectedCampus
      : activeCampusPreset?.nameEn || selectedCampus;

  const activeCategoryPreset = FACILITY_CATEGORIES.find((c) => c.id === selectedCategory);
  const ActiveCategoryIcon = activeCategoryPreset ? activeCategoryPreset.icon : Building2;
  const activeCategoryLabel =
    selectedCategory === 'All'
      ? lang === 'am'
        ? 'ሁሉም ዘርፎች'
        : 'All Categories'
      : lang === 'am'
      ? activeCategoryPreset?.nameAm || selectedCategory
      : activeCategoryPreset?.nameEn || selectedCategory;

  const hasActiveFilters = search.trim().length > 0 || selectedCampus !== 'All' || selectedCategory !== 'All';
  const handleResetFilters = () => {
    setSearch('');
    setSelectedCampus('All');
    setSelectedCategory('All');
  };

  const filtered = facilities.filter((f) => {
    const matchesSearch =
      f.nameEn.toLowerCase().includes(search.toLowerCase()) ||
      f.nameAm.includes(search) ||
      f.subCity.toLowerCase().includes(search.toLowerCase()) ||
      (f.addressEn && f.addressEn.toLowerCase().includes(search.toLowerCase())) ||
      (f.addressAm && f.addressAm.includes(search)) ||
      (f.buildingEn && f.buildingEn.toLowerCase().includes(search.toLowerCase())) ||
      (f.landmarkEn && f.landmarkEn.toLowerCase().includes(search.toLowerCase())) ||
      (f.focalPerson && f.focalPerson.toLowerCase().includes(search.toLowerCase())) ||
      (f.services && f.services.some((s) => s.toLowerCase().includes(search.toLowerCase())));

    const matchesCampus = matchesCampusPredicate(f, selectedCampus);

    let matchesCategory = true;
    if (selectedCategory !== 'All') {
      matchesCategory = (f.category || 'clinical') === selectedCategory;
    }

    return matchesSearch && matchesCampus && matchesCategory;
  });

  const [sortField, setSortField] = useState<string>('name');
  const [sortOrder, setSortOrder] = useState<SortOrder>('asc');

  const handleSort = (field: string) => {
    if (sortField === field) {
      if (sortOrder === 'asc') setSortOrder('desc');
      else if (sortOrder === 'desc') setSortOrder(null);
      else setSortOrder('asc');
    } else {
      setSortField(field);
      setSortOrder('asc');
    }
  };

  const sortedFacilities = useMemo(() => {
    if (!sortOrder) return filtered;
    return [...filtered].sort((a, b) => {
      let valA: any = '';
      let valB: any = '';
      if (sortField === 'name') {
        valA = lang === 'am' ? a.nameAm || a.nameEn : a.nameEn;
        valB = lang === 'am' ? b.nameAm || b.nameEn : b.nameEn;
      } else if (sortField === 'subCity') {
        valA = a.subCity.toLowerCase();
        valB = b.subCity.toLowerCase();
      } else if (sortField === 'phone') {
        valA = a.phone || '';
        valB = b.phone || '';
      } else if (sortField === 'status') {
        valA = a.isVerified ? 1 : 0;
        valB = b.isVerified ? 1 : 0;
      }
      if (valA < valB) return sortOrder === 'asc' ? -1 : 1;
      if (valA > valB) return sortOrder === 'asc' ? 1 : -1;
      return 0;
    });
  }, [filtered, sortField, sortOrder, lang]);

  const openCreateModal = () => {
    setEditingFacility(null);
    setIsCustomLocation(false);
    setFormData({
      nameEn: '',
      nameAm: '',
      category: 'clinical',
      subCity: 'UoG - Maraki Campus',
      customSubCity: '',
      woreda: 'Student Health Wing',
      buildingEn: '',
      buildingAm: '',
      landmarkEn: '',
      landmarkAm: '',
      focalPerson: '',
      focalPhone: '',
      telegramHandle: '',
      addressEn: '',
      addressAm: '',
      phone: '+251',
      latitude: 12.6075,
      longitude: 37.4589,
      operatingHours: '08:30 - 17:30',
      isVerified: true,
      isWheelchairAccessible: false,
      hasPrivateRoom: false,
      services: ['#Health_Clinic', '#Youth_Friendly', '#SRH_Counseling'],
    });
    setIsModalOpen(true);
  };

  const openEditModal = (f: Facility) => {
    setEditingFacility(f);
    const isKnownPreset = LOCATION_PRESETS.some((p) => p.id === f.subCity);
    setIsCustomLocation(!isKnownPreset);
    setFormData({
      nameEn: f.nameEn,
      nameAm: f.nameAm,
      category: f.category || 'clinical',
      subCity: isKnownPreset ? f.subCity : '__custom__',
      customSubCity: isKnownPreset ? '' : f.subCity,
      woreda: f.woreda || '',
      buildingEn: f.buildingEn || '',
      buildingAm: f.buildingAm || '',
      landmarkEn: f.landmarkEn || '',
      landmarkAm: f.landmarkAm || '',
      focalPerson: f.focalPerson || '',
      focalPhone: f.focalPhone || '',
      telegramHandle: f.telegramHandle || '',
      addressEn: f.addressEn,
      addressAm: f.addressAm,
      phone: f.phone,
      latitude: f.latitude,
      longitude: f.longitude,
      operatingHours: f.operatingHours,
      isVerified: f.isVerified,
      isWheelchairAccessible: Boolean(f.isWheelchairAccessible),
      hasPrivateRoom: Boolean(f.hasPrivateRoom),
      services: f.services || [],
    });
    setIsModalOpen(true);
  };

  const handleLocationPresetChange = (presetId: string) => {
    if (presetId === '__custom__') {
      setIsCustomLocation(true);
      setFormData({
        ...formData,
        subCity: '__custom__',
      });
      return;
    }

    setIsCustomLocation(false);
    const preset = LOCATION_PRESETS.find((p) => p.id === presetId);
    if (preset) {
      setFormData({
        ...formData,
        subCity: preset.id,
        latitude: preset.defaultLat,
        longitude: preset.defaultLng,
      });
    } else {
      setFormData({
        ...formData,
        subCity: presetId,
      });
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const finalSubCity = isCustomLocation ? formData.customSubCity.trim() || 'General Campus' : formData.subCity;

    const payload: Partial<Facility> = {
      nameEn: formData.nameEn,
      nameAm: formData.nameAm,
      category: formData.category,
      subCity: finalSubCity,
      woreda: formData.woreda,
      buildingEn: formData.buildingEn,
      buildingAm: formData.buildingAm,
      landmarkEn: formData.landmarkEn,
      landmarkAm: formData.landmarkAm,
      focalPerson: formData.focalPerson,
      focalPhone: formData.focalPhone,
      telegramHandle: formData.telegramHandle,
      addressEn: formData.addressEn,
      addressAm: formData.addressAm,
      phone: formData.phone,
      latitude: formData.latitude,
      longitude: formData.longitude,
      operatingHours: formData.operatingHours,
      isVerified: formData.isVerified,
      isWheelchairAccessible: formData.isWheelchairAccessible,
      hasPrivateRoom: formData.hasPrivateRoom,
      services: formData.services,
    };

    await onSave(payload, editingFacility ? editingFacility.id : undefined);
    setIsModalOpen(false);
  };

  const getCategoryBadge = (category?: FacilityCategory) => {
    const cat = FACILITY_CATEGORIES.find((c) => c.id === category) || FACILITY_CATEGORIES[0];
    const Icon = cat.icon;
    return (
      <span className="inline-flex items-center gap-1.5 px-2 py-0.5 rounded-md bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 text-[11px] font-semibold border border-slate-200/60 dark:border-slate-700">
        <Icon size={12} className="text-slate-500 dark:text-slate-400" />
        <span>{lang === 'am' ? cat.nameAm : cat.nameEn}</span>
      </span>
    );
  };

  const getLocationBadge = (subCity: string) => {
    return (
      <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-indigo-50 dark:bg-indigo-950/40 border border-indigo-200/70 dark:border-indigo-800/60 text-indigo-700 dark:text-indigo-300 text-[11px] font-bold">
        <GraduationCap size={12} className="text-indigo-600 dark:text-indigo-400" />
        <span>{subCity}</span>
      </span>
    );
  };

  const handleExportCsv = () => {
    exportToCsv(
      'Yegna_UoG_Facilities_Directory',
      [
        { header: 'Facility Name (English)', accessor: (f) => f.nameEn },
        { header: 'Facility Name (Amharic)', accessor: (f) => f.nameAm },
        { header: 'Category', accessor: (f) => f.category || 'clinical' },
        { header: 'Campus & Location', accessor: (f) => f.subCity },
        { header: 'Building / Block / Room', accessor: (f) => f.buildingEn || f.woreda || '' },
        { header: 'Nearby Landmark', accessor: (f) => f.landmarkEn || '' },
        { header: 'Focal Officer', accessor: (f) => f.focalPerson || '' },
        { header: 'Contact Phone', accessor: (f) => f.phone },
        { header: 'Operating Hours', accessor: (f) => f.operatingHours },
        { header: 'Address (English)', accessor: (f) => f.addressEn },
        { header: 'GPS Latitude', accessor: (f) => f.latitude },
        { header: 'GPS Longitude', accessor: (f) => f.longitude },
        { header: 'Wheelchair Accessible', accessor: (f) => (f.isWheelchairAccessible ? 'YES' : 'NO') },
        { header: 'Verification Status', accessor: (f) => (f.isVerified ? 'VERIFIED' : 'PENDING') },
        { header: 'Services & Tags', accessor: (f) => (f.services || []).join('; ') },
      ],
      filtered
    );
  };

  const selectedPreset = LOCATION_PRESETS.find((p) => p.id === formData.subCity);

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="px-2 py-0.5 rounded-md bg-slate-100 dark:bg-slate-800 text-slate-500 dark:text-slate-400 text-[10px] font-bold uppercase tracking-wider border border-slate-200/60 dark:border-slate-700">
              {lang === 'am' ? 'የጎንደር ዩኒቨርሲቲ' : 'University of Gondar'}
            </span>
          </div>
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2 mt-1">
            <Building2 className="text-slate-900 dark:text-white" size={24} />
            <span>{lang === 'am' ? 'የጎንደር ዩኒቨርሲቲ ተቋማት ማዕከል' : 'Campus Facilities Directory CMS'}</span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-0.5">
            {lang === 'am'
              ? 'የጎንደር ዩኒቨርሲቲ ካምፓስ ክሊኒኮችን፣ የማማከር ማዕከላትን፣ የተማሪዎች አገልግሎቶችንና ሌሎች ተቋማትን ያስተዳድሩ።'
              : 'Manage verified University of Gondar health centers, counseling units, libraries, and student welfare facilities.'}
          </p>
        </div>
        <div className="flex items-center gap-2 self-start sm:self-auto">
          <button
            onClick={handleExportCsv}
            className="flex items-center gap-1.5 px-3.5 py-2.5 bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs md:text-sm font-bold rounded-xl border border-slate-200 dark:border-slate-700 transition-all cursor-pointer"
            title={lang === 'am' ? 'ወደ ኤክሴል (CSV) አውርድ' : 'Export directory to Excel CSV'}
          >
            <Download size={15} />
            <span>{lang === 'am' ? 'ሪፖርት (CSV)' : 'Export CSV'}</span>
          </button>
          <button
            onClick={openCreateModal}
            className="flex items-center gap-2 px-4 py-2.5 bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 text-xs md:text-sm font-bold rounded-xl border border-slate-900 dark:border-white shadow-xs transition-all active:scale-[0.99] cursor-pointer"
          >
            <Plus size={16} />
            <span>{lang === 'am' ? '+ አዲስ ተቋም ጨምር' : '+ Add Facility'}</span>
          </button>
        </div>
      </div>

      {/* Search & Advanced Multi-Axis Filters Toolbar */}
      <div className="bg-white dark:bg-slate-900 p-4 md:p-5 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs space-y-4">
        {/* Search Bar with Keyboard Shortcut Hint & Quick Clear */}
        <div className="relative">
          <div className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none flex items-center">
            <Search size={18} />
          </div>
          <input
            ref={searchInputRef}
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder={
              lang === 'am'
                ? 'በተቋም ስም፣ በካምፓስ፣ በህንፃ ወይም በባለሙያ ፈልግ...'
                : 'Search facilities by name, campus, building, room, focal officer or service...'
            }
            className="w-full pl-10 pr-24 py-2.5 text-xs md:text-sm bg-slate-50 dark:bg-slate-800/80 border border-slate-200 dark:border-slate-700 rounded-xl focus:bg-white dark:focus:bg-slate-900 focus:border-slate-900 dark:focus:border-white focus:outline-none text-slate-900 dark:text-white transition-all placeholder:text-slate-400 dark:placeholder:text-slate-500 shadow-2xs"
          />
          <div className="absolute right-3 top-1/2 -translate-y-1/2 flex items-center gap-1.5">
            {search && (
              <button
                type="button"
                onClick={() => setSearch('')}
                title={lang === 'am' ? 'አጽዳ' : 'Clear search'}
                className="p-1 rounded-md text-slate-400 hover:text-slate-700 dark:hover:text-slate-200 hover:bg-slate-200/70 dark:hover:bg-slate-700 transition-colors cursor-pointer"
              >
                <X size={14} />
              </button>
            )}
            <kbd className="hidden sm:inline-flex items-center justify-center px-1.5 py-0.5 text-[10px] font-mono font-medium text-slate-400 dark:text-slate-500 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded shadow-2xs select-none">
              /
            </kbd>
          </div>
        </div>

        {/* Side-by-Side Advanced Custom Dropdowns */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-3 pt-1">
          {/* Dropdown 1: Campus Filter */}
          <div ref={campusDropdownRef} className="relative">
            <button
              type="button"
              onClick={() => setActiveDropdown(activeDropdown === 'campus' ? null : 'campus')}
              className={`w-full flex items-center justify-between gap-3 px-3.5 py-2.5 rounded-xl border text-left transition-all cursor-pointer ${
                activeDropdown === 'campus'
                  ? 'border-slate-900 dark:border-white bg-slate-50/50 dark:bg-slate-800/60 ring-2 ring-slate-900/10 dark:ring-white/10'
                  : selectedCampus !== 'All'
                  ? 'border-slate-900/40 dark:border-slate-600 bg-slate-50/60 dark:bg-slate-800/40'
                  : 'border-slate-200 dark:border-slate-700 bg-slate-50/40 dark:bg-slate-800/20 hover:border-slate-300 dark:hover:border-slate-600'
              }`}
            >
              <div className="flex items-center gap-2.5 min-w-0">
                <div className="w-7 h-7 rounded-lg bg-slate-100 dark:bg-slate-800 flex items-center justify-center text-slate-700 dark:text-slate-200 shrink-0">
                  <GraduationCap size={15} />
                </div>
                <div className="min-w-0">
                  <span className="block text-[10px] font-bold uppercase tracking-wider text-slate-400 dark:text-slate-500">
                    {lang === 'am' ? 'ካምፓስ' : 'Campus'}
                  </span>
                  <span className="block text-xs md:text-sm font-semibold text-slate-900 dark:text-white truncate">
                    {activeCampusLabel}
                  </span>
                </div>
              </div>
              <div className="flex items-center gap-2 shrink-0">
                <span className="px-1.5 py-0.5 text-[11px] font-bold rounded-md bg-slate-200/80 dark:bg-slate-800 text-slate-700 dark:text-slate-300">
                  {campusCounts[selectedCampus] ?? filtered.length}
                </span>
                <ChevronDown
                  size={16}
                  className={`text-slate-400 transition-transform duration-200 ${
                    activeDropdown === 'campus' ? 'rotate-180 text-slate-900 dark:text-white' : ''
                  }`}
                />
              </div>
            </button>

            {/* Floating Campus Popover Menu */}
            {activeDropdown === 'campus' && (
              <div className="absolute z-30 left-0 right-0 mt-2 p-1.5 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-xl space-y-0.5 max-h-72 overflow-y-auto animate-in fade-in zoom-in-95 duration-100">
                <button
                  type="button"
                  onClick={() => {
                    setSelectedCampus('All');
                    setActiveDropdown(null);
                  }}
                  className={`w-full flex items-center justify-between px-3 py-2 rounded-xl text-xs font-semibold transition-colors cursor-pointer ${
                    selectedCampus === 'All'
                      ? 'bg-slate-900 dark:bg-white text-white dark:text-slate-900'
                      : 'text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800'
                  }`}
                >
                  <div className="flex items-center gap-2">
                    <GraduationCap
                      size={14}
                      className={selectedCampus === 'All' ? 'text-white dark:text-slate-900' : 'text-slate-400'}
                    />
                    <span>{lang === 'am' ? 'ሁሉም ካምፓሶች' : 'All Campuses'}</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <span
                      className={`text-[10px] font-bold px-1.5 py-0.5 rounded ${
                        selectedCampus === 'All'
                          ? 'bg-slate-800 dark:bg-slate-200 text-slate-200 dark:text-slate-800'
                          : 'bg-slate-100 dark:bg-slate-800 text-slate-500'
                      }`}
                    >
                      {facilities.length}
                    </span>
                    {selectedCampus === 'All' && <Check size={14} />}
                  </div>
                </button>

                <div className="h-px bg-slate-100 dark:bg-slate-800 my-1" />

                {LOCATION_PRESETS.map((preset) => {
                  const isSelected = selectedCampus === preset.id;
                  const count = campusCounts[preset.id] ?? 0;
                  return (
                    <button
                      key={preset.id}
                      type="button"
                      onClick={() => {
                        setSelectedCampus(preset.id);
                        setActiveDropdown(null);
                      }}
                      className={`w-full flex items-center justify-between px-3 py-2 rounded-xl text-xs font-semibold transition-colors cursor-pointer ${
                        isSelected
                          ? 'bg-slate-900 dark:bg-white text-white dark:text-slate-900'
                          : 'text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800'
                      }`}
                    >
                      <span className="truncate pr-2">{lang === 'am' ? preset.nameAm : preset.nameEn}</span>
                      <div className="flex items-center gap-2 shrink-0">
                        <span
                          className={`text-[10px] font-bold px-1.5 py-0.5 rounded ${
                            isSelected
                              ? 'bg-slate-800 dark:bg-slate-200 text-slate-200 dark:text-slate-800'
                              : 'bg-slate-100 dark:bg-slate-800 text-slate-500'
                          }`}
                        >
                          {count}
                        </span>
                        {isSelected && <Check size={14} />}
                      </div>
                    </button>
                  );
                })}
              </div>
            )}
          </div>

          {/* Dropdown 2: Category Filter */}
          <div ref={categoryDropdownRef} className="relative">
            <button
              type="button"
              onClick={() => setActiveDropdown(activeDropdown === 'category' ? null : 'category')}
              className={`w-full flex items-center justify-between gap-3 px-3.5 py-2.5 rounded-xl border text-left transition-all cursor-pointer ${
                activeDropdown === 'category'
                  ? 'border-slate-900 dark:border-white bg-slate-50/50 dark:bg-slate-800/60 ring-2 ring-slate-900/10 dark:ring-white/10'
                  : selectedCategory !== 'All'
                  ? 'border-slate-900/40 dark:border-slate-600 bg-slate-50/60 dark:bg-slate-800/40'
                  : 'border-slate-200 dark:border-slate-700 bg-slate-50/40 dark:bg-slate-800/20 hover:border-slate-300 dark:hover:border-slate-600'
              }`}
            >
              <div className="flex items-center gap-2.5 min-w-0">
                <div className="w-7 h-7 rounded-lg bg-slate-100 dark:bg-slate-800 flex items-center justify-center text-slate-700 dark:text-slate-200 shrink-0">
                  <ActiveCategoryIcon size={15} />
                </div>
                <div className="min-w-0">
                  <span className="block text-[10px] font-bold uppercase tracking-wider text-slate-400 dark:text-slate-500">
                    {lang === 'am' ? 'ዘርፍ' : 'Category'}
                  </span>
                  <span className="block text-xs md:text-sm font-semibold text-slate-900 dark:text-white truncate">
                    {activeCategoryLabel}
                  </span>
                </div>
              </div>
              <div className="flex items-center gap-2 shrink-0">
                <span className="px-1.5 py-0.5 text-[11px] font-bold rounded-md bg-slate-200/80 dark:bg-slate-800 text-slate-700 dark:text-slate-300">
                  {categoryCounts[selectedCategory] ?? filtered.length}
                </span>
                <ChevronDown
                  size={16}
                  className={`text-slate-400 transition-transform duration-200 ${
                    activeDropdown === 'category' ? 'rotate-180 text-slate-900 dark:text-white' : ''
                  }`}
                />
              </div>
            </button>

            {/* Floating Category Popover Menu */}
            {activeDropdown === 'category' && (
              <div className="absolute z-30 left-0 right-0 mt-2 p-1.5 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-xl space-y-0.5 max-h-72 overflow-y-auto animate-in fade-in zoom-in-95 duration-100">
                <button
                  type="button"
                  onClick={() => {
                    setSelectedCategory('All');
                    setActiveDropdown(null);
                  }}
                  className={`w-full flex items-center justify-between px-3 py-2 rounded-xl text-xs font-semibold transition-colors cursor-pointer ${
                    selectedCategory === 'All'
                      ? 'bg-slate-900 dark:bg-white text-white dark:text-slate-900'
                      : 'text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800'
                  }`}
                >
                  <div className="flex items-center gap-2">
                    <Building2
                      size={14}
                      className={selectedCategory === 'All' ? 'text-white dark:text-slate-900' : 'text-slate-400'}
                    />
                    <span>{lang === 'am' ? 'ሁሉም ዘርፎች' : 'All Categories'}</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <span
                      className={`text-[10px] font-bold px-1.5 py-0.5 rounded ${
                        selectedCategory === 'All'
                          ? 'bg-slate-800 dark:bg-slate-200 text-slate-200 dark:text-slate-800'
                          : 'bg-slate-100 dark:bg-slate-800 text-slate-500'
                      }`}
                    >
                      {facilities.length}
                    </span>
                    {selectedCategory === 'All' && <Check size={14} />}
                  </div>
                </button>

                <div className="h-px bg-slate-100 dark:bg-slate-800 my-1" />

                {FACILITY_CATEGORIES.map((cat) => {
                  const Icon = cat.icon;
                  const isSelected = selectedCategory === cat.id;
                  const count = categoryCounts[cat.id] ?? 0;
                  return (
                    <button
                      key={cat.id}
                      type="button"
                      onClick={() => {
                        setSelectedCategory(cat.id);
                        setActiveDropdown(null);
                      }}
                      className={`w-full flex items-center justify-between px-3 py-2 rounded-xl text-xs font-semibold transition-colors cursor-pointer ${
                        isSelected
                          ? 'bg-slate-900 dark:bg-white text-white dark:text-slate-900'
                          : 'text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800'
                      }`}
                    >
                      <div className="flex items-center gap-2 truncate pr-2">
                        <Icon
                          size={14}
                          className={isSelected ? 'text-white dark:text-slate-900' : 'text-slate-400'}
                        />
                        <span className="truncate">{lang === 'am' ? cat.nameAm : cat.nameEn}</span>
                      </div>
                      <div className="flex items-center gap-2 shrink-0">
                        <span
                          className={`text-[10px] font-bold px-1.5 py-0.5 rounded ${
                            isSelected
                              ? 'bg-slate-800 dark:bg-slate-200 text-slate-200 dark:text-slate-800'
                              : 'bg-slate-100 dark:bg-slate-800 text-slate-500'
                          }`}
                        >
                          {count}
                        </span>
                        {isSelected && <Check size={14} />}
                      </div>
                    </button>
                  );
                })}
              </div>
            )}
          </div>
        </div>

        {/* Filter Status & Quick Reset Row */}
        <div className="flex items-center justify-between pt-1 border-t border-slate-100 dark:border-slate-800 text-xs text-slate-500 dark:text-slate-400">
          <div>
            {lang === 'am'
              ? `የተገኙ ተቋማት፦ ${filtered.length} ከ ${facilities.length}`
              : `Showing ${filtered.length} of ${facilities.length} facilities`}
          </div>
          {hasActiveFilters && (
            <button
              type="button"
              onClick={handleResetFilters}
              className="inline-flex items-center gap-1.5 text-xs font-semibold text-slate-600 dark:text-slate-300 hover:text-slate-900 dark:hover:text-white transition-colors cursor-pointer"
            >
              <RotateCcw size={12} />
              <span>{lang === 'am' ? 'ሁሉንም ማጣሪያዎች አጽዳ' : 'Reset all filters'}</span>
            </button>
          )}
        </div>
      </div>

      {/* Facilities Data Table */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs md:text-sm">
            <thead className="bg-slate-50 dark:bg-slate-800/80 border-b border-slate-100 dark:border-slate-800 text-slate-500 dark:text-slate-400 font-bold uppercase text-[11px] tracking-wider">
              <tr>
                <SortableHeader
                  label={lang === 'am' ? 'የተቋሙ ስም እና ዘርፍ' : 'Facility & Category'}
                  field="name"
                  currentField={sortField}
                  currentOrder={sortOrder}
                  onSort={handleSort}
                />
                <SortableHeader
                  label={lang === 'am' ? 'ካምፓስ እና ህንፃ' : 'Campus & Building'}
                  field="subCity"
                  currentField={sortField}
                  currentOrder={sortOrder}
                  onSort={handleSort}
                />
                <SortableHeader
                  label={lang === 'am' ? 'ስልክ እና ኃላፊ' : 'Contact & Officer'}
                  field="phone"
                  currentField={sortField}
                  currentOrder={sortOrder}
                  onSort={handleSort}
                />
                <th className="py-3 px-4">{lang === 'am' ? 'አገልግሎቶችና ማካተት' : 'Services & Features'}</th>
                <SortableHeader
                  label={lang === 'am' ? 'ሁኔታ' : 'Status'}
                  field="status"
                  currentField={sortField}
                  currentOrder={sortOrder}
                  onSort={handleSort}
                />
                <th className="py-3 px-4 text-right">{lang === 'am' ? 'እርምጃዎች' : 'Actions'}</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 dark:divide-slate-800 font-medium">
              {isLoading && facilities.length === 0 ? (
                <TableSkeleton colSpan={6} rows={6} />
              ) : (
                <>
                  {sortedFacilities.map((f) => (
                <tr key={f.id} className="hover:bg-slate-50/70 dark:hover:bg-slate-800/50 transition-colors">
                  {/* Facility Name & Category */}
                  <td className="py-3.5 px-4">
                    <div className="space-y-1">
                      <div className="flex items-center gap-1.5">
                        <p className="font-bold text-slate-900 dark:text-white">{lang === 'am' ? f.nameAm : f.nameEn}</p>
                      </div>
                      <div className="flex items-center gap-1.5">
                        {getCategoryBadge(f.category)}
                        <span className="text-[11px] text-slate-400 dark:text-slate-500">
                          {lang === 'am' ? f.nameEn : f.nameAm}
                        </span>
                      </div>
                    </div>
                  </td>

                  {/* Campus & Building / Landmark */}
                  <td className="py-3.5 px-4 text-slate-600 dark:text-slate-300">
                    <div className="space-y-1">
                      <div className="flex items-center gap-1.5">
                        {getLocationBadge(f.subCity)}
                        {(f.buildingEn || f.woreda) && (
                          <span className="text-slate-600 dark:text-slate-400 text-xs font-semibold truncate max-w-[200px]">
                            • {f.buildingEn || f.woreda}
                          </span>
                        )}
                      </div>
                      <div className="flex items-center gap-1 text-[11px] text-slate-400 dark:text-slate-500 truncate max-w-xs">
                        <MapPin size={11} className="shrink-0" />
                        <span>{f.landmarkEn ? `${f.landmarkEn} (${f.addressEn})` : f.addressEn}</span>
                      </div>
                    </div>
                  </td>

                  {/* Contact & Focal Person */}
                  <td className="py-3.5 px-4">
                    <div className="space-y-1">
                      <a
                        href={`tel:${f.phone}`}
                        className="inline-flex items-center gap-1.5 text-xs font-bold text-slate-900 dark:text-white hover:underline"
                      >
                        <Phone size={12} />
                        {f.phone}
                      </a>
                      {f.focalPerson && (
                        <div className="flex items-center gap-1 text-[11px] text-slate-500 dark:text-slate-400 truncate max-w-[180px]">
                          <UserCheck size={11} className="shrink-0 text-slate-400" />
                          <span className="truncate">{f.focalPerson}</span>
                        </div>
                      )}
                      {f.operatingHours && (
                        <div className="flex items-center gap-1 text-[10px] text-slate-400">
                          <Clock size={10} className="shrink-0" />
                          <span>{f.operatingHours}</span>
                        </div>
                      )}
                    </div>
                  </td>

                  {/* Services & Accessibility Badges */}
                  <td className="py-3.5 px-4">
                    <div className="space-y-1.5 max-w-xs">
                      <div className="flex flex-wrap gap-1">
                        {(f.services || []).map((s, idx) => (
                          <span
                            key={idx}
                            className="px-1.5 py-0.5 rounded-md bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 text-[10px] font-semibold border border-slate-200/60 dark:border-slate-700"
                          >
                            {s}
                          </span>
                        ))}
                      </div>
                      <div className="flex items-center gap-1 text-[10px]">
                        {f.isWheelchairAccessible && (
                          <span className="inline-flex items-center gap-1 px-1.5 py-0.5 rounded bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-400 font-bold border border-emerald-200 dark:border-emerald-800/60">
                            ♿ {lang === 'am' ? 'ተደራሽ' : 'Accessible'}
                          </span>
                        )}
                        {f.hasPrivateRoom && (
                          <span className="inline-flex items-center gap-1 px-1.5 py-0.5 rounded bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 font-bold border border-slate-200 dark:border-slate-700">
                            <Lock size={10} />
                            {lang === 'am' ? 'ሚስጥራዊ' : 'Private'}
                          </span>
                        )}
                      </div>
                    </div>
                  </td>

                  {/* Status */}
                  <td className="py-3.5 px-4">
                    {f.isVerified ? (
                      <span className="inline-flex items-center gap-1 text-[11px] font-bold text-emerald-700 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-950/40 px-2.5 py-0.5 rounded-full border border-emerald-200 dark:border-emerald-800/60">
                        <CheckCircle2 size={12} />
                        {lang === 'am' ? 'የተረጋገጠ' : 'Verified'}
                      </span>
                    ) : (
                      <span className="inline-flex items-center text-[11px] font-bold text-amber-700 dark:text-amber-400 bg-amber-50 dark:bg-amber-950/40 px-2.5 py-0.5 rounded-full border border-amber-200 dark:border-amber-800/60">
                        {lang === 'am' ? 'በግምገማ ላይ' : 'Pending'}
                      </span>
                    )}
                  </td>

                  {/* Actions */}
                  <td className="py-3.5 px-4 text-right">
                    <div className="inline-flex items-center gap-1">
                      <button
                        onClick={() => openEditModal(f)}
                        className="p-1.5 text-slate-500 hover:text-slate-900 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition-colors cursor-pointer"
                        title={lang === 'am' ? 'አርትዕ' : 'Edit Facility'}
                      >
                        <Edit2 size={15} />
                      </button>
                      <button
                        onClick={() => setFacilityToDelete(f)}
                        className="p-1.5 text-slate-500 hover:text-rose-600 dark:hover:text-rose-400 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-lg transition-colors cursor-pointer"
                        title={lang === 'am' ? 'ሰርዝ' : 'Delete Facility'}
                      >
                        <Trash2 size={15} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
              {sortedFacilities.length === 0 && (
                <EmptyState
                  colSpan={6}
                  icon={Building2}
                  title={lang === 'am' ? 'ምንም ተቋም አልተገኘም' : 'No campus facilities found'}
                  description={
                    search || selectedCampus !== 'All' || selectedCategory !== 'All'
                      ? lang === 'am'
                        ? 'በተመረጡት ማጣሪያዎች የሚገኝ ተቋም የለም። እባክዎ ማጣሪያዎቹን ያጽዱ ወይም አዲስ ተቋም ይመዝግቡ።'
                        : 'No facilities match your current search and filter criteria.'
                      : lang === 'am'
                      ? 'እስካሁን የተመዘገበ የዩኦጂ ተቋም የለም። የመጀመሪያውን ተቋም እዚህ ይመዝግቡ።'
                      : 'No University of Gondar campus facilities registered yet.'
                  }
                  clearLabel={
                    search || selectedCampus !== 'All' || selectedCategory !== 'All'
                      ? lang === 'am'
                        ? 'ማጣሪያዎችን አጽዳ'
                        : 'Reset Filters'
                      : undefined
                  }
                  onClear={() => {
                    setSearch('');
                    setSelectedCampus('All');
                    setSelectedCategory('All');
                  }}
                  actionLabel={lang === 'am' ? '+ አዲስ ተቋም መዝግብ' : '+ Add Facility'}
                  onAction={openCreateModal}
                />
              )}
                </>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Advanced Clean Add / Edit Facility Modal Dialog */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-950/60 backdrop-blur-xs flex items-center justify-center p-3 sm:p-4">
          <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-2xl w-full max-h-[92vh] flex flex-col overflow-hidden animate-in fade-in zoom-in-95 duration-150">
            {/* Pinned Modal Header */}
            <div className="flex items-center justify-between px-6 py-4 border-b border-slate-100 dark:border-slate-800 shrink-0">
              <div>
                <div className="flex items-center gap-1.5">
                  <span className="px-2 py-0.5 rounded-md bg-slate-100 dark:bg-slate-800 text-slate-500 text-[10px] font-bold uppercase tracking-wider">
                    {lang === 'am' ? 'የጎንደር ዩኒቨርሲቲ' : 'University of Gondar'}
                  </span>
                </div>
                <h3 className="text-base sm:text-lg font-extrabold text-slate-900 dark:text-white mt-0.5">
                  {editingFacility
                    ? lang === 'am' ? 'የካምፓስ ተቋምን አርትዕ' : 'Edit Campus Facility'
                    : lang === 'am' ? 'አዲስ የካምፓስ ተቋም መዝግብ' : 'Add New Campus Facility'}
                </h3>
              </div>
              <button
                onClick={() => setIsModalOpen(false)}
                className="p-1.5 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-800 cursor-pointer transition-colors"
              >
                <X size={18} />
              </button>
            </div>

            {/* Scrollable Form Body */}
            <form onSubmit={handleSubmit} className="flex-1 overflow-y-auto p-5 sm:p-6 space-y-5 text-xs sm:text-sm">
              {/* Card 1: Identification & Classification */}
              <div className="p-4 rounded-2xl bg-slate-50/70 dark:bg-slate-800/40 border border-slate-200/70 dark:border-slate-800 space-y-3.5">
                <div className="flex items-center gap-2 pb-1 border-b border-slate-200/50 dark:border-slate-700/50">
                  <span className="w-1.5 h-1.5 rounded-full bg-slate-900 dark:bg-white" />
                  <h4 className="font-extrabold text-slate-900 dark:text-white text-xs uppercase tracking-wider">
                    {lang === 'am' ? '1. የተቋሙ መለያ እና ዘርፍ' : '1. Facility Identity & Classification'}
                  </h4>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 text-xs">
                      {lang === 'am' ? 'የተቋሙ ስም (እንግሊዝኛ)' : 'Facility Name (English)'}
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.nameEn}
                      onChange={(e) => setFormData({ ...formData, nameEn: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-slate-900 dark:focus:border-white focus:outline-hidden text-xs"
                      placeholder="e.g. UoG Maraki Student Health Center"
                    />
                  </div>
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 text-xs">
                      {lang === 'am' ? 'የተቋሙ ስም (በአማርኛ)' : 'Facility Name (Amharic)'}
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.nameAm}
                      onChange={(e) => setFormData({ ...formData, nameAm: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-slate-900 dark:focus:border-white focus:outline-hidden text-xs"
                      placeholder="ምሳሌ፡ የጎንደር ዩኒቨርሲቲ ማራኪ የተማሪዎች ጤና ጣቢያ"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 text-xs">
                      {lang === 'am' ? 'የተቋሙ ዘርፍ' : 'Facility Category'}
                    </label>
                    <select
                      value={formData.category}
                      onChange={(e) => setFormData({ ...formData, category: e.target.value as FacilityCategory })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl focus:border-slate-900 dark:focus:border-white focus:outline-hidden bg-white dark:bg-slate-800 font-semibold text-slate-800 dark:text-slate-200 text-xs"
                    >
                      {FACILITY_CATEGORIES.map((c) => (
                        <option key={c.id} value={c.id}>
                          {lang === 'am' ? c.nameAm : c.nameEn}
                        </option>
                      ))}
                    </select>
                  </div>
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 text-xs">
                      {lang === 'am' ? 'ካምፓስ' : 'Campus Location'}
                    </label>
                    <select
                      value={isCustomLocation ? '__custom__' : formData.subCity}
                      onChange={(e) => handleLocationPresetChange(e.target.value)}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl focus:border-slate-900 dark:focus:border-white focus:outline-hidden bg-white dark:bg-slate-800 font-semibold text-slate-800 dark:text-slate-200 text-xs"
                    >
                      <optgroup label="University of Gondar Campuses" className="dark:bg-slate-800 dark:text-white">
                        {LOCATION_PRESETS.map((p) => (
                          <option key={p.id} value={p.id}>
                            {p.nameEn} ({p.nameAm})
                          </option>
                        ))}
                      </optgroup>
                      <optgroup label="Custom Location" className="dark:bg-slate-800 dark:text-white">
                        <option value="__custom__">
                          {lang === 'am' ? '+ የተለየ ካምፓስ ወይም የሕንፃ ቦታ...' : '+ Custom Campus / Wing...'}
                        </option>
                      </optgroup>
                    </select>
                  </div>
                </div>

                {isCustomLocation && (
                  <div className="pt-1 animate-in fade-in duration-150">
                    <label className="block font-semibold text-slate-600 dark:text-slate-400 text-xs mb-1">
                      {lang === 'am' ? 'የተለየ ካምፓስ ወይም የሕንፃ ስም ያስገቡ' : 'Enter Custom Campus or Location Name'}
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.customSubCity}
                      onChange={(e) => setFormData({ ...formData, customSubCity: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white rounded-xl focus:border-slate-900 dark:focus:border-white focus:outline-hidden text-xs"
                      placeholder="e.g. Tseda Agriculture Block or Maraki ICT Building"
                    />
                  </div>
                )}
              </div>

              {/* Card 2: Campus Building, Landmark & Interactive Map */}
              <div className="p-4 rounded-2xl bg-slate-50/70 dark:bg-slate-800/40 border border-slate-200/70 dark:border-slate-800 space-y-3.5">
                <div className="flex items-center gap-2 pb-1 border-b border-slate-200/50 dark:border-slate-700/50">
                  <span className="w-1.5 h-1.5 rounded-full bg-slate-900 dark:bg-white" />
                  <h4 className="font-extrabold text-slate-900 dark:text-white text-xs uppercase tracking-wider">
                    {lang === 'am' ? '2. በካምፓስ ውስጥ ትክክለኛ መገኛ እና ካርታ' : '2. Campus Building & Precise Location'}
                  </h4>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 text-xs">
                      {lang === 'am' ? 'ህንፃ / ፎቅ / ክፍል ቁጥር' : 'Building / Floor / Room No.'}
                    </label>
                    <input
                      type="text"
                      value={formData.buildingEn}
                      onChange={(e) => setFormData({ ...formData, buildingEn: e.target.value, woreda: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-slate-900 dark:focus:border-white focus:outline-hidden text-xs"
                      placeholder="e.g. Block 14, 2nd Floor, Room 204"
                    />
                  </div>
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 text-xs">
                      {lang === 'am' ? 'አቅራቢያ የሚገኝ ምልክት (Landmark)' : 'Campus Landmark / Near'}
                    </label>
                    <input
                      type="text"
                      value={formData.landmarkEn}
                      onChange={(e) => setFormData({ ...formData, landmarkEn: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-slate-900 dark:focus:border-white focus:outline-hidden text-xs"
                      placeholder="e.g. Opposite Maraki Main Library & Dining Hall"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 text-xs">
                      {lang === 'am' ? 'አድራሻ (እንግሊዝኛ)' : 'Physical Address (English)'}
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.addressEn}
                      onChange={(e) => setFormData({ ...formData, addressEn: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-slate-900 dark:focus:border-white focus:outline-hidden text-xs"
                      placeholder="Inside Maraki Campus, Student Services Wing"
                    />
                  </div>
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 text-xs">
                      {lang === 'am' ? 'አድራሻ (በአማርኛ)' : 'Physical Address (Amharic)'}
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.addressAm}
                      onChange={(e) => setFormData({ ...formData, addressAm: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-slate-900 dark:focus:border-white focus:outline-hidden text-xs"
                      placeholder="ማራኪ ካምፓስ ውስጥ፣ የተማሪዎች አገልግሎት ዘርፍ"
                    />
                  </div>
                </div>

                {/* Interactive Leaflet Campus Map Picker with Street/Satellite toggle */}
                <CampusMapPicker
                  latitude={formData.latitude}
                  longitude={formData.longitude}
                  campusName={formData.subCity}
                  defaultLat={selectedPreset?.defaultLat}
                  defaultLng={selectedPreset?.defaultLng}
                  onChange={(lat, lng) => setFormData({ ...formData, latitude: lat, longitude: lng })}
                  lang={lang}
                />
              </div>

              {/* Card 3: Operating Hours & Focal Officer Contact */}
              <div className="p-4 rounded-2xl bg-slate-50/70 dark:bg-slate-800/40 border border-slate-200/70 dark:border-slate-800 space-y-3.5">
                <div className="flex items-center gap-2 pb-1 border-b border-slate-200/50 dark:border-slate-700/50">
                  <span className="w-1.5 h-1.5 rounded-full bg-indigo-500" />
                  <h4 className="font-extrabold text-slate-900 dark:text-white text-xs uppercase tracking-wider">
                    {lang === 'am' ? '3. የሥራ ሰዓት እና የኃላፊው መረጃ' : '3. Hours, Contact & Focal Officer'}
                  </h4>
                </div>

                {/* Operating Hours with 1-Click Quick Presets */}
                <div className="space-y-1.5">
                  <div className="flex items-center justify-between">
                    <label className="block font-bold text-slate-700 dark:text-slate-300 text-xs">
                      {lang === 'am' ? 'የሥራ ሰዓት' : 'Operating Hours'}
                    </label>
                    <div className="flex items-center gap-1 overflow-x-auto">
                      {HOURS_PRESETS.map((hp) => (
                        <button
                          key={hp}
                          type="button"
                          onClick={() => setFormData({ ...formData, operatingHours: hp })}
                          className={`px-2 py-0.5 rounded text-[10px] font-bold transition-colors cursor-pointer ${
                            formData.operatingHours === hp
                              ? 'bg-slate-900 dark:bg-white text-white dark:text-slate-900'
                              : 'bg-white dark:bg-slate-800 text-slate-500 hover:text-slate-700 dark:hover:text-slate-300 border border-slate-200/60 dark:border-slate-700'
                          }`}
                        >
                          {hp}
                        </button>
                      ))}
                    </div>
                  </div>
                  <input
                    type="text"
                    value={formData.operatingHours}
                    onChange={(e) => setFormData({ ...formData, operatingHours: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-slate-900 dark:focus:border-white focus:outline-hidden text-xs"
                    placeholder="Open 24/7 or 08:30 - 17:30"
                  />
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 text-xs">
                      {lang === 'am' ? 'ዋና የስልክ ቁጥር' : 'Direct Phone Contact'}
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.phone}
                      onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-slate-900 dark:focus:border-white focus:outline-hidden text-xs"
                      placeholder="+251581141234"
                    />
                  </div>
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 text-xs">
                      {lang === 'am' ? 'የተቋሙ ኃላፊ / ባለሙያ ስም' : 'Focal Officer in Charge'}
                    </label>
                    <input
                      type="text"
                      value={formData.focalPerson}
                      onChange={(e) => setFormData({ ...formData, focalPerson: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-slate-900 dark:focus:border-white focus:outline-hidden text-xs"
                      placeholder="e.g. Sr. Tigist Alemayehu (Lead Nurse)"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 text-xs">
                      {lang === 'am' ? 'የውስጥ መስመር / ተጨማሪ ስልክ' : 'Internal Extension / Direct Line'}
                    </label>
                    <input
                      type="text"
                      value={formData.focalPhone}
                      onChange={(e) => setFormData({ ...formData, focalPhone: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-slate-900 dark:focus:border-white focus:outline-hidden text-xs"
                      placeholder="e.g. Ext: 2145 or +251911..."
                    />
                  </div>
                  <div>
                    <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 text-xs">
                      {lang === 'am' ? 'ቴሌግራም ቻናል / መገናኛ' : 'Telegram Channel / Support Handle'}
                    </label>
                    <input
                      type="text"
                      value={formData.telegramHandle}
                      onChange={(e) => setFormData({ ...formData, telegramHandle: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-slate-900 dark:focus:border-white focus:outline-hidden text-xs"
                      placeholder="e.g. @uog_maraki_clinic"
                    />
                  </div>
                </div>
              </div>

              {/* Card 4: Services & Accessibility Features */}
              <div className="p-4 rounded-2xl bg-slate-50/70 dark:bg-slate-800/40 border border-slate-200/70 dark:border-slate-800 space-y-3.5">
                <div className="flex items-center gap-2 pb-1 border-b border-slate-200/50 dark:border-slate-700/50">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-500" />
                  <h4 className="font-extrabold text-slate-900 dark:text-white text-xs uppercase tracking-wider">
                    {lang === 'am' ? '4. አገልግሎቶች እና ማካተት (Inclusivity)' : '4. Services & Accessibility Features'}
                  </h4>
                </div>

                {/* Interactive Tag Manager Component */}
                <TagInputManager
                  tags={formData.services}
                  onChange={(services) => setFormData({ ...formData, services })}
                  lang={lang}
                />

                {/* Accessibility & Verification Checkboxes */}
                <div className="pt-2 space-y-2 border-t border-slate-200/50 dark:border-slate-700/50">
                  <label className="flex items-center gap-2 text-xs font-semibold text-slate-700 dark:text-slate-300 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={formData.isWheelchairAccessible}
                      onChange={(e) => setFormData({ ...formData, isWheelchairAccessible: e.target.checked })}
                      className="rounded border-slate-300 text-slate-900 focus:ring-slate-900 dark:text-white dark:focus:ring-white cursor-pointer"
                    />
                    <span>♿ {lang === 'am' ? 'ለአካል ጉዳተኞች ምቹ የሆነ መግቢያ / መወጣጫ አለው (Wheelchair Accessible)' : 'Wheelchair & Ground Floor Accessible'}</span>
                  </label>

                  <label className="flex items-center gap-2 text-xs font-semibold text-slate-700 dark:text-slate-300 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={formData.hasPrivateRoom}
                      onChange={(e) => setFormData({ ...formData, hasPrivateRoom: e.target.checked })}
                      className="rounded border-slate-300 text-slate-900 focus:ring-slate-900 dark:text-white dark:focus:ring-white cursor-pointer"
                    />
                    <span>🔒 {lang === 'am' ? 'ሚስጥራዊ የምክር መስጫ ክፍል አለው (Private Consultation Room)' : 'Confidential / Private Consultation Room Available'}</span>
                  </label>

                  <label className="flex items-center gap-2 text-xs font-semibold text-slate-700 dark:text-slate-300 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={formData.isVerified}
                      onChange={(e) => setFormData({ ...formData, isVerified: e.target.checked })}
                      className="rounded border-slate-300 text-slate-900 focus:ring-slate-900 dark:text-white dark:focus:ring-white cursor-pointer"
                    />
                    <span>⭐ {lang === 'am' ? 'የተረጋገጠ ይፋዊ የካምፓስ ተቋም ምልክት ስጠው (Verified Badge)' : 'Mark as Officially Verified Campus Facility'}</span>
                  </label>
                </div>
              </div>

              {/* Pinned Modal Action Footer */}
              <div className="pt-2 flex items-center justify-end gap-3 shrink-0">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-4 py-2 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 font-bold rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors cursor-pointer text-xs"
                >
                  {lang === 'am' ? 'ሰርዝ' : 'Cancel'}
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-slate-950 hover:bg-slate-800 dark:bg-white dark:hover:bg-slate-100 text-white dark:text-slate-950 font-bold rounded-xl border border-slate-900 dark:border-white shadow-xs transition-all active:scale-[0.99] cursor-pointer text-xs"
                >
                  {lang === 'am' ? 'ተቋሙን መዝግብ' : 'Save Facility'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      <ConfirmModal
        isOpen={Boolean(facilityToDelete)}
        onClose={() => setFacilityToDelete(null)}
        onConfirm={async () => {
          if (facilityToDelete) {
            await onDelete(facilityToDelete.id);
          }
        }}
        title={lang === 'am' ? 'ተቋሙ ይሰረዝ?' : 'Delete Campus Facility?'}
        itemName={facilityToDelete ? (lang === 'am' ? facilityToDelete.nameAm || facilityToDelete.nameEn : facilityToDelete.nameEn) : ''}
        message={
          lang === 'am'
            ? 'ይህ እርምጃ የተቋሙን መረጃ፣ የአገልግሎት ዝርዝርና የመገኛ ካርታ ከመዝገቡ በቋሚነት ያጠፋል።'
            : 'This will permanently remove the facility, its operating hours, and location from the campus directory.'
        }
        lang={lang}
      />
    </div>
  );
};
