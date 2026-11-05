import React from 'react';
import { History, Shield, Clock, Download } from 'lucide-react';
import { AuditLog } from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';

interface AuditLogsPageProps {
  logs: AuditLog[];
  lang: 'en' | 'am';
}

export const AuditLogsPage: React.FC<AuditLogsPageProps> = ({ logs, lang }) => {
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
      logs
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

      {/* Logs Table */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200/80 dark:border-slate-800 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs md:text-sm">
            <thead className="bg-slate-50 dark:bg-slate-800/80 border-b border-slate-100 dark:border-slate-800 text-slate-500 dark:text-slate-400 font-bold uppercase text-[11px] tracking-wider">
              <tr>
                <th className="py-3 px-4">Action</th>
                <th className="py-3 px-4">Admin Actor</th>
                <th className="py-3 px-4">Action Details</th>
                <th className="py-3 px-4 text-right">Timestamp</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 dark:divide-slate-800/80 font-medium">
              {logs.map((log) => (
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
              {logs.length === 0 && (
                <tr>
                  <td colSpan={4} className="py-12 text-center text-slate-400 dark:text-slate-500">
                    No activity logs recorded yet.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};
