import React from 'react';

interface TableSkeletonProps {
  rows?: number;
  colSpan: number;
}

export const TableSkeleton: React.FC<TableSkeletonProps> = ({ rows = 5, colSpan }) => {
  return (
    <>
      {Array.from({ length: rows }).map((_, rIdx) => (
        <tr key={rIdx} className="border-b border-slate-100 dark:border-slate-800/80 animate-pulse">
          <td colSpan={colSpan} className="py-4 px-4">
            <div className="flex items-center gap-4">
              <div className="w-10 h-10 rounded-xl bg-slate-200 dark:bg-slate-800 shrink-0" />
              <div className="flex-1 space-y-2">
                <div className="h-3.5 bg-slate-200 dark:bg-slate-800 rounded w-1/3" />
                <div className="h-2.5 bg-slate-100 dark:bg-slate-800/60 rounded w-1/2" />
              </div>
              <div className="h-6 bg-slate-100 dark:bg-slate-800/60 rounded w-20 hidden md:block" />
              <div className="h-6 bg-slate-100 dark:bg-slate-800/60 rounded w-16" />
            </div>
          </td>
        </tr>
      ))}
    </>
  );
};
