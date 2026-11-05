import React from 'react';
import { CalendarDays, X } from 'lucide-react';

export type DatePreset = 'ALL' | 'TODAY' | '7D' | '30D' | 'THIS_MONTH' | 'CUSTOM';

interface DateRangePickerProps {
  preset: DatePreset;
  onSelectPreset: (preset: DatePreset) => void;
  startDate: string; // YYYY-MM-DD
  endDate: string; // YYYY-MM-DD
  onStartDateChange: (val: string) => void;
  onEndDateChange: (val: string) => void;
  onReset?: () => void;
  lang: 'en' | 'am';
}

export const DateRangePicker: React.FC<DateRangePickerProps> = ({
  preset,
  onSelectPreset,
  startDate,
  endDate,
  onStartDateChange,
  onEndDateChange,
  onReset,
  lang,
}) => {
  const presets: { id: DatePreset; labelEn: string; labelAm: string }[] = [
    { id: 'ALL', labelEn: 'All Time', labelAm: 'ሁሉንም ጊዜ' },
    { id: 'TODAY', labelEn: 'Today', labelAm: 'ዛሬ' },
    { id: '7D', labelEn: 'Last 7 Days', labelAm: 'ያለፉት 7 ቀናት' },
    { id: '30D', labelEn: 'Last 30 Days', labelAm: 'ያለፉት 30 ቀናት' },
    { id: 'THIS_MONTH', labelEn: 'This Month', labelAm: 'ይህ ወር' },
    { id: 'CUSTOM', labelEn: 'Custom Range', labelAm: 'የተመረጠ ቀን' },
  ];

  return (
    <div className="flex flex-col sm:flex-row sm:items-center gap-2.5 flex-wrap">
      {/* Preset Pills */}
      <div className="inline-flex items-center gap-1 p-1 bg-slate-100 dark:bg-slate-800/80 rounded-xl border border-slate-200/80 dark:border-slate-700/80 text-xs font-bold overflow-x-auto max-w-full">
        {presets.map((p) => {
          const isActive = preset === p.id;
          return (
            <button
              key={p.id}
              type="button"
              onClick={() => onSelectPreset(p.id)}
              className={`px-2.5 py-1 rounded-lg transition-all whitespace-nowrap cursor-pointer ${
                isActive
                  ? 'bg-white dark:bg-slate-900 text-brand-600 dark:text-cyan-400 shadow-2xs font-extrabold'
                  : 'text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-slate-200 hover:bg-slate-200/50 dark:hover:bg-slate-700/50'
              }`}
            >
              {lang === 'am' ? p.labelAm : p.labelEn}
            </button>
          );
        })}
      </div>

      {/* Custom Date Inputs when CUSTOM is selected */}
      {preset === 'CUSTOM' && (
        <div className="flex items-center gap-2 animate-in fade-in zoom-in-95 duration-150">
          <div className="flex items-center gap-1.5 px-2.5 py-1 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs shadow-2xs">
            <span className="text-slate-400 dark:text-slate-500 font-semibold">
              {lang === 'am' ? 'ከ:' : 'From:'}
            </span>
            <input
              type="date"
              value={startDate}
              onChange={(e) => onStartDateChange(e.target.value)}
              className="bg-transparent text-slate-800 dark:text-slate-100 text-xs font-semibold focus:outline-none cursor-pointer"
            />
          </div>

          <span className="text-slate-400 dark:text-slate-500 text-xs font-bold">→</span>

          <div className="flex items-center gap-1.5 px-2.5 py-1 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs shadow-2xs">
            <span className="text-slate-400 dark:text-slate-500 font-semibold">
              {lang === 'am' ? 'እስከ:' : 'To:'}
            </span>
            <input
              type="date"
              value={endDate}
              onChange={(e) => onEndDateChange(e.target.value)}
              className="bg-transparent text-slate-800 dark:text-slate-100 text-xs font-semibold focus:outline-none cursor-pointer"
            />
          </div>

          {onReset && (startDate || endDate) && (
            <button
              type="button"
              onClick={onReset}
              title={lang === 'am' ? 'ቀኖቹን አጽዳ' : 'Clear dates'}
              className="p-1 rounded-lg text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 cursor-pointer"
            >
              <X size={14} />
            </button>
          )}
        </div>
      )}

      {/* Active Range Feedback pill when preset is not ALL */}
      {preset !== 'ALL' && preset !== 'CUSTOM' && (
        <span className="inline-flex items-center gap-1 text-[11px] font-bold text-slate-500 dark:text-slate-400 bg-slate-100/70 dark:bg-slate-800/50 px-2 py-0.5 rounded-md border border-slate-200/50 dark:border-slate-700/50">
          <CalendarDays size={12} className="text-brand-600 dark:text-cyan-400" />
          <span>
            {preset === 'TODAY' && (lang === 'am' ? 'ዛሬ የተመዘገቡ ብቻ' : 'Active: Today only')}
            {preset === '7D' && (lang === 'am' ? 'ባለፉት 7 ቀናት' : 'Active: Past 7 days')}
            {preset === '30D' && (lang === 'am' ? 'ባለፉት 30 ቀናት' : 'Active: Past 30 days')}
            {preset === 'THIS_MONTH' && (lang === 'am' ? 'የዚህ ወር መዝገቦች' : 'Active: Current month')}
          </span>
        </span>
      )}
    </div>
  );
};
