import React from 'react';
import { ChevronUp, ChevronDown, ChevronsUpDown } from 'lucide-react';

export type SortOrder = 'asc' | 'desc' | null;

interface SortableHeaderProps {
  label: string;
  field: string;
  currentField: string | null;
  currentOrder: SortOrder;
  onSort: (field: string) => void;
  className?: string;
  align?: 'left' | 'right' | 'center';
}

export const SortableHeader: React.FC<SortableHeaderProps> = ({
  label,
  field,
  currentField,
  currentOrder,
  onSort,
  className = '',
  align = 'left',
}) => {
  const isActive = currentField === field && currentOrder !== null;

  return (
    <th
      onClick={() => onSort(field)}
      className={`py-3 px-4 cursor-pointer select-none group transition-colors text-${align} ${className}`}
    >
      <div
        className={`inline-flex items-center gap-1.5 ${
          align === 'right' ? 'justify-end w-full' : align === 'center' ? 'justify-center w-full' : ''
        }`}
      >
        <span
          className={`transition-colors ${
            isActive
              ? 'text-brand-600 dark:text-cyan-400 font-extrabold'
              : 'text-slate-500 dark:text-slate-400 group-hover:text-slate-800 dark:group-hover:text-slate-200'
          }`}
        >
          {label}
        </span>
        <span
          className={`p-0.5 rounded transition-colors ${
            isActive
              ? 'bg-brand-50 dark:bg-cyan-950/60 text-brand-600 dark:text-cyan-400'
              : 'text-slate-300 dark:text-slate-600 group-hover:text-slate-500 dark:group-hover:text-slate-400'
          }`}
        >
          {isActive ? (
            currentOrder === 'asc' ? (
              <ChevronUp size={13} className="stroke-[2.5]" />
            ) : (
              <ChevronDown size={13} className="stroke-[2.5]" />
            )
          ) : (
            <ChevronsUpDown size={12} className="opacity-70 group-hover:opacity-100" />
          )}
        </span>
      </div>
    </th>
  );
};
