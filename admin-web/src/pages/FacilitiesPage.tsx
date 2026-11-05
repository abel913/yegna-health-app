import React, { useState } from 'react';
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
} from 'lucide-react';
import { Facility } from '../types/index.js';

interface FacilitiesPageProps {
  facilities: Facility[];
  lang: 'en' | 'am';
  onSave: (data: Partial<Facility>, id?: string) => Promise<void>;
  onDelete: (id: string) => Promise<void>;
}

export const FacilitiesPage: React.FC<FacilitiesPageProps> = ({
  facilities,
  lang,
  onSave,
  onDelete,
}) => {
  const [search, setSearch] = useState('');
  const [selectedSubCity, setSelectedSubCity] = useState('All');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingFacility, setEditingFacility] = useState<Facility | null>(null);

  // Form State
  const [formData, setFormData] = useState({
    nameEn: '',
    nameAm: '',
    subCity: 'Arada',
    woreda: 'Woreda 01',
    addressEn: '',
    addressAm: '',
    phone: '',
    latitude: 9.0345,
    longitude: 38.7523,
    operatingHours: '08:30 - 17:30',
    isVerified: true,
    services: ['#Youth_Friendly', '#HIV_VCT'],
  });

  const subCities = ['All', 'Arada', 'Kirkos', 'Bole', 'Lideta', 'Yeka', 'Gullele', 'Addis Ketema'];

  const filtered = facilities.filter((f) => {
    const matchesSearch =
      f.nameEn.toLowerCase().includes(search.toLowerCase()) ||
      f.nameAm.includes(search) ||
      f.subCity.toLowerCase().includes(search.toLowerCase());
    const matchesSubCity = selectedSubCity === 'All' || f.subCity === selectedSubCity;
    return matchesSearch && matchesSubCity;
  });

  const openCreateModal = () => {
    setEditingFacility(null);
    setFormData({
      nameEn: '',
      nameAm: '',
      subCity: 'Arada',
      woreda: 'Woreda 01',
      addressEn: '',
      addressAm: '',
      phone: '+251',
      latitude: 9.032,
      longitude: 38.745,
      operatingHours: '08:30 - 17:30',
      isVerified: true,
      services: ['#Youth_Friendly', '#HIV_VCT'],
    });
    setIsModalOpen(true);
  };

  const openEditModal = (f: Facility) => {
    setEditingFacility(f);
    setFormData({
      nameEn: f.nameEn,
      nameAm: f.nameAm,
      subCity: f.subCity,
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

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await onSave(formData, editingFacility ? editingFacility.id : undefined);
    setIsModalOpen(false);
  };

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 flex items-center gap-2">
            <Hospital className="text-brand-600" size={24} />
            <span>{lang === 'am' ? 'የጤና ተቋማትና ክሊኒኮች' : 'Youth Health Facilities Directory'}</span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 mt-1">
            {lang === 'am'
              ? 'በአዲስ አበባ ከተማ የሚገኙ የወጣቶች ተስማሚ የጤና ጣቢያዎችን፣ ክሊኒኮችንና የስልክ ቁጥሮችን ያስተዳድሩ።'
              : 'Manage verified youth-friendly health clinics, hotlines, GPS navigation, and specialty services.'}
          </p>
        </div>
        <button
          onClick={openCreateModal}
          className="flex items-center gap-2 px-4 py-2.5 bg-brand-600 hover:bg-brand-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md shadow-brand-600/20 transition-all self-start sm:self-auto"
        >
          <Plus size={16} />
          <span>{lang === 'am' ? '+ አዲስ ተቋም ጨምር' : '+ Add New Facility'}</span>
        </button>
      </div>

      {/* Search & Sub-City Filters */}
      <div className="bg-white p-4 rounded-2xl border border-slate-200/80 shadow-xs space-y-3">
        <div className="flex flex-col md:flex-row gap-3">
          <div className="relative flex-1">
            <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder={lang === 'am' ? 'በስም ወይም በክፍለ ከተማ ፈልግ...' : 'Search by clinic name, address, or sub-city...'}
              className="w-full pl-9 pr-4 py-2 text-xs md:text-sm bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:border-brand-500 focus:outline-none transition-all"
            />
          </div>
        </div>

        {/* Sub-City Chips */}
        <div className="flex items-center gap-1.5 overflow-x-auto pb-1 text-xs">
          <span className="text-slate-400 font-semibold mr-1">{lang === 'am' ? 'ክፍለ ከተማ:' : 'Sub-City:'}</span>
          {subCities.map((sc) => (
            <button
              key={sc}
              onClick={() => setSelectedSubCity(sc)}
              className={`px-3 py-1 rounded-lg font-bold transition-colors whitespace-nowrap ${
                selectedSubCity === sc
                  ? 'bg-brand-600 text-white'
                  : 'bg-slate-100 text-slate-600 hover:bg-slate-200/70'
              }`}
            >
              {sc}
            </button>
          ))}
        </div>
      </div>

      {/* Facilities Data Table */}
      <div className="bg-white rounded-2xl border border-slate-200/80 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs md:text-sm">
            <thead className="bg-slate-50 border-b border-slate-100 text-slate-500 font-bold uppercase text-[11px] tracking-wider">
              <tr>
                <th className="py-3 px-4">{lang === 'am' ? 'የተቋሙ ስም' : 'Facility Name'}</th>
                <th className="py-3 px-4">{lang === 'am' ? 'ክፍለ ከተማ / አድራሻ' : 'Sub-City & Address'}</th>
                <th className="py-3 px-4">{lang === 'am' ? 'ስልክ ቁጥር' : 'Contact Phone'}</th>
                <th className="py-3 px-4">{lang === 'am' ? 'አገልግሎቶች' : 'Services'}</th>
                <th className="py-3 px-4">{lang === 'am' ? 'ሁኔታ' : 'Status'}</th>
                <th className="py-3 px-4 text-right">{lang === 'am' ? 'እርምጃዎች' : 'Actions'}</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 font-medium">
              {filtered.map((f) => (
                <tr key={f.id} className="hover:bg-slate-50/70 transition-colors">
                  <td className="py-3.5 px-4">
                    <div className="flex items-center gap-2">
                      <div>
                        <p className="font-bold text-slate-900">{lang === 'am' ? f.nameAm : f.nameEn}</p>
                        <p className="text-[11px] text-slate-400">{lang === 'am' ? f.nameEn : f.nameAm}</p>
                      </div>
                    </div>
                  </td>
                  <td className="py-3.5 px-4 text-slate-600">
                    <div className="flex items-center gap-1">
                      <MapPin size={13} className="text-slate-400 flex-shrink-0" />
                      <span className="font-semibold text-slate-800">{f.subCity}</span>
                      {f.woreda && <span className="text-slate-400">• {f.woreda}</span>}
                    </div>
                    <p className="text-[11px] text-slate-400 truncate max-w-xs">{lang === 'am' ? f.addressAm : f.addressEn}</p>
                  </td>
                  <td className="py-3.5 px-4">
                    <a
                      href={`tel:${f.phone}`}
                      className="inline-flex items-center gap-1.5 text-xs font-bold text-brand-600 hover:underline"
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
                          className="px-2 py-0.5 rounded-md bg-slate-100 text-slate-700 text-[10px] font-bold"
                        >
                          {s}
                        </span>
                      ))}
                    </div>
                  </td>
                  <td className="py-3.5 px-4">
                    {f.isVerified ? (
                      <span className="inline-flex items-center gap-1 text-[11px] font-bold text-emerald-700 bg-emerald-50 px-2.5 py-0.5 rounded-full border border-emerald-200">
                        <CheckCircle2 size={12} />
                        {lang === 'am' ? 'የተረጋገጠ' : 'Verified'}
                      </span>
                    ) : (
                      <span className="inline-flex items-center text-[11px] font-bold text-amber-700 bg-amber-50 px-2.5 py-0.5 rounded-full border border-amber-200">
                        {lang === 'am' ? 'በግምገማ ላይ' : 'Pending'}
                      </span>
                    )}
                  </td>
                  <td className="py-3.5 px-4 text-right">
                    <div className="inline-flex items-center gap-1">
                      <button
                        onClick={() => openEditModal(f)}
                        className="p-1.5 text-slate-500 hover:text-brand-600 hover:bg-brand-50 rounded-lg transition-colors"
                        title="Edit Facility"
                      >
                        <Edit2 size={15} />
                      </button>
                      <button
                        onClick={() => {
                          if (confirm(`Delete ${f.nameEn}?`)) {
                            onDelete(f.id);
                          }
                        }}
                        className="p-1.5 text-slate-500 hover:text-rose-600 hover:bg-rose-50 rounded-lg transition-colors"
                        title="Delete Facility"
                      >
                        <Trash2 size={15} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
              {filtered.length === 0 && (
                <tr>
                  <td colSpan={6} className="py-12 text-center text-slate-400">
                    <Hospital size={36} className="mx-auto mb-2 opacity-40" />
                    <p className="font-semibold text-sm">{lang === 'am' ? 'ምንም ተቋም አልተገኘም' : 'No facilities match your search.'}</p>
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Add / Edit Facility Modal Dialog */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl border border-slate-200 shadow-2xl max-w-xl w-full max-h-[90vh] overflow-y-auto p-6 md:p-8 animate-in fade-in zoom-in-95 duration-150">
            <div className="flex items-center justify-between pb-4 border-b border-slate-100">
              <h3 className="text-lg font-extrabold text-slate-900">
                {editingFacility
                  ? (lang === 'am' ? 'ተቋምን አርትዕ' : 'Edit Healthcare Facility')
                  : (lang === 'am' ? 'አዲስ የጤና ተቋም መዝግብ' : 'Add New Healthcare Facility')}
              </h3>
              <button
                onClick={() => setIsModalOpen(false)}
                className="p-1 text-slate-400 hover:text-slate-600 rounded-lg hover:bg-slate-100"
              >
                <X size={20} />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="mt-5 space-y-4 text-xs md:text-sm">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Name (English)</label>
                  <input
                    type="text"
                    required
                    value={formData.nameEn}
                    onChange={(e) => setFormData({ ...formData, nameEn: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="e.g. Arada Youth Health Post"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">ስም (በአማርኛ)</label>
                  <input
                    type="text"
                    required
                    value={formData.nameAm}
                    onChange={(e) => setFormData({ ...formData, nameAm: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="ምሳሌ፡ አራዳ የወጣቶች የጤና ኬላ"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Sub-City</label>
                  <select
                    value={formData.subCity}
                    onChange={(e) => setFormData({ ...formData, subCity: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none bg-white font-medium"
                  >
                    {subCities.filter((s) => s !== 'All').map((s) => (
                      <option key={s} value={s}>{s}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Woreda / Kebele</label>
                  <input
                    type="text"
                    value={formData.woreda}
                    onChange={(e) => setFormData({ ...formData, woreda: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="Woreda 01"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Phone Number</label>
                  <input
                    type="text"
                    required
                    value={formData.phone}
                    onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="+251111223344"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Operating Hours</label>
                  <input
                    type="text"
                    value={formData.operatingHours}
                    onChange={(e) => setFormData({ ...formData, operatingHours: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="Open Now • Closes at 18:00"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">GPS Latitude</label>
                  <input
                    type="number"
                    step="any"
                    required
                    value={formData.latitude}
                    onChange={(e) => setFormData({ ...formData, latitude: parseFloat(e.target.value) || 0 })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="9.0345"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">GPS Longitude</label>
                  <input
                    type="number"
                    step="any"
                    required
                    value={formData.longitude}
                    onChange={(e) => setFormData({ ...formData, longitude: parseFloat(e.target.value) || 0 })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="38.7523"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block font-bold text-slate-700 mb-1">Address (English)</label>
                  <input
                    type="text"
                    required
                    value={formData.addressEn}
                    onChange={(e) => setFormData({ ...formData, addressEn: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="Churchill Avenue area"
                  />
                </div>
                <div>
                  <label className="block font-bold text-slate-700 mb-1">አድራሻ (በአማርኛ)</label>
                  <input
                    type="text"
                    required
                    value={formData.addressAm}
                    onChange={(e) => setFormData({ ...formData, addressAm: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl focus:border-brand-500 focus:outline-none"
                    placeholder="ቸርችል ጎዳና አካባቢ"
                  />
                </div>
              </div>

              <div className="flex items-center gap-2 pt-2">
                <input
                  type="checkbox"
                  id="isVerified"
                  checked={formData.isVerified}
                  onChange={(e) => setFormData({ ...formData, isVerified: e.target.checked })}
                  className="rounded border-slate-300 text-brand-600 focus:ring-brand-500"
                />
                <label htmlFor="isVerified" className="text-xs font-bold text-slate-700 cursor-pointer">
                  {lang === 'am' ? 'የተረጋገጠ የጤና ተቋም ምልክት ስጠው (Verified Badge)' : 'Mark as Verified Healthcare Center'}
                </label>
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-4 py-2 border border-slate-200 text-slate-600 font-bold rounded-xl hover:bg-slate-50 transition-colors"
                >
                  {lang === 'am' ? 'ሰርዝ' : 'Cancel'}
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl shadow-md shadow-brand-600/20 transition-all"
                >
                  {lang === 'am' ? 'አስቀምጥ' : 'Save Facility'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
