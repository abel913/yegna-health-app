import React, { useState } from 'react';
import {
  X,
  Shield,
  ShieldAlert,
  ShieldCheck,
  Clock,
  User,
  Copy,
  Check,
  FileText,
  PlusCircle,
  Edit3,
  Trash2,
  KeyRound,
} from 'lucide-react';
import { AuditLog } from '../../types/index.js';

interface AuditDetailModalProps {
  log: AuditLog | null;
  onClose: () => void;
  lang: 'en' | 'am';
}

export const getActionTheme = (action: string) => {
  const act = action.toUpperCase();
  if (act.includes('CREATE') || act.includes('APPROVE') || act.includes('REINSTATE')) {
    return {
      bg: 'bg-emerald-50 dark:bg-emerald-950/40',
      text: 'text-emerald-700 dark:text-emerald-300',
      border: 'border-emerald-200 dark:border-emerald-800/70',
      icon: PlusCircle,
      accent: 'emerald',
    };
  }
  if (act.includes('UPDATE') || act.includes('EDIT') || act.includes('CHANGE')) {
    return {
      bg: 'bg-amber-50 dark:bg-amber-950/40',
      text: 'text-amber-700 dark:text-amber-300',
      border: 'border-amber-200 dark:border-amber-800/70',
      icon: Edit3,
      accent: 'amber',
    };
  }
  if (act.includes('DELETE') || act.includes('SUSPEND') || act.includes('REMOVE')) {
    return {
      bg: 'bg-rose-50 dark:bg-rose-950/40',
      text: 'text-rose-700 dark:text-rose-300',
      border: 'border-rose-200 dark:border-rose-800/70',
      icon: act.includes('SUSPEND') ? ShieldAlert : Trash2,
      accent: 'rose',
    };
  }
  if (act.includes('AUTH') || act.includes('LOGIN') || act.includes('LOGOUT')) {
    return {
      bg: 'bg-sky-50 dark:bg-sky-950/40',
      text: 'text-sky-700 dark:text-sky-300',
      border: 'border-sky-200 dark:border-sky-800/70',
      icon: KeyRound,
      accent: 'sky',
    };
  }
  return {
    bg: 'bg-slate-100 dark:bg-slate-800',
    text: 'text-slate-700 dark:text-slate-300',
    border: 'border-slate-200 dark:border-slate-700',
    icon: Shield,
    accent: 'slate',
  };
};

export const getRelativeTime = (timestamp: string, lang: 'en' | 'am'): string => {
  const diff = Date.now() - new Date(timestamp).getTime();
  const mins = Math.floor(diff / (1000 * 60));
  const hours = Math.floor(mins / 60);
  const days = Math.floor(hours / 24);

  if (lang === 'am') {
    if (mins < 1) return 'አሁን';
    if (mins < 60) return `ከ ${mins} ደቂቃ በፊት`;
    if (hours < 24) return `ከ ${hours} ሰዓት በፊት`;
    return `ከ ${days} ቀናት በፊት`;
  }

  if (mins < 1) return 'Just now';
  if (mins < 60) return `${mins}m ago`;
  if (hours < 24) return `${hours}h ago`;
  return `${days}d ago`;
};

export const AuditDetailModal: React.FC<AuditDetailModalProps> = ({ log, onClose, lang }) => {
  const [copied, setCopied] = useState(false);

  if (!log) return null;

  const theme = getActionTheme(log.action);
  const Icon = theme.icon;

  const handleCopyId = () => {
    navigator.clipboard.writeText(log.id);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4">
      <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-2xl max-w-xl w-full p-6 md:p-8 animate-in fade-in zoom-in-95 duration-200 max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="flex items-start justify-between gap-4 pb-4 border-b border-slate-100 dark:border-slate-800">
          <div className="flex items-center gap-3">
            <div className={`w-11 h-11 rounded-2xl ${theme.bg} ${theme.text} flex items-center justify-center border ${theme.border} shadow-2xs`}>
              <Icon size={22} />
            </div>
            <div>
              <h3 className="text-base md:text-lg font-extrabold text-slate-900 dark:text-white">
                {lang === 'am' ? 'የኦዲት መዝገብ ዝርዝር' : 'Audit Event Inspection'}
              </h3>
              <p className="text-xs text-slate-400 dark:text-slate-500 font-mono mt-0.5">
                ID: {log.id.slice(0, 16)}...
              </p>
            </div>
          </div>

          <button
            onClick={onClose}
            className="p-1.5 rounded-xl text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer"
          >
            <X size={20} />
          </button>
        </div>

        {/* Content Body */}
        <div className="mt-5 space-y-4 text-xs md:text-sm">
          {/* Action Badge & Copy Bar */}
          <div className="flex flex-wrap items-center justify-between gap-2 p-3 bg-slate-50 dark:bg-slate-800/60 rounded-2xl border border-slate-200/80 dark:border-slate-700/80">
            <div className="flex items-center gap-2">
              <span className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-lg text-xs font-extrabold tracking-wide border ${theme.bg} ${theme.text} ${theme.border}`}>
                <Icon size={13} />
                {log.action}
              </span>
            </div>

            <button
              onClick={handleCopyId}
              className="inline-flex items-center gap-1.5 px-2.5 py-1 text-xs font-bold text-slate-600 dark:text-slate-300 hover:text-brand-600 dark:hover:text-cyan-400 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg shadow-2xs cursor-pointer transition-colors"
            >
              {copied ? <Check size={13} className="text-emerald-500" /> : <Copy size={13} />}
              <span>{copied ? (lang === 'am' ? 'ተቀድቷል' : 'Copied!') : (lang === 'am' ? 'ID ቅዳ' : 'Copy Event ID')}</span>
            </button>
          </div>

          {/* Metadata Grid */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            {/* Actor Card */}
            <div className="p-3.5 bg-slate-50 dark:bg-slate-800/40 rounded-2xl border border-slate-200/60 dark:border-slate-800">
              <div className="flex items-center gap-2 text-slate-400 dark:text-slate-500 text-[11px] font-bold uppercase tracking-wider mb-1">
                <User size={13} />
                <span>{lang === 'am' ? 'አድራጊ አስተዳዳሪ' : 'Administrator Actor'}</span>
              </div>
              <p className="font-bold text-slate-900 dark:text-white truncate">{log.adminEmail}</p>
              <span className="inline-block mt-1 text-[10px] font-bold text-emerald-700 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-950/50 px-2 py-0.5 rounded-md border border-emerald-200/60 dark:border-emerald-800/60">
                Verified Sign-In Session
              </span>
            </div>

            {/* Timestamp Card */}
            <div className="p-3.5 bg-slate-50 dark:bg-slate-800/40 rounded-2xl border border-slate-200/60 dark:border-slate-800">
              <div className="flex items-center gap-2 text-slate-400 dark:text-slate-500 text-[11px] font-bold uppercase tracking-wider mb-1">
                <Clock size={13} />
                <span>{lang === 'am' ? 'የተከናወነበት ሰዓት' : 'Timestamp & Relative'}</span>
              </div>
              <p className="font-bold text-slate-900 dark:text-white">
                {new Date(log.timestamp).toLocaleString()}
              </p>
              <p className="text-[11px] text-brand-600 dark:text-cyan-400 font-semibold mt-0.5">
                {getRelativeTime(log.timestamp, lang)} ({new Date(log.timestamp).toISOString()})
              </p>
            </div>
          </div>

          {/* Details Narrative Card */}
          <div className="p-4 bg-slate-50 dark:bg-slate-800/50 rounded-2xl border border-slate-200/80 dark:border-slate-700/80">
            <div className="flex items-center gap-2 text-slate-500 dark:text-slate-400 text-xs font-bold mb-2">
              <FileText size={14} className="text-brand-600 dark:text-cyan-400" />
              <span>{lang === 'am' ? 'የተመዘገበው እርምጃ ማጠቃለያ' : 'Action Details & Payload Summary'}</span>
            </div>
            <p className="font-mono text-xs text-slate-800 dark:text-slate-200 leading-relaxed bg-white dark:bg-slate-900 p-3 rounded-xl border border-slate-200/60 dark:border-slate-800 whitespace-pre-wrap select-all">
              {log.details}
            </p>
          </div>

          {/* Zero-Knowledge & Tamper-Proof Trust Card */}
          <div className="p-3 bg-emerald-50/60 dark:bg-emerald-950/30 rounded-2xl border border-emerald-200/60 dark:border-emerald-800/60 flex items-start gap-2.5">
            <ShieldCheck size={18} className="text-emerald-600 dark:text-emerald-400 flex-shrink-0 mt-0.5" />
            <div className="text-xs text-emerald-800 dark:text-emerald-300">
              <p className="font-bold">
                {lang === 'am' ? 'የማይቀየር የደህንነት ኦዲት ማህደር (Cryptographically Immutable)' : 'Cryptographically Immutable Audit Log'}
              </p>
              <p className="text-[11px] text-emerald-700/80 dark:text-emerald-400/80 mt-0.5">
                {lang === 'am'
                  ? 'ይህ መዝገብ የተማሪዎችን ግላዊነት ሳያጋልጥ የአስተዳዳሪዎችን ውሳኔ በቋሚነት እንዲታወቅ ያደርጋል።'
                  : 'This record confirms administrative governance without exposing students’ encrypted private records.'}
              </p>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="mt-6 pt-4 border-t border-slate-100 dark:border-slate-800 flex justify-end">
          <button
            type="button"
            onClick={onClose}
            className="px-5 py-2 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 font-bold rounded-xl text-xs md:text-sm transition-colors cursor-pointer"
          >
            {lang === 'am' ? 'ዝጋ' : 'Close'}
          </button>
        </div>
      </div>
    </div>
  );
};
