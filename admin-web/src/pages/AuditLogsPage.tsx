import React, { useState, useMemo, useEffect } from 'react';
import {
  History,
  Clock,
  Download,
  Search,
  X,
  RotateCcw,
  Eye,
  ChevronLeft,
  ChevronRight,
  Activity,
  PlusCircle,
  Edit3,
  Trash2,
} from 'lucide-react';
import { AuditLog } from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';
import { SortableHeader, SortOrder } from '../components/common/SortableHeader.js';
import { EmptyState } from '../components/common/EmptyState.js';
import { DateRangePicker, DatePreset } from '../components/common/DateRangePicker.js';
import {
  AuditDetailModal,
  getActionTheme,
  getRelativeTime,
} from '../components/audit/AuditDetailModal.js';

interface AuditLogsPageProps {
  logs: AuditLog[];
  lang: 'en' | 'am';
}

export const AuditLogsPage: React.FC<AuditLogsPageProps> = ({ logs, lang }) => {
  // 1. Filter States
  const [search, setSearch] = useState('');
  const [datePreset, setDatePreset] = useState<DatePreset>('ALL');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('ALL');
  const [opFilter, setOpFilter] = useState('ALL');
  const [actorFilter, setActorFilter] = useState('ALL');

  // 2. Sort & Pagination States
  const [sortField, setSortField] = useState<string>('timestamp');
  const [sortOrder, setSortOrder] = useState<SortOrder>('desc');
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  // 3. Inspection Modal State
  const [selectedLog, setSelectedLog] = useState<AuditLog | null>(null);

  // Extract distinct admin actors from logs
  const uniqueActors = useMemo(() => {
    const set = new Set<string>();
    logs.forEach((l) => {
      if (l.adminEmail) set.add(l.adminEmail);
    });
    return Array.from(set).sort();
  }, [logs]);

  // Handle Sort
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

  // Reset to page 1 whenever any filter changes
  useEffect(() => {
    setCurrentPage(1);
  }, [search, datePreset, startDate, endDate, categoryFilter, opFilter, actorFilter]);

  // Category Tabs Definition
  const categories = [
    { id: 'ALL', labelEn: 'All Events', labelAm: 'ሁሉም' },
    { id: 'FACILITY', labelEn: 'Facilities', labelAm: 'ተቋማት' },
    { id: 'MENTOR', labelEn: 'Counselors', labelAm: 'አማካሪዎች' },
    { id: 'CONTENT', labelEn: 'Curriculum & Quiz', labelAm: 'ትምህርትና ፈተና' },
    { id: 'CLUB', labelEn: 'Student Clubs', labelAm: 'ክለቦች' },
    { id: 'USER_SAFETY', labelEn: 'User Safety', labelAm: 'የተጠቃሚ ደህንነት' },
    { id: 'SECURITY', labelEn: 'Security & Auth', labelAm: 'ደህንነት' },
  ];

  // Operation Type Options
  const opOptions = [
    { id: 'ALL', labelEn: 'All Operations', labelAm: 'ሁሉም ተግባራት' },
    { id: 'CREATE', labelEn: 'Creations & Additions', labelAm: 'አዲስ ምዝገባዎች' },
    { id: 'UPDATE', labelEn: 'Modifications & Edits', labelAm: 'ማሻሻያዎች' },
    { id: 'DELETE', labelEn: 'Deletions & Removals', labelAm: 'ስረዛዎች' },
    { id: 'MODERATION', labelEn: 'Suspensions & Security', labelAm: 'እገዳና ደህንነት' },
  ];

  // Date Filtering Predicate
  const isWithinDateRange = (timestampStr: string) => {
    const time = new Date(timestampStr).getTime();
    const now = new Date();

    if (datePreset === 'ALL') return true;

    if (datePreset === 'TODAY') {
      const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime();
      return time >= startOfToday;
    }

    if (datePreset === '7D') {
      const sevenDaysAgo = now.getTime() - 7 * 24 * 60 * 60 * 1000;
      return time >= sevenDaysAgo;
    }

    if (datePreset === '30D') {
      const thirtyDaysAgo = now.getTime() - 30 * 24 * 60 * 60 * 1000;
      return time >= thirtyDaysAgo;
    }

    if (datePreset === 'THIS_MONTH') {
      const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1).getTime();
      return time >= startOfMonth;
    }

    if (datePreset === 'CUSTOM') {
      if (startDate) {
        const start = new Date(startDate).getTime();
        if (time < start) return false;
      }
      if (endDate) {
        const end = new Date(`${endDate}T23:59:59.999`).getTime();
        if (time > end) return false;
      }
      return true;
    }

    return true;
  };

  // 4. Multi-Filter Engine
  const filteredLogs = useMemo(() => {
    const q = search.trim().toLowerCase();

    return logs.filter((log) => {
      // 1. Text Search
      if (q) {
        const matchesQ =
          log.action.toLowerCase().includes(q) ||
          log.adminEmail.toLowerCase().includes(q) ||
          log.details.toLowerCase().includes(q);
        if (!matchesQ) return false;
      }

      // 2. Date Range
      if (!isWithinDateRange(log.timestamp)) return false;

      // 3. Category Filter
      const act = log.action.toUpperCase();
      if (categoryFilter !== 'ALL') {
        if (categoryFilter === 'FACILITY' && !act.includes('FACILITY')) return false;
        if (categoryFilter === 'MENTOR' && !act.includes('MENTOR')) return false;
        if (
          categoryFilter === 'CONTENT' &&
          !(act.includes('MODULE') || act.includes('QUIZ') || act.includes('QUESTION') || act.includes('TOPIC'))
        )
          return false;
        if (categoryFilter === 'CLUB' && !act.includes('CLUB')) return false;
        if (
          categoryFilter === 'USER_SAFETY' &&
          !(act.includes('USER') || act.includes('ROLE') || act.includes('SUSPEND') || act.includes('REINSTATE'))
        )
          return false;
        if (
          categoryFilter === 'SECURITY' &&
          !(act.includes('AUTH') || act.includes('LOGIN') || act.includes('LOGOUT'))
        )
          return false;
      }

      // 4. Operation Filter
      if (opFilter !== 'ALL') {
        if (
          opFilter === 'CREATE' &&
          !(act.includes('CREATE') || act.includes('APPROVE') || act.includes('REINSTATE'))
        )
          return false;
        if (
          opFilter === 'UPDATE' &&
          !(act.includes('UPDATE') || act.includes('EDIT') || act.includes('CHANGE'))
        )
          return false;
        if (opFilter === 'DELETE' && !(act.includes('DELETE') || act.includes('REMOVE')))
          return false;
        if (
          opFilter === 'MODERATION' &&
          !(act.includes('SUSPEND') || act.includes('ROLE') || act.includes('AUTH'))
        )
          return false;
      }

      // 5. Actor Filter
      if (actorFilter !== 'ALL' && log.adminEmail !== actorFilter) {
        return false;
      }

      return true;
    });
  }, [logs, search, datePreset, startDate, endDate, categoryFilter, opFilter, actorFilter]);

  // 5. Sort Engine
  const sortedLogs = useMemo(() => {
    if (!sortOrder) return filteredLogs;
    return [...filteredLogs].sort((a, b) => {
      let valA: any = '';
      let valB: any = '';
      if (sortField === 'timestamp') {
        valA = new Date(a.timestamp).getTime();
        valB = new Date(b.timestamp).getTime();
      } else if (sortField === 'action') {
        valA = a.action;
        valB = b.action;
      } else if (sortField === 'adminEmail') {
        valA = a.adminEmail.toLowerCase();
        valB = b.adminEmail.toLowerCase();
      }
      if (valA < valB) return sortOrder === 'asc' ? -1 : 1;
      if (valA > valB) return sortOrder === 'asc' ? 1 : -1;
      return 0;
    });
  }, [filteredLogs, sortField, sortOrder]);

  // 6. Pagination Slicing
  const totalPages = Math.max(1, Math.ceil(sortedLogs.length / pageSize));
  const safeCurrentPage = Math.min(currentPage, totalPages);
  const paginatedLogs = useMemo(() => {
    const start = (safeCurrentPage - 1) * pageSize;
    return sortedLogs.slice(start, start + pageSize);
  }, [sortedLogs, safeCurrentPage, pageSize]);

  // 7. Dynamic Summary KPI Stats
  const stats = useMemo(() => {
    let creations = 0;
    let updates = 0;
    let moderations = 0;
    const actorsSet = new Set<string>();

    for (const log of filteredLogs) {
      const a = log.action.toUpperCase();
      if (a.includes('CREATE') || a.includes('APPROVE') || a.includes('REINSTATE')) creations++;
      else if (a.includes('UPDATE') || a.includes('EDIT') || a.includes('CHANGE')) updates++;
      else if (a.includes('DELETE') || a.includes('SUSPEND') || a.includes('REMOVE')) moderations++;
      if (log.adminEmail) actorsSet.add(log.adminEmail);
    }

    return {
      total: filteredLogs.length,
      creations,
      updates,
      moderations,
      uniqueActors: actorsSet.size,
    };
  }, [filteredLogs]);

  // Check if any filter is active
  const isFilterActive =
    Boolean(search) ||
    datePreset !== 'ALL' ||
    categoryFilter !== 'ALL' ||
    opFilter !== 'ALL' ||
    actorFilter !== 'ALL' ||
    Boolean(startDate) ||
    Boolean(endDate);

  const handleResetFilters = () => {
    setSearch('');
    setDatePreset('ALL');
    setStartDate('');
    setEndDate('');
    setCategoryFilter('ALL');
    setOpFilter('ALL');
    setActorFilter('ALL');
  };

  // CSV Export Engine
  const handleExportCsv = () => {
    exportToCsv(
      'Yegna_Health_Audit_Trail',
      [
        { header: 'Event ID', accessor: (l) => l.id },
        { header: 'Action Type', accessor: (l) => l.action },
        { header: 'Admin Actor', accessor: (l) => l.adminEmail },
        { header: 'Action Details', accessor: (l) => l.details },
        { header: 'Timestamp (UTC)', accessor: (l) => l.timestamp },
        { header: 'Local Time', accessor: (l) => new Date(l.timestamp).toLocaleString() },
      ],
      sortedLogs
    );
  };

  return (
    <div className="space-y-6">
      {/* Header Bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            <History className="text-brand-600 dark:text-cyan-400" size={24} />
            <span>{lang === 'am' ? 'የአስተዳዳሪ ቁጥጥርና ኦዲት መዝገብ' : 'Immutable Platform Audit Trail'}</span>
          </h2>
          <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1">
            {lang === 'am'
              ? 'በሲስተሙ ላይ የተከናወኑ ማናቸውም ለውጦች (የክሊኒክ ምዝገባ፣ የትምህርት አርትዖት፣ የተጠቃሚ እገዳ) በሙሉ ተመዝግበው ይቀመጣሉ።'
              : 'Traceable administrative activity log tracking every creation, edit, and moderation action.'}
          </p>
        </div>

        <button
          onClick={handleExportCsv}
          className="flex items-center gap-1.5 px-3.5 py-2.5 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs md:text-sm font-bold rounded-xl border border-slate-200 dark:border-slate-700 transition-all cursor-pointer self-start sm:self-auto shadow-2xs"
          title={lang === 'am' ? 'የኦዲት ሪፖርት (CSV) አውርድ' : 'Export audit trail to Excel CSV'}
        >
          <Download size={15} />
          <span>{lang === 'am' ? 'ኦዲት ሪፖርት (CSV)' : 'Export Audit Log (CSV)'}</span>
        </button>
      </div>

      {/* Audit KPI Mini Stat Strip */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3.5">
        <div className="p-3.5 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-2xs">
          <div className="flex items-center justify-between text-slate-400 dark:text-slate-500 mb-1">
            <span className="text-[11px] font-bold uppercase tracking-wider">
              {lang === 'am' ? 'የተመዘገቡ ድርጊቶች' : 'Filtered Events'}
            </span>
            <Activity size={15} className="text-brand-600 dark:text-cyan-400" />
          </div>
          <p className="text-xl font-extrabold text-slate-900 dark:text-white">{stats.total}</p>
        </div>

        <div className="p-3.5 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-2xs">
          <div className="flex items-center justify-between text-slate-400 dark:text-slate-500 mb-1">
            <span className="text-[11px] font-bold uppercase tracking-wider">
              {lang === 'am' ? 'አዲስ ምዝገባዎች' : 'Creations'}
            </span>
            <PlusCircle size={15} className="text-emerald-500" />
          </div>
          <p className="text-xl font-extrabold text-emerald-600 dark:text-emerald-400">{stats.creations}</p>
        </div>

        <div className="p-3.5 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-2xs">
          <div className="flex items-center justify-between text-slate-400 dark:text-slate-500 mb-1">
            <span className="text-[11px] font-bold uppercase tracking-wider">
              {lang === 'am' ? 'ማሻሻያዎች' : 'Updates & Edits'}
            </span>
            <Edit3 size={15} className="text-amber-500" />
          </div>
          <p className="text-xl font-extrabold text-amber-600 dark:text-amber-400">{stats.updates}</p>
        </div>

        <div className="p-3.5 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-2xs">
          <div className="flex items-center justify-between text-slate-400 dark:text-slate-500 mb-1">
            <span className="text-[11px] font-bold uppercase tracking-wider">
              {lang === 'am' ? 'እገዳና ስረዛዎች' : 'Moderations / Deletions'}
            </span>
            <Trash2 size={15} className="text-rose-500" />
          </div>
          <p className="text-xl font-extrabold text-rose-600 dark:text-rose-400">{stats.moderations}</p>
        </div>
      </div>

      {/* Advanced Filter Command Bar */}
      <div className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs space-y-3.5">
        {/* Row 1: Search & Admin Actor & Operation Selector */}
        <div className="grid grid-cols-1 md:grid-cols-12 gap-3">
          {/* Search Input */}
          <div className="md:col-span-6 relative">
            <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 dark:text-slate-500" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder={
                lang === 'am'
                  ? 'በእርምጃ አይነት፣ በአስተዳዳሪ ኢሜይል ወይም በዝርዝር ፈልግ...'
                  : 'Search by action, admin email actor, or operation details...'
              }
              className="w-full pl-9 pr-8 py-2 text-xs md:text-sm bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl focus:bg-white dark:focus:bg-slate-800/90 focus:border-brand-500 focus:outline-none transition-all text-slate-800 dark:text-slate-100 placeholder:text-slate-400 dark:placeholder:text-slate-500"
            />
            {search && (
              <button
                onClick={() => setSearch('')}
                className="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 cursor-pointer"
              >
                <X size={15} />
              </button>
            )}
          </div>

          {/* Operation Type Dropdown */}
          <div className="md:col-span-3">
            <select
              value={opFilter}
              onChange={(e) => setOpFilter(e.target.value)}
              className="w-full px-3 py-2 text-xs md:text-sm bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl font-bold text-slate-700 dark:text-slate-200 focus:outline-none focus:border-brand-500 cursor-pointer"
            >
              {opOptions.map((op) => (
                <option key={op.id} value={op.id}>
                  {lang === 'am' ? op.labelAm : op.labelEn}
                </option>
              ))}
            </select>
          </div>

          {/* Admin Actor Dropdown */}
          <div className="md:col-span-3">
            <select
              value={actorFilter}
              onChange={(e) => setActorFilter(e.target.value)}
              className="w-full px-3 py-2 text-xs md:text-sm bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl font-bold text-slate-700 dark:text-slate-200 focus:outline-none focus:border-brand-500 cursor-pointer"
            >
              <option value="ALL">
                {lang === 'am' ? 'ሁሉም አስተዳዳሪዎች (All Actors)' : 'All Admin Actors'}
              </option>
              {uniqueActors.map((actor) => (
                <option key={actor} value={actor}>
                  {actor}
                </option>
              ))}
            </select>
          </div>
        </div>

        {/* Row 2: Category Filter Tabs */}
        <div className="flex items-center gap-1.5 overflow-x-auto pb-1 text-xs font-bold scrollbar-none">
          {categories.map((c) => (
            <button
              key={c.id}
              onClick={() => setCategoryFilter(c.id)}
              className={`px-3 py-1.5 rounded-xl transition-all whitespace-nowrap cursor-pointer ${
                categoryFilter === c.id
                  ? 'bg-brand-600 text-white shadow-2xs font-extrabold'
                  : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 hover:bg-slate-200/70 dark:hover:bg-slate-700'
              }`}
            >
              {lang === 'am' ? c.labelAm : c.labelEn}
            </button>
          ))}
        </div>

        {/* Row 3: Date Range Picker & Reset Button */}
        <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-3 pt-2 border-t border-slate-100 dark:border-slate-800">
          <DateRangePicker
            preset={datePreset}
            onSelectPreset={setDatePreset}
            startDate={startDate}
            endDate={endDate}
            onStartDateChange={setStartDate}
            onEndDateChange={setEndDate}
            onReset={() => {
              setStartDate('');
              setEndDate('');
            }}
            lang={lang}
          />

          {isFilterActive && (
            <button
              onClick={handleResetFilters}
              className="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-bold text-rose-600 dark:text-rose-400 bg-rose-50 dark:bg-rose-950/40 hover:bg-rose-100 dark:hover:bg-rose-900/50 rounded-xl border border-rose-200 dark:border-rose-800/60 transition-colors cursor-pointer self-start lg:self-auto shadow-2xs"
            >
              <RotateCcw size={13} />
              <span>{lang === 'am' ? 'ማጣሪያዎችን አጽዳ' : 'Reset All Filters'}</span>
            </button>
          )}
        </div>
      </div>

      {/* Logs Table */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs md:text-sm">
            <thead className="bg-slate-50 dark:bg-slate-800/80 border-b border-slate-100 dark:border-slate-800 text-slate-500 dark:text-slate-400 font-bold uppercase text-[11px] tracking-wider">
              <tr>
                <SortableHeader
                  label={lang === 'am' ? 'እርምጃ' : 'Action'}
                  field="action"
                  currentField={sortField}
                  currentOrder={sortOrder}
                  onSort={handleSort}
                />
                <SortableHeader
                  label={lang === 'am' ? 'አስተዳዳሪ' : 'Admin Actor'}
                  field="adminEmail"
                  currentField={sortField}
                  currentOrder={sortOrder}
                  onSort={handleSort}
                />
                <th className="py-3 px-4">{lang === 'am' ? 'የእርምጃው ዝርዝር' : 'Action Details'}</th>
                <SortableHeader
                  label={lang === 'am' ? 'ሰዓት' : 'Timestamp'}
                  field="timestamp"
                  currentField={sortField}
                  currentOrder={sortOrder}
                  onSort={handleSort}
                  align="right"
                />
                <th className="py-3 px-4 text-right">{lang === 'am' ? 'እይ' : 'Inspect'}</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 dark:divide-slate-800/80 font-medium">
              {paginatedLogs.map((log) => {
                const theme = getActionTheme(log.action);
                const Icon = theme.icon;

                return (
                  <tr
                    key={log.id}
                    onClick={() => setSelectedLog(log)}
                    className="hover:bg-slate-50/70 dark:hover:bg-slate-800/50 transition-colors cursor-pointer group"
                  >
                    <td className="py-3.5 px-4">
                      <span
                        className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-[11px] font-extrabold tracking-wide border ${theme.bg} ${theme.text} ${theme.border}`}
                      >
                        <Icon size={12} />
                        {log.action}
                      </span>
                    </td>
                    <td className="py-3.5 px-4 text-slate-700 dark:text-slate-200 font-semibold">
                      <span className="group-hover:text-brand-600 dark:group-hover:text-cyan-400 transition-colors">
                        {log.adminEmail}
                      </span>
                    </td>
                    <td className="py-3.5 px-4 text-slate-600 dark:text-slate-300 max-w-md truncate">
                      {log.details}
                    </td>
                    <td className="py-3.5 px-4 text-right text-slate-400 dark:text-slate-500 text-xs whitespace-nowrap">
                      <div className="inline-flex items-center gap-1">
                        <Clock size={12} />
                        <span>{new Date(log.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
                        <span className="text-[10px] text-slate-400/80">({getRelativeTime(log.timestamp, lang)})</span>
                      </div>
                    </td>
                    <td className="py-3.5 px-4 text-right">
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          setSelectedLog(log);
                        }}
                        className="p-1.5 text-slate-400 group-hover:text-brand-600 dark:group-hover:text-cyan-400 group-hover:bg-brand-50 dark:group-hover:bg-slate-800 rounded-lg transition-colors"
                        title={lang === 'am' ? 'ዝርዝር እይ' : 'Inspect event'}
                      >
                        <Eye size={15} />
                      </button>
                    </td>
                  </tr>
                );
              })}

              {sortedLogs.length === 0 && (
                <EmptyState
                  colSpan={5}
                  icon={History}
                  title={lang === 'am' ? 'ምንም የኦዲት መዝገብ አልተገኘም' : 'No audit logs found'}
                  description={
                    isFilterActive
                      ? lang === 'am'
                        ? 'ከተመረጡት ማጣሪያዎች ወይም የቀን ክልል ጋር የሚዛመድ ምንም የተመዘገበ እርምጃ የለም።'
                        : 'No audit trail events match your current search, action category, or date range filters.'
                      : lang === 'am'
                      ? 'እስካሁን ምንም የአስተዳዳሪ እርምጃ አልተመዘገበም።'
                      : 'No administrative activity has been logged yet.'
                  }
                  clearLabel={isFilterActive ? (lang === 'am' ? 'ማጣሪያዎችን አጽዳ' : 'Reset Filters') : undefined}
                  onClear={isFilterActive ? handleResetFilters : undefined}
                />
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination Controls */}
        {sortedLogs.length > 0 && (
          <div className="px-4 py-3 border-t border-slate-100 dark:border-slate-800 flex flex-col sm:flex-row sm:items-center justify-between gap-3 text-xs text-slate-500 dark:text-slate-400">
            <div className="flex items-center gap-2">
              <span>{lang === 'am' ? 'በአንድ ገጽ የሚታዩ:' : 'Rows per page:'}</span>
              <select
                value={pageSize}
                onChange={(e) => {
                  setPageSize(Number(e.target.value));
                  setCurrentPage(1);
                }}
                className="px-2 py-0.5 border border-slate-200 dark:border-slate-700 rounded-lg bg-white dark:bg-slate-800 font-semibold text-slate-700 dark:text-slate-200 cursor-pointer"
              >
                <option value={10}>10</option>
                <option value={25}>25</option>
                <option value={50}>50</option>
                <option value={100}>100</option>
              </select>
              <span className="text-slate-400 ml-2">
                {lang === 'am'
                  ? `ከ ${sortedLogs.length} መዝገቦች ውስጥ ${(safeCurrentPage - 1) * pageSize + 1}-${Math.min(
                      safeCurrentPage * pageSize,
                      sortedLogs.length
                    )} በማሳየት ላይ`
                  : `Showing ${(safeCurrentPage - 1) * pageSize + 1}-${Math.min(
                      safeCurrentPage * pageSize,
                      sortedLogs.length
                    )} of ${sortedLogs.length} events`}
              </span>
            </div>

            <div className="flex items-center gap-1.5 self-end sm:self-auto">
              <button
                onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
                disabled={safeCurrentPage === 1}
                className="p-1.5 rounded-lg border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 disabled:opacity-40 hover:bg-slate-50 dark:hover:bg-slate-800 cursor-pointer disabled:cursor-not-allowed"
                title="Previous page"
              >
                <ChevronLeft size={16} />
              </button>

              <span className="px-2 font-bold text-slate-700 dark:text-slate-200">
                {safeCurrentPage} / {totalPages}
              </span>

              <button
                onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))}
                disabled={safeCurrentPage === totalPages}
                className="p-1.5 rounded-lg border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 disabled:opacity-40 hover:bg-slate-50 dark:hover:bg-slate-800 cursor-pointer disabled:cursor-not-allowed"
                title="Next page"
              >
                <ChevronRight size={16} />
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Deep Inspection Modal */}
      <AuditDetailModal
        log={selectedLog}
        onClose={() => setSelectedLog(null)}
        lang={lang}
      />
    </div>
  );
};
