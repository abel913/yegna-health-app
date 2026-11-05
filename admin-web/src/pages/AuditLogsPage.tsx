import React from 'react';
import { History, Shield, Clock } from 'lucide-react';
import { AuditLog } from '../types/index.js';

interface AuditLogsPageProps {
  logs: AuditLog[];
  lang: 'en' | 'am';
}

export const AuditLogsPage: React.FC<AuditLogsPageProps> = ({ logs, lang }) => {
  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h2 className="text-xl md:text-2xl font-extrabold text-slate-900 flex items-center gap-2">
          <History className="text-brand-600" size={24} />
          <span>{lang === 'am' ? 'የአስተዳዳሪ ቁጥጥርና ኦዲት መዝገብ' : 'Immutable Platform Audit Trail'}</span>
        </h2>
        <p className="text-xs md:text-sm text-slate-500 mt-1">
          {lang === 'am'
            ? 'በሲስተሙ ላይ የተከናወኑ ማናቸውም ለውጦች (የክሊኒክ ምዝገባ፣ የትምህርት አርትዖት፣ የተጠቃሚ እገዳ) በሙሉ ተመዝግበው ይቀመጣሉ።'
            : 'Traceable administrative activity log tracking every creation, edit, and moderation action.'}
        </p>
      </div>

      {/* Logs Table */}
      <div className="bg-white rounded-2xl border border-slate-200/80 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs md:text-sm">
            <thead className="bg-slate-50 border-b border-slate-100 text-slate-500 font-bold uppercase text-[11px] tracking-wider">
              <tr>
                <th className="py-3 px-4">Action</th>
                <th className="py-3 px-4">Admin Actor</th>
                <th className="py-3 px-4">Action Details</th>
                <th className="py-3 px-4 text-right">Timestamp</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 font-medium">
              {logs.map((log) => (
                <tr key={log.id} className="hover:bg-slate-50/70 transition-colors">
                  <td className="py-3.5 px-4">
                    <span className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-md bg-slate-100 text-slate-800 text-[11px] font-extrabold tracking-wide">
                      <Shield size={12} className="text-brand-600" />
                      {log.action}
                    </span>
                  </td>
                  <td className="py-3.5 px-4 text-slate-700 font-semibold">{log.adminEmail}</td>
                  <td className="py-3.5 px-4 text-slate-600 max-w-md">{log.details}</td>
                  <td className="py-3.5 px-4 text-right text-slate-400 text-xs">
                    <div className="inline-flex items-center gap-1">
                      <Clock size={12} />
                      {new Date(log.timestamp).toLocaleString()}
                    </div>
                  </td>
                </tr>
              ))}
              {logs.length === 0 && (
                <tr>
                  <td colSpan={4} className="py-12 text-center text-slate-400">
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
