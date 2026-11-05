import React, { useState, useMemo } from 'react';
import { History, Shield, Clock, Download, Search, X } from 'lucide-react';
import { AuditLog } from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';
import { SortableHeader, SortOrder } from '../components/common/SortableHeader.js';
import { EmptyState } from '../components/common/EmptyState.js';

interface AuditLogsPageProps {
  logs: AuditLog[];
  lang: 'en' | 'am';
}

export const AuditLogsPage: React.FC<AuditLogsPageProps> = ({ logs, lang }) => {
  const [search, setSearch] = useState('');
  const [sortField, setSortField] = useState<string>('timestamp');
  const [sortOrder, setSortOrder] = useState<SortOrder>('desc');

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

  const filteredLogs = useMemo(() => {
    const q = search.trim().toLowerCase();
    if (!q) return logs;
    return logs.filter(
      (l) =>
        l.action.toLowerCase().includes(q) ||
        l.adminEmail.toLowerCase().includes(q) ||
        l.details.toLowerCase().includes(q)
    );
  }, [logs, search]);

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

  const handleExportCsv = () => {
    exportToCsv(
      'Yegna_Health_Audit_Logs',
      [
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
      {/* Header */}
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

      {/* Search Input Bar */}
      <div className="bg-white dark:bg-slate-900 p-3.5 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs">
        <div className="relative">
          <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 dark:text-slate-500" />
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder={
              lang === 'am'
                ? 'በእርምጃ አይነት፣ በአስተዳዳሪ ኢሜይል ወይም በዝርዝር ፈልግ...'
                : 'Search audit logs by action type, admin actor email, or details...'
            }
            className="w-full pl-9 pr-8 py-2 text-xs md:text-sm bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl focus:bg-white dark:focus:bg-slate-800/80 focus:border-brand-500 focus:outline-none transition-all text-slate-800 dark:text-slate-100 placeholder:text-slate-400 dark:placeholder:text-slate-500"
          />
          {search && (
            <button
              onClick={() => setSearch('')}
              className="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200"
            >
              <X size={15} />
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
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 dark:divide-slate-800/80 font-medium">
              {sortedLogs.map((log) => (
                <tr key={log.id} className="hover:bg-slate-50/70 dark:hover:bg-slate-800/50 transition-colors">
                  <td className="py-3.5 px-4">
                    <span className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-md bg-slate-100 dark:bg-slate-800 text-slate-800 dark:text-slate-200 text-[11px] font-extrabold tracking-wide border border-slate-200/60 dark:border-slate-700">
                      <Shield size={12} className="text-brand-600 dark:text-cyan-400" />
                      {log.action}
                    </span>
                  </td>
                  <td className="py-3.5 px-4 text-slate-700 dark:text-slate-200 font-semibold">{log.adminEmail}</td>
                  <td className="py-3.5 px-4 text-slate-600 dark:text-slate-300 max-w-md">{log.details}</td>
                  <td className="py-3.5 px-4 text-right text-slate-400 dark:text-slate-500 text-xs">
                    <div className="inline-flex items-center gap-1">
                      <Clock size={12} />
                      {new Date(log.timestamp).toLocaleString()}
                    </div>
                  </td>
                </tr>
              ))}
              {sortedLogs.length === 0 && (
                <EmptyState
                  colSpan={4}
                  icon={History}
                  title={lang === 'am' ? 'ምንም የኦዲት መዝገብ አልተገኘም' : 'No audit logs found'}
                  description={
                    search
                      ? lang === 'am'
                        ? 'ለተሰጠው ፍለጋ ምንም የተመዘገበ እርምጃ የለም።'
                        : `No audit log events match your search query "${search}".`
                      : lang === 'am'
                      ? 'እስካሁን ምንም የአስተዳዳሪ እርምጃ አልተመዘገበም።'
                      : 'No administrative activity has been logged yet.'
                  }
                  clearLabel={search ? (lang === 'am' ? 'ፍለጋውን አጽዳ' : 'Clear Search') : undefined}
                  onClear={() => setSearch('')}
                />
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};
