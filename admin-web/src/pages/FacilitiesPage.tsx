import React, { useState, useMemo, useEffect } from 'react';
import {
  Hospital,
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
  Compass,
  Download,
} from 'lucide-react';
import { Facility } from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';
import { SortableHeader, SortOrder } from '../components/common/SortableHeader.js';
import { EmptyState } from '../components/common/EmptyState.js';
import { ConfirmModal } from '../components/common/ConfirmModal.js';

interface FacilitiesPageProps {
  facilities: Facility[];
  lang: 'en' | 'am';
  onSave: (data: Partial<Facility>, id?: string) => Promise<void>;
  onDelete: (id: string) => Promise<void>;
}

export interface LocationPreset {
  id: string;
  nameEn: string;
  nameAm: string;
  category: 'uog' | 'regional' | 'addis';
  defaultLat: number;
  defaultLng: number;
}

export const LOCATION_PRESETS: LocationPreset[] = [
  // 1. University of Gondar Campuses
  { id: 'UoG - Maraki Campus', nameEn: 'UoG - Maraki Campus', nameAm: 'ዩኦጂ ማራኪ ካምፓስ', category: 'uog', defaultLat: 12.6075, defaultLng: 37.4589 },
  { id: 'UoG - Atse Tewodros Campus', nameEn: 'UoG - Atse Tewodros Campus', nameAm: 'ዩኦጂ አፄ ቴዎድሮስ ካምፓስ', category: 'uog', defaultLat: 12.6092, defaultLng: 37.4611 },
  { id: 'UoG - GCMS Referral Hospital', nameEn: 'UoG - GCMS Referral Hospital', nameAm: 'ዩኦጂ ሪፈራል ሆስፒታል (GCMS)', category: 'uog', defaultLat: 12.6033, defaultLng: 37.4522 },
  { id: 'UoG - Fasil Campus', nameEn: 'UoG - Fasil Campus', nameAm: 'ዩኦጂ ፋሲል ካምፓስ', category: 'uog', defaultLat: 12.6135, defaultLng: 37.4720 },

  // 2. Regional Cities & Hubs
  { id: 'Gondar City', nameEn: 'Gondar City', nameAm: 'ጎንደር ከተማ', category: 'regional', defaultLat: 12.6030, defaultLng: 37.4521 },
  { id: 'Bahir Dar', nameEn: 'Bahir Dar', nameAm: 'ባሕር ዳር', category: 'regional', defaultLat: 11.5742, defaultLng: 37.3614 },
  { id: 'Hawassa', nameEn: 'Hawassa', nameAm: 'ሐዋሳ', category: 'regional', defaultLat: 7.0504, defaultLng: 38.4955 },
  { id: 'Mekelle', nameEn: 'Mekelle', nameAm: 'መቐለ', category: 'regional', defaultLat: 13.4967, defaultLng: 39.4753 },
  { id: 'Jimma', nameEn: 'Jimma', nameAm: 'ጅማ', category: 'regional', defaultLat: 7.6734, defaultLng: 36.8344 },

  // 3. Addis Ababa Sub-Cities
  { id: 'Arada', nameEn: 'Arada (Addis Ababa)', nameAm: 'አራዳ (አዲስ አበባ)', category: 'addis', defaultLat: 9.0345, defaultLng: 38.7523 },
  { id: 'Kirkos', nameEn: 'Kirkos (Addis Ababa)', nameAm: 'ቂርቆስ (አዲስ አበባ)', category: 'addis', defaultLat: 9.0125, defaultLng: 38.7610 },
  { id: 'Bole', nameEn: 'Bole (Addis Ababa)', nameAm: 'ቦሌ (አዲስ አበባ)', category: 'addis', defaultLat: 8.9950, defaultLng: 38.7890 },
  { id: 'Lideta', nameEn: 'Lideta (Addis Ababa)', nameAm: 'ልደታ (አዲስ አበባ)', category: 'addis', defaultLat: 9.0150, defaultLng: 38.7380 },
  { id: 'Yeka', nameEn: 'Yeka (Addis Ababa)', nameAm: 'የካ (አዲስ አበባ)', category: 'addis', defaultLat: 9.0410, defaultLng: 38.7950 },
  { id: 'Gullele', nameEn: 'Gullele (Addis Ababa)', nameAm: 'ጉለሌ (አዲስ አበባ)', category: 'addis', defaultLat: 9.0680, defaultLng: 38.7300 },
  { id: 'Addis Ketema', nameEn: 'Addis Ketema (Addis Ababa)', nameAm: 'አዲስ ከተማ (አዲስ አበባ)', category: 'addis', defaultLat: 9.0350, defaultLng: 38.7300 },
];

export const FacilitiesPage: React.FC<FacilitiesPageProps> = ({
  facilities,
  lang,
  onSave,
  onDelete,
}) => {
  const [search, setSearch] = useState('');
  const [regionFilter, setRegionFilter] = useState<'all' | 'uog' | 'regional' | 'addis'>('all');
  const [selectedSubCity, setSelectedSubCity] = useState('All');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingFacility, setEditingFacility] = useState<Facility | null>(null);
  const [facilityToDelete, setFacilityToDelete] = useState<Facility | null>(null);

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
    subCity: 'UoG - Maraki Campus',
    customSubCity: '',
    woreda: 'Student Clinic',
    addressEn: '',
    addressAm: '',
    phone: '+251',
    latitude: 12.6075,
    longitude: 37.4589,
    operatingHours: '08:30 - 17:30',
    isVerified: true,
    services: ['#Youth_Friendly', '#SRH_Counseling', '#Free_Condoms'],
  });

  const [isCustomLocation, setIsCustomLocation] = useState(false);

  // Available subcities based on region tab
  const activePresets = regionFilter === 'all'
    ? LOCATION_PRESETS
    : LOCATION_PRESETS.filter((p) => p.category === regionFilter);

  const filtered = facilities.filter((f) => {
    const matchesSearch =
      f.nameEn.toLowerCase().includes(search.toLowerCase()) ||
      f.nameAm.includes(search) ||
      f.subCity.toLowerCase().includes(search.toLowerCase()) ||
      (f.addressEn && f.addressEn.toLowerCase().includes(search.toLowerCase())) ||
      (f.addressAm && f.addressAm.includes(search));

    const matchesPreset = selectedSubCity === 'All' || f.subCity === selectedSubCity;

    let matchesRegion = true;
    if (regionFilter !== 'all') {
      const preset = LOCATION_PRESETS.find((p) => p.id === f.subCity);
      if (preset) {
        matchesRegion = preset.category === regionFilter;
      } else if (regionFilter === 'uog') {
        matchesRegion = f.subCity.toLowerCase().includes('uog') || f.subCity.toLowerCase().includes('gondar');
      } else if (regionFilter === 'addis') {
        matchesRegion = ['arada', 'kirkos', 'bole', 'lideta', 'yeka', 'gullele', 'addis ketema'].includes(f.subCity.toLowerCase());
      }
    }

    return matchesSearch && matchesPreset && matchesRegion;
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
      subCity: 'UoG - Maraki Campus',
      customSubCity: '',
      woreda: 'Student Clinic',
      addressEn: '',
      addressAm: '',
      phone: '+251',
      latitude: 12.6075,
      longitude: 37.4589,
      operatingHours: '08:30 - 17:30',
      isVerified: true,
      services: ['#Youth_Friendly', '#SRH_Counseling', '#Free_Condoms'],
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
      subCity: isKnownPreset ? f.subCity : '__custom__',
      customSubCity: isKnownPreset ? '' : f.subCity,
      woreda: f.woreda || '',
      addressEn: f.addressEn,
      addressAm: f.addressAm,
      phone: f.phone,
      latitude: f.latitude,
      longitude: f.longitude,
      operatingHours: f.operatingHours,
      isVerified: f.isVerified,
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
      subCity: finalSubCity,
      woreda: formData.woreda,
      addressEn: formData.addressEn,
      addressAm: formData.addressAm,
      phone: formData.phone,
      latitude: formData.latitude,
      longitude: formData.longitude,
      operatingHours: formData.operatingHours,
      isVerified: formData.isVerified,
      services: formData.services,
    };

    await onSave(payload, editingFacility ? editingFacility.id : undefined);
    setIsModalOpen(false);
  };

  const getLocationBadge = (subCity: string) => {
    const isUog = subCity.toLowerCase().includes('uog') || subCity.toLowerCase().includes('gondar');
    const isRegional = ['bahir dar', 'hawassa', 'mekelle', 'jimma'].some((c) => subCity.toLowerCase().includes(c));

    if (isUog) {
      return (
        <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-md bg-indigo-50 border border-indigo-200 text-indigo-700 text-[11px] font-extrabold tracking-wide">
          <GraduationCap size={13} className="text-indigo-600" />
          <span>{subCity}</span>
        </span>
      );
    }

    if (isRegional) {
      return (
        <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-md bg-emerald-50 border border-emerald-200 text-emerald-800 text-[11px] font-extrabold tracking-wide">
          <Compass size={13} className="text-emerald-600" />
          <span>{subCity}</span>
        </span>
      );
    }

    return (
      <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-md bg-slate-100 text-slate-800 text-[11px] font-bold">
        <Building2 size={13} className="text-slate-500" />
        <span>{subCity}</span>
      </span>
    );
  };

  const handleExportCsv = () => {
    exportToCsv(
      'Yegna_Health_Facilities_Directory',
      [
        { header: 'Facility Name (English)', accessor: (f) => f.nameEn },
        { header: 'Facility Name (Amharic)', accessor: (f) => f.nameAm },
        { header: 'Campus / City', accessor: (f) => f.subCity },
        { header: 'Ward / Woreda', accessor: (f) => f.woreda || '' },
        { header: 'Contact Phone', accessor: (f) => f.phone },
        { header: 'Operating Hours', accessor: (f) => f.operatingHours },
        { header: 'Address (English)', accessor: (f) => f.addressEn },
        { header: 'Address (Amharic)', accessor: (f) => f.addressAm },
        { header: 'GPS Latitude', accessor: (f) => f.latitude },
        { header: 'GPS Longitude', accessor: (f) => f.longitude },
        { header: 'Verification Status', accessor: (f) => (f.isVerified ? 'VERIFIED' : 'PENDING') },
        { header: 'Services', accessor: (f) => (f.services || []).join('; ') },
      ],
      filtered
    );
  };

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 flex items-center gap-2">
            <Hospital className="text-brand-600" size={24} />
            <span>{lang === 'am' ? 'የጤና ተቋማትና ክሊኒኮች ማዕከል' : 'Campus & Regional Health Facilities CMS'}</span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 mt-1">
            {lang === 'am'
              ? 'የጎንደር ዩኒቨርሲቲ ካምፓሶችን፣ የክልል ከተሞችንና የአዲስ አበባ የወጣቶች ተስማሚ የጤና ተቋማትን ያስተዳድሩ።'
              : 'Manage verified campus clinics (University of Gondar), regional centers, and youth-friendly health posts.'}
          </p>
        </div>
        <div className="flex items-center gap-2 self-start sm:self-auto">
          <button
            onClick={handleExportCsv}
            className="flex items-center gap-1.5 px-3.5 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs md:text-sm font-bold rounded-xl border border-slate-200 transition-all cursor-pointer"
            title={lang === 'am' ? 'ወደ ኤክሴል (CSV) አውርድ' : 'Export directory to Excel CSV'}
          >
            <Download size={15} />
            <span>{lang === 'am' ? 'ሪፖርት (CSV)' : 'Export CSV'}</span>
          </button>
          <button
            onClick={openCreateModal}
            className="flex items-center gap-2 px-4 py-2.5 bg-brand-600 hover:bg-brand-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md shadow-brand-600/20 transition-all cursor-pointer"
          >
            <Plus size={16} />
            <span>{lang === 'am' ? '+ አዲስ ተቋም ጨምር' : '+ Add Health Facility'}</span>
          </button>
        </div>
      </div>

      {/* Search & Location Filters */}
      <div className="bg-white p-4 md:p-5 rounded-2xl border border-slate-200/80 shadow-xs space-y-4">
        <div className="flex flex-col md:flex-row gap-3">
          <div className="relative flex-1">
            <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder={
                lang === 'am'
                  ? 'በተቋም ስም፣ በካምፓስ ወይም በከተማ ፈልግ...'
                  : 'Search by clinic name, campus (e.g. Maraki), city, or address...'
              }
              className="w-full pl-9 pr-4 py-2 text-xs md:text-sm bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:border-brand-500 focus:outline-none transition-all"
            />
          </div>
        </div>

        {/* Region Categorization Tabs */}
        <div className="flex flex-wrap items-center gap-2 pt-1 border-t border-slate-100">
          <span className="text-xs font-bold text-slate-400 mr-1">
            {lang === 'am' ? 'ክልል / ካምፓስ:' : 'Region:'}
          </span>
          <button
            onClick={() => {
              setRegionFilter('all');
              setSelectedSubCity('All');
            }}
            className={`px-3 py-1 rounded-xl text-xs font-bold transition-all ${
              regionFilter === 'all'
                ? 'bg-slate-900 text-white shadow-xs'
                : 'bg-slate-100 text-slate-600 hover:bg-slate-200/80'
            }`}
          >
            {lang === 'am' ? 'ሁሉም አካባቢዎች' : 'All Locations'} ({facilities.length})
          </button>
          <button
            onClick={() => {
              setRegionFilter('uog');
              setSelectedSubCity('All');
            }}
            className={`px-3 py-1 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 ${
              regionFilter === 'uog'
                ? 'bg-indigo-600 text-white shadow-xs'
                : 'bg-indigo-50 text-indigo-700 hover:bg-indigo-100/80 border border-indigo-200/60'
            }`}
          >
            <GraduationCap size={14} />
            <span>{lang === 'am' ? 'የጎንደር ዩኒቨርሲቲ ካምፓሶች' : 'University of Gondar'}</span>
          </button>
          <button
            onClick={() => {
              setRegionFilter('regional');
              setSelectedSubCity('All');
            }}
            className={`px-3 py-1 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 ${
              regionFilter === 'regional'
                ? 'bg-emerald-600 text-white shadow-xs'
                : 'bg-emerald-50 text-emerald-800 hover:bg-emerald-100/80 border border-emerald-200/60'
            }`}
          >
            <Compass size={14} />
            <span>{lang === 'am' ? 'የክልል ከተሞች' : 'Regional Hubs'}</span>
          </button>
          <button
            onClick={() => {
              setRegionFilter('addis');
              setSelectedSubCity('All');
            }}
            className={`px-3 py-1 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 ${
              regionFilter === 'addis'
                ? 'bg-brand-600 text-white shadow-xs'
                : 'bg-brand-50 text-brand-800 hover:bg-brand-100/80 border border-brand-200/60'
            }`}
          >
            <Building2 size={14} />
            <span>{lang === 'am' ? 'አዲስ አበባ' : 'Addis Ababa'}</span>
          </button>
        </div>

        {/* Specific SubCity / Campus Pills */}
        <div className="flex items-center gap-1.5 overflow-x-auto pb-1 text-xs">
          <button
            onClick={() => setSelectedSubCity('All')}
            className={`px-2.5 py-1 rounded-lg font-bold transition-colors whitespace-nowrap ${
              selectedSubCity === 'All'
                ? 'bg-brand-600 text-white'
                : 'bg-slate-100 text-slate-600 hover:bg-slate-200/70'
            }`}
          >
            {lang === 'am' ? 'ሁሉም ንዑስ አካባቢዎች' : 'All Sub-Locations'}
          </button>
          {activePresets.map((preset) => (
            <button
              key={preset.id}
              onClick={() => setSelectedSubCity(preset.id)}
              className={`px-2.5 py-1 rounded-lg font-bold transition-colors whitespace-nowrap ${
                selectedSubCity === preset.id
                  ? 'bg-brand-600 text-white'
                  : 'bg-slate-100 text-slate-600 hover:bg-slate-200/70'
              }`}
            >
              {lang === 'am' ? preset.nameAm : preset.nameEn}
            </button>
          ))}
        </div>
      </div>

      {/* Facilities Data Table */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs md:text-sm">
            <thead className="bg-slate-50 dark:bg-slate-800/80 border-b border-slate-100 dark:border-slate-800 text-slate-500 dark:text-slate-400 font-bold uppercase text-[11px] tracking-wider">
              <tr>
                <SortableHeader
                  label={lang === 'am' ? 'የተቋሙ ስም' : 'Facility Name'}
                  field="name"
                  currentField={sortField}
                  currentOrder={sortOrder}
                  onSort={handleSort}
                />
                <SortableHeader
                  label={lang === 'am' ? 'ካምፓስ / ከተማ / አድራሻ' : 'Campus / City & Address'}
                  field="subCity"
                  currentField={sortField}
                  currentOrder={sortOrder}
                  onSort={handleSort}
                />
                <SortableHeader
                  label={lang === 'am' ? 'ስልክ ቁጥር' : 'Contact Phone'}
                  field="phone"
                  currentField={sortField}
                  currentOrder={sortOrder}
                  onSort={handleSort}
                />
                <th className="py-3 px-4">{lang === 'am' ? 'አገልግሎቶች' : 'Services'}</th>
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
              {sortedFacilities.map((f) => (
                <tr key={f.id} className="hover:bg-slate-50/70 dark:hover:bg-slate-800/50 transition-colors">
                  <td className="py-3.5 px-4">
                    <div>
                      <p className="font-bold text-slate-900 dark:text-white">{lang === 'am' ? f.nameAm : f.nameEn}</p>
                      <p className="text-[11px] text-slate-400 dark:text-slate-500">{lang === 'am' ? f.nameEn : f.nameAm}</p>
                    </div>
                  </td>
                  <td className="py-3.5 px-4 text-slate-600 dark:text-slate-300">
                    <div className="flex items-center gap-1.5 mb-1">
                      {getLocationBadge(f.subCity)}
                      {f.woreda && <span className="text-slate-400 dark:text-slate-500 text-xs">• {f.woreda}</span>}
                    </div>
                    <div className="flex items-center gap-1 text-[11px] text-slate-400 dark:text-slate-500 truncate max-w-xs">
                      <MapPin size={11} className="text-slate-400 dark:text-slate-500 flex-shrink-0" />
                      <span>{lang === 'am' ? f.addressAm : f.addressEn}</span>
                    </div>
                  </td>
                  <td className="py-3.5 px-4">
                    <a
                      href={`tel:${f.phone}`}
                      className="inline-flex items-center gap-1.5 text-xs font-bold text-brand-600 dark:text-cyan-400 hover:underline"
                    >
                      <Phone size={12} />
                      {f.phone}
                    </a>
                  </td>
                  <td className="py-3.5 px-4">
                    <div className="flex flex-wrap gap-1 max-w-xs">
                      {(f.services || []).map((s, idx) => (
                        <span
                          key={idx}
                          className="px-2 py-0.5 rounded-md bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 text-[10px] font-bold border border-slate-200/60 dark:border-slate-700"
                        >
                          {s}
                        </span>
                      ))}
                    </div>
                  </td>
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
                  <td className="py-3.5 px-4 text-right">
                    <div className="inline-flex items-center gap-1">
                      <button
                        onClick={() => openEditModal(f)}
                        className="p-1.5 text-slate-500 hover:text-brand-600 dark:hover:text-cyan-400 hover:bg-brand-50 dark:hover:bg-slate-800 rounded-lg transition-colors cursor-pointer"
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
                  icon={Hospital}
                  title={lang === 'am' ? 'ምንም የጤና ተቋም አልተገኘም' : 'No health facilities found'}
                  description={
                    search || selectedSubCity !== 'All' || regionFilter !== 'all'
                      ? lang === 'am'
                        ? 'በተመረጡት ማጣሪያዎች የሚገኝ ተቋም የለም። እባክዎ ማጣሪያዎቹን ያጽዱ ወይም አዲስ ተቋም ይመዝግቡ።'
                        : 'No campus clinics match your current search and location filter criteria.'
                      : lang === 'am'
                      ? 'እስካሁን የተመዘገበ የጤና ተቋም የለም። የመጀመሪያውን ተቋም እዚህ ይመዝግቡ።'
                      : 'No healthcare clinics or youth posts registered yet.'
                  }
                  clearLabel={
                    search || selectedSubCity !== 'All' || regionFilter !== 'all'
                      ? lang === 'am'
                        ? 'ማጣሪያዎችን አጽዳ'
                        : 'Reset Filters'
                      : undefined
                  }
                  onClear={() => {
                    setSearch('');
                    setSelectedSubCity('All');
                    setRegionFilter('all');
                  }}
                  actionLabel={lang === 'am' ? '+ አዲስ ክሊኒክ መዝግብ' : '+ Add Facility'}
                  onAction={openCreateModal}
                />
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Add / Edit Facility Modal Dialog */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-950/60 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-xl w-full max-h-[90vh] overflow-y-auto p-6 md:p-8 animate-in fade-in zoom-in-95 duration-150">
            <div className="flex items-center justify-between pb-4 border-b border-slate-100 dark:border-slate-800">
              <h3 className="text-lg font-extrabold text-slate-900 dark:text-white">
                {editingFacility
                  ? (lang === 'am' ? 'የጤና ተቋምን አርትዕ' : 'Edit Healthcare Facility')
                  : (lang === 'am' ? 'አዲስ የጤና ተቋም መዝግብ' : 'Add New Healthcare Facility')}
              </h3>
              <button
                onClick={() => setIsModalOpen(false)}
                className="p-1 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800 cursor-pointer"
              >
                <X size={20} />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="mt-5 space-y-4 text-xs md:text-sm">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    {lang === 'am' ? 'የተቋሙ ስም (እንግሊዝኛ)' : 'Facility Name (English)'}
                  </label>
                  <input
                    type="text"
                    required
                    value={formData.nameEn}
                    onChange={(e) => setFormData({ ...formData, nameEn: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                    placeholder="e.g. UoG Maraki Youth Health Clinic"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    {lang === 'am' ? 'የተቋሙ ስም (በአማርኛ)' : 'Facility Name (Amharic)'}
                  </label>
                  <input
                    type="text"
                    required
                    value={formData.nameAm}
                    onChange={(e) => setFormData({ ...formData, nameAm: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                    placeholder="ምሳሌ፡ የጎንደር ዩኒቨርሲቲ ማራኪ የወጣቶች ክሊኒክ"
                  />
                </div>
              </div>

              {/* Campus / Location Selector */}
              <div className="space-y-2">
                <label className="block font-bold text-slate-700 dark:text-slate-300">
                  {lang === 'am' ? 'ካምፓስ ወይም የከተማ አካባቢ' : 'Campus / Regional City / Sub-City'}
                </label>
                <select
                  value={isCustomLocation ? '__custom__' : formData.subCity}
                  onChange={(e) => handleLocationPresetChange(e.target.value)}
                  className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl focus:border-brand-500 focus:outline-hidden bg-white dark:bg-slate-800 font-medium text-slate-800 dark:text-slate-200"
                >
                  <optgroup label="University of Gondar Campuses" className="dark:bg-slate-800 dark:text-white">
                    {LOCATION_PRESETS.filter((p) => p.category === 'uog').map((p) => (
                      <option key={p.id} value={p.id}>
                        {p.nameEn} ({p.nameAm})
                      </option>
                    ))}
                  </optgroup>
                  <optgroup label="Regional Cities & Health Hubs" className="dark:bg-slate-800 dark:text-white">
                    {LOCATION_PRESETS.filter((p) => p.category === 'regional').map((p) => (
                      <option key={p.id} value={p.id}>
                        {p.nameEn} ({p.nameAm})
                      </option>
                    ))}
                  </optgroup>
                  <optgroup label="Addis Ababa Sub-Cities" className="dark:bg-slate-800 dark:text-white">
                    {LOCATION_PRESETS.filter((p) => p.category === 'addis').map((p) => (
                      <option key={p.id} value={p.id}>
                        {p.nameEn} ({p.nameAm})
                      </option>
                    ))}
                  </optgroup>
                  <optgroup label="Custom Location" className="dark:bg-slate-800 dark:text-white">
                    <option value="__custom__">
                      {lang === 'am' ? '+ የተለየ ካምፓስ ወይም ከተማ በጽሑፍ ጻፍ...' : '+ Custom Campus / City Name...'}
                    </option>
                  </optgroup>
                </select>

                {/* Conditional Custom Location Input */}
                {isCustomLocation && (
                  <div className="animate-in fade-in duration-150 pt-1">
                    <label className="block font-semibold text-slate-600 dark:text-slate-400 text-xs mb-1">
                      {lang === 'am' ? 'የተለየ ካምፓስ ወይም ከተማ ስም ያስገቡ' : 'Enter Custom Campus or Location Name'}
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.customSubCity}
                      onChange={(e) => setFormData({ ...formData, customSubCity: e.target.value })}
                      className="w-full px-3 py-2 border border-brand-300 dark:border-brand-700 bg-brand-50/30 dark:bg-brand-950/30 text-slate-900 dark:text-white rounded-xl focus:border-brand-500 focus:outline-hidden text-xs"
                      placeholder="e.g. Debre Berhan Campus or Jimma Specialized Clinic"
                    />
                  </div>
                )}
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    {lang === 'am' ? 'ክፍል / ወረዳ' : 'Branch / Ward / Woreda'}
                  </label>
                  <input
                    type="text"
                    value={formData.woreda}
                    onChange={(e) => setFormData({ ...formData, woreda: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                    placeholder="e.g. Student Health Wing"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    {lang === 'am' ? 'የሥራ ሰዓት' : 'Operating Hours'}
                  </label>
                  <input
                    type="text"
                    value={formData.operatingHours}
                    onChange={(e) => setFormData({ ...formData, operatingHours: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                    placeholder="Open 24/7 or 08:30 - 17:30"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    {lang === 'am' ? 'ስልክ ቁጥር' : 'Direct Phone Contact'}
                  </label>
                  <input
                    type="text"
                    required
                    value={formData.phone}
                    onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                    placeholder="+251581141234"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    {lang === 'am' ? 'አገልግሎቶች (በኮማ የተለዩ)' : 'Services (#Tags separated by comma)'}
                  </label>
                  <input
                    type="text"
                    value={formData.services.join(', ')}
                    onChange={(e) =>
                      setFormData({
                        ...formData,
                        services: e.target.value.split(',').map((s) => s.trim()).filter(Boolean),
                      })
                    }
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                    placeholder="#Youth_Friendly, #HIV_VCT, #MentalHealth"
                  />
                </div>
              </div>

              {/* GPS Coordinates with Default Preset Indicator */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 flex items-center justify-between">
                    <span>{lang === 'am' ? 'GPS ኬክሮስ (Latitude)' : 'GPS Latitude'}</span>
                    <span className="text-[10px] text-slate-400 dark:text-slate-500 font-normal">Auto-preset available</span>
                  </label>
                  <input
                    type="number"
                    step="any"
                    required
                    value={formData.latitude}
                    onChange={(e) => setFormData({ ...formData, latitude: parseFloat(e.target.value) || 0 })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                    placeholder="12.6075"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1 flex items-center justify-between">
                    <span>{lang === 'am' ? 'GPS ኬንትሮስ (Longitude)' : 'GPS Longitude'}</span>
                    <span className="text-[10px] text-slate-400 dark:text-slate-500 font-normal">Auto-preset available</span>
                  </label>
                  <input
                    type="number"
                    step="any"
                    required
                    value={formData.longitude}
                    onChange={(e) => setFormData({ ...formData, longitude: parseFloat(e.target.value) || 0 })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                    placeholder="37.4589"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    {lang === 'am' ? 'አድራሻ (በእንግሊዝኛ)' : 'Physical Address (English)'}
                  </label>
                  <input
                    type="text"
                    required
                    value={formData.addressEn}
                    onChange={(e) => setFormData({ ...formData, addressEn: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                    placeholder="Inside Maraki Campus, Student Services Building"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                    {lang === 'am' ? 'አድራሻ (በአማርኛ)' : 'Physical Address (Amharic)'}
                  </label>
                  <input
                    type="text"
                    required
                    value={formData.addressAm}
                    onChange={(e) => setFormData({ ...formData, addressAm: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:border-brand-500 focus:outline-hidden"
                    placeholder="ማራኪ ካምፓስ ውስጥ፣ የተማሪዎች አገልግሎት ሕንፃ"
                  />
                </div>
              </div>

              <div className="flex items-center gap-2 pt-2">
                <input
                  type="checkbox"
                  id="isVerified"
                  checked={formData.isVerified}
                  onChange={(e) => setFormData({ ...formData, isVerified: e.target.checked })}
                  className="rounded border-slate-300 text-brand-600 focus:ring-brand-500 cursor-pointer accent-brand-600"
                />
                <label htmlFor="isVerified" className="text-xs font-bold text-slate-700 dark:text-slate-300 cursor-pointer">
                  {lang === 'am' ? 'የተረጋገጠ ይፋዊ የጤና ተቋም ምልክት ስጠው (Verified Badge)' : 'Mark as Officially Verified Healthcare Center'}
                </label>
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-slate-100 dark:border-slate-800">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-4 py-2 border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 font-bold rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors cursor-pointer"
                >
                  {lang === 'am' ? 'ሰርዝ' : 'Cancel'}
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl shadow-md shadow-brand-600/20 transition-all cursor-pointer"
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
        title={lang === 'am' ? 'የጤና ተቋሙ ይሰረዝ?' : 'Delete Healthcare Facility?'}
        itemName={facilityToDelete ? (lang === 'am' ? facilityToDelete.nameAm || facilityToDelete.nameEn : facilityToDelete.nameEn) : ''}
        message={
          lang === 'am'
            ? 'ይህ እርምጃ የተቋሙን መረጃ፣ የአገልግሎት ዝርዝርና የመገኛ ካርታ ከመዝገቡ በቋሚነት ያጠፋል።'
            : 'This will permanently remove the clinic, its operating hours, and location from the youth healthcare network.'
        }
        lang={lang}
      />
    </div>
  );
};
