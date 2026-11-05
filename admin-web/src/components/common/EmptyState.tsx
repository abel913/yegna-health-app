import React from 'react';
import { SearchX, Plus, RefreshCw } from 'lucide-react';

interface EmptyStateProps {
  icon?: React.ComponentType<{ size?: number; className?: string }>;
  title: string;
  description: string;
  actionLabel?: string;
  onAction?: () => void;
  clearLabel?: string;
  onClear?: () => void;
  colSpan?: number;
}

export const EmptyState: React.FC<EmptyStateProps> = ({
  icon: Icon = SearchX,
  title,
  description,
  actionLabel,
  onAction,
  clearLabel,
  onClear,
  colSpan,
}) => {
  const content = (
    <div className="py-14 px-4 flex flex-col items-center justify-center text-center max-w-md mx-auto animate-in fade-in zoom-in-95 duration-200">
      <div className="w-14 h-14 rounded-2xl bg-slate-100 dark:bg-slate-800 text-slate-400 dark:text-slate-500 flex items-center justify-center mb-3 shadow-2xs border border-slate-200/60 dark:border-slate-700/60">
        <Icon size={26} className="text-slate-400 dark:text-slate-400" />
      </div>

      <h4 className="text-sm md:text-base font-extrabold text-slate-800 dark:text-white mb-1">
        {title}
      </h4>
      <p className="text-xs text-slate-500 dark:text-slate-400 leading-relaxed mb-4">
        {description}
      </p>

      <div className="flex flex-wrap items-center justify-center gap-2">
        {onClear && clearLabel && (
          <button
            type="button"
            onClick={onClear}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl border border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-600 dark:text-slate-300 text-xs font-bold transition-all cursor-pointer shadow-2xs"
          >
            <RefreshCw size={13} />
            <span>{clearLabel}</span>
          </button>
        )}

        {onAction && actionLabel && (
          <button
            type="button"
            onClick={onAction}
            className="flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white text-xs font-bold shadow-sm shadow-brand-600/20 transition-all cursor-pointer"
          >
            <Plus size={14} />
            <span>{actionLabel}</span>
          </button>
        )}
      </div>
    </div>
  );

  if (colSpan !== undefined) {
    return (
      <tr>
        <td colSpan={colSpan} className="p-0">
          {content}
        </td>
      </tr>
    );
  }

  return content;
};
