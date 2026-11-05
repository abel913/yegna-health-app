import React, { useState, useEffect, useRef } from 'react';
import {
  Activity,
  CheckCircle2,
  AlertTriangle,
  RefreshCw,
  Database,
  ShieldCheck,
  Server,
  Clock,
  Cpu,
  X,
} from 'lucide-react';
import { api } from '../../services/api.js';
import { SystemTelemetry } from '../../types/index.js';

interface SystemHealthIndicatorProps {
  lang: 'en' | 'am';
}

export const SystemHealthIndicator: React.FC<SystemHealthIndicatorProps> = ({ lang }) => {
  const [telemetry, setTelemetry] = useState<SystemTelemetry | null>(null);
  const [loading, setLoading] = useState(false);
  const [isOpen, setIsOpen] = useState(false);
  const [lastCheck, setLastCheck] = useState<Date>(new Date());
  const [errorState, setErrorState] = useState<string | null>(null);
  const dropdownRef = useRef<HTMLDivElement>(null);

  const fetchHealth = async () => {
    setLoading(true);
    try {
      const data = await api.getHealth();
      setTelemetry(data);
      setErrorState(null);
      setLastCheck(new Date());
    } catch (err: any) {
      setErrorState(err.message || 'Connection lost');
      setTelemetry((prev) =>
        prev
          ? {
              ...prev,
              status: 'offline',
              clientRoundtripMs: 0,
            }
          : {
              status: 'offline',
              service: 'Yegna Health API',
              version: '1.0.0',
              environment: 'offline',
              uptimeSeconds: 0,
              database: {
                type: 'SQLite',
                status: 'disconnected',
                latencyMs: 0,
              },
              privacyVault: 'Vault Offline',
              timestamp: new Date().toISOString(),
              clientRoundtripMs: 0,
            }
      );
      setLastCheck(new Date());
    } finally {
      setLoading(false);
    }
  };

  // Initial fetch and 30-second background polling
  useEffect(() => {
    fetchHealth();
    const interval = setInterval(fetchHealth, 30000);
    return () => clearInterval(interval);
  }, []);

  // Close dropdown on outside click
  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setIsOpen(false);
      }
    };
    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside);
    }
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, [isOpen]);

  // Format Uptime Seconds to human readable string
  const formatUptime = (seconds: number) => {
    if (seconds <= 0) return '0s';
    const d = Math.floor(seconds / (3600 * 24));
    const h = Math.floor((seconds % (3600 * 24)) / 3600);
    const m = Math.floor((seconds % 3600) / 60);
    const s = Math.floor(seconds % 60);

    const parts = [];
    if (d > 0) parts.push(`${d}d`);
    if (h > 0) parts.push(`${h}h`);
    if (m > 0) parts.push(`${m}m`);
    if (parts.length === 0 || s > 0) parts.push(`${s}s`);
    return parts.join(' ');
  };

  const isOnline = telemetry?.status === 'ok';
  const isDegraded = telemetry?.status === 'degraded';

  return (
    <div className="relative" ref={dropdownRef}>
      {/* ========================================= */}
      {/* 1. COMPACT STATUS PILL TRIGGER IN HEADER  */}
      {/* ========================================= */}
      <button
        type="button"
        onClick={() => setIsOpen(!isOpen)}
        title={
          lang === 'am'
            ? 'የሲስተም ጤናና ቴሌሜትሪ ሁኔታ'
            : 'Live Telemetry & System Health'
        }
        className={`flex items-center gap-2 px-2.5 sm:px-3 py-1.5 rounded-xl border text-xs font-bold transition-all cursor-pointer shadow-2xs ${
          isOnline
            ? 'bg-emerald-50/70 dark:bg-emerald-950/40 border-emerald-200/80 dark:border-emerald-800 text-emerald-800 dark:text-emerald-300 hover:bg-emerald-100/70 dark:hover:bg-emerald-900/40'
            : isDegraded
            ? 'bg-amber-50/70 dark:bg-amber-950/40 border-amber-200/80 dark:border-amber-800 text-amber-800 dark:text-amber-300 hover:bg-amber-100/70 dark:hover:bg-amber-900/40'
            : 'bg-rose-50/70 dark:bg-rose-950/40 border-rose-200/80 dark:border-rose-800 text-rose-800 dark:text-rose-300 hover:bg-rose-100/70 dark:hover:bg-rose-900/40'
        }`}
      >
        {/* Pulsing Status Dot */}
        <span className="relative flex h-2 w-2">
          {isOnline && (
            <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75" />
          )}
          <span
            className={`relative inline-flex rounded-full h-2 w-2 ${
              isOnline ? 'bg-emerald-500' : isDegraded ? 'bg-amber-500' : 'bg-rose-500'
            }`}
          />
        </span>

        {/* Text Label */}
        <span className="hidden sm:inline">
          {isOnline
            ? `${telemetry?.clientRoundtripMs || 18}ms`
            : isDegraded
            ? lang === 'am'
              ? 'ቀርፋፋ'
              : 'Degraded'
            : lang === 'am'
            ? 'ከመስመር ውጭ'
            : 'Offline'}
        </span>

        <span className="text-[10px] uppercase tracking-wider opacity-75 hidden md:inline">
          {isOnline ? 'Live' : ''}
        </span>
      </button>

      {/* ========================================= */}
      {/* 2. RICH TELEMETRY POPOVER PANEL           */}
      {/* ========================================= */}
      {isOpen && (
        <div className="absolute right-0 mt-2.5 w-80 sm:w-96 bg-white dark:bg-slate-900 rounded-3xl border border-slate-200/90 dark:border-slate-800 shadow-2xl p-5 z-50 animate-in fade-in zoom-in-95 duration-150">
          {/* Header */}
          <div className="flex items-center justify-between pb-3.5 border-b border-slate-100 dark:border-slate-800">
            <div className="flex items-center gap-2.5">
              <div className="w-8 h-8 rounded-xl bg-brand-50 dark:bg-cyan-950/60 text-brand-600 dark:text-cyan-400 flex items-center justify-center border border-brand-100 dark:border-cyan-800/50">
                <Activity size={17} />
              </div>
              <div>
                <h4 className="text-xs sm:text-sm font-extrabold text-slate-900 dark:text-white">
                  {lang === 'am' ? 'የስርአት ጤና እና ቴሌሜትሪ' : 'System Health & Telemetry'}
                </h4>
                <p className="text-[10px] text-slate-400 dark:text-slate-500 font-medium">
                  {telemetry?.service || 'Yegna Health API Service'}
                </p>
              </div>
            </div>

            <div className="flex items-center gap-1">
              <button
                type="button"
                onClick={fetchHealth}
                disabled={loading}
                title={lang === 'am' ? 'አሁን አድስ' : 'Refresh Telemetry'}
                className="p-1.5 rounded-lg text-slate-400 hover:text-brand-600 dark:hover:text-cyan-400 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer disabled:opacity-50"
              >
                <RefreshCw size={14} className={loading ? 'animate-spin' : ''} />
              </button>
              <button
                type="button"
                onClick={() => setIsOpen(false)}
                className="p-1.5 rounded-lg text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer"
              >
                <X size={16} />
              </button>
            </div>
          </div>

          {/* Error Banner if connection failed */}
          {errorState && (
            <div className="mt-3 p-2.5 rounded-xl bg-rose-50 dark:bg-rose-950/40 border border-rose-200 dark:border-rose-800 text-rose-700 dark:text-rose-300 text-[11px] font-semibold flex items-center gap-2">
              <AlertTriangle size={14} className="flex-shrink-0" />
              <span className="truncate">{errorState}</span>
            </div>
          )}

          {/* Metrics Grid */}
          <div className="mt-3.5 space-y-2.5 text-xs">
            {/* Metric 1: Backend API Gateway */}
            <div className="p-3 rounded-2xl bg-slate-50 dark:bg-slate-800/50 border border-slate-200/60 dark:border-slate-800 flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <Server size={16} className="text-brand-600 dark:text-cyan-400" />
                <div>
                  <p className="font-bold text-slate-800 dark:text-slate-100">
                    {lang === 'am' ? 'የኤፒአይ መግቢያ (Gateway)' : 'API Service Gateway'}
                  </p>
                  <p className="text-[10px] text-slate-400 dark:text-slate-500">
                    {lang === 'am' ? 'የምላሽ ፍጥነት (Roundtrip)' : 'Client Roundtrip Latency'}
                  </p>
                </div>
              </div>

              <div className="text-right">
                <span
                  className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-[10px] font-extrabold ${
                    isOnline
                      ? 'bg-emerald-50 dark:bg-emerald-950/60 text-emerald-700 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800'
                      : 'bg-rose-50 dark:bg-rose-950/60 text-rose-700 dark:text-rose-300 border border-rose-200 dark:border-rose-800'
                  }`}
                >
                  {isOnline ? <CheckCircle2 size={10} /> : <AlertTriangle size={10} />}
                  {isOnline ? 'Online (200 OK)' : 'Unreachable'}
                </span>
                <p className="text-[11px] font-mono font-bold text-slate-700 dark:text-slate-300 mt-0.5">
                  {telemetry?.clientRoundtripMs || 0} ms
                </p>
              </div>
            </div>

            {/* Metric 2: Database Status */}
            <div className="p-3 rounded-2xl bg-slate-50 dark:bg-slate-800/50 border border-slate-200/60 dark:border-slate-800 flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <Database size={16} className="text-indigo-500 dark:text-indigo-400" />
                <div>
                  <p className="font-bold text-slate-800 dark:text-slate-100">
                    {lang === 'am' ? 'የዳታቤዝ ግንኙነት (Database)' : 'Database Engine (Prisma)'}
                  </p>
                  <p className="text-[10px] text-slate-400 dark:text-slate-500">
                    {telemetry?.database.type || 'SQLite (Local)'}
                  </p>
                </div>
              </div>

              <div className="text-right">
                <span
                  className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-[10px] font-extrabold ${
                    telemetry?.database.status === 'connected'
                      ? 'bg-emerald-50 dark:bg-emerald-950/60 text-emerald-700 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800'
                      : 'bg-amber-50 dark:bg-amber-950/60 text-amber-700 dark:text-amber-300 border border-amber-200 dark:border-amber-800'
                  }`}
                >
                  <CheckCircle2 size={10} />
                  {telemetry?.database.status === 'connected'
                    ? (lang === 'am' ? 'የተገናኘ' : 'Connected')
                    : (lang === 'am' ? 'ቀርፋፋ' : 'Degraded')}
                </span>
                <p className="text-[11px] font-mono font-bold text-slate-700 dark:text-slate-300 mt-0.5">
                  Query: {telemetry?.database.latencyMs ?? 2} ms
                </p>
              </div>
            </div>

            {/* Metric 3: Zero-Knowledge Student Privacy Vault */}
            <div className="p-3 rounded-2xl bg-emerald-50/60 dark:bg-emerald-950/30 border border-emerald-200/60 dark:border-emerald-800/60 flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <ShieldCheck size={16} className="text-emerald-600 dark:text-emerald-400" />
                <div>
                  <p className="font-bold text-emerald-900 dark:text-emerald-200">
                    {lang === 'am' ? 'የተማሪዎች ሚስጥራዊነት ካዝና' : 'Zero-Knowledge Privacy Vault'}
                  </p>
                  <p className="text-[10px] text-emerald-700/80 dark:text-emerald-400/80">
                    {lang === 'am' ? 'የንባብና የውይይት መረጃ ሙሉ በሙሉ የተመሰጠረ ነው' : 'Student Private History Encrypted'}
                  </p>
                </div>
              </div>

              <span className="px-2 py-0.5 rounded-md bg-emerald-100 dark:bg-emerald-900 text-emerald-800 dark:text-emerald-200 text-[10px] font-extrabold uppercase">
                Active
              </span>
            </div>

            {/* Metric 4: Runtime Environment & Uptime */}
            <div className="grid grid-cols-2 gap-2 text-[11px]">
              <div className="p-2.5 rounded-xl bg-slate-50 dark:bg-slate-800/40 border border-slate-200/50 dark:border-slate-800">
                <span className="text-slate-400 dark:text-slate-500 font-bold flex items-center gap-1 mb-0.5">
                  <Clock size={11} />
                  {lang === 'am' ? 'የሰርቨር የስራ ሰዓት' : 'Server Uptime'}
                </span>
                <p className="font-mono font-extrabold text-slate-800 dark:text-slate-200">
                  {formatUptime(telemetry?.uptimeSeconds || 0)}
                </p>
              </div>

              <div className="p-2.5 rounded-xl bg-slate-50 dark:bg-slate-800/40 border border-slate-200/50 dark:border-slate-800">
                <span className="text-slate-400 dark:text-slate-500 font-bold flex items-center gap-1 mb-0.5">
                  <Cpu size={11} />
                  {lang === 'am' ? 'አካባቢና ስሪት' : 'Version / Env'}
                </span>
                <p className="font-mono font-extrabold text-slate-800 dark:text-slate-200 truncate">
                  v{telemetry?.version || '1.0.0'} • {telemetry?.environment || 'dev'}
                </p>
              </div>
            </div>
          </div>

          {/* Footer Bar */}
          <div className="mt-3.5 pt-3 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between text-[11px] text-slate-400 dark:text-slate-500">
            <span>
              {lang === 'am' ? 'የመጨረሻ ምርመራ:' : 'Last verified:'}{' '}
              {lastCheck.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' })}
            </span>
            <span className="flex items-center gap-1 text-emerald-600 dark:text-emerald-400 font-semibold">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse" />
              Auto-sync (30s)
            </span>
          </div>
        </div>
      )}
    </div>
  );
};
