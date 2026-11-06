import React, { useEffect, useState } from 'react';
import { Trash2, AlertTriangle, X, Loader2 } from 'lucide-react';

interface ConfirmModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => Promise<void> | void;
  title?: string;
  itemName?: string;
  message?: string;
  confirmLabel?: string;
  cancelLabel?: string;
  lang?: 'en' | 'am';
  isLoading?: boolean;
}

export const ConfirmModal: React.FC<ConfirmModalProps> = ({
  isOpen,
  onClose,
  onConfirm,
  title,
  itemName,
  message,
  confirmLabel,
  cancelLabel,
  lang = 'en',
  isLoading = false,
}) => {
  const [internalLoading, setInternalLoading] = useState(false);

  // Lock body scroll when modal is open
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => {
      document.body.style.overflow = '';
    };
  }, [isOpen]);

  // Handle Escape key to dismiss
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && isOpen && !internalLoading && !isLoading) {
        onClose();
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, internalLoading, isLoading, onClose]);

  if (!isOpen) return null;

  const handleConfirmClick = async () => {
    setInternalLoading(true);
    try {
      await onConfirm();
      onClose();
    } catch {
      // Any error handling is managed by the caller
    } finally {
      setInternalLoading(false);
    }
  };

  const isBusy = isLoading || internalLoading;

  const defaultTitle =
    title ||
    (lang === 'am' ? 'ይህ መረጃ በቋሚነት ይሰረዝ?' : 'Are you sure you want to delete this?');

  const defaultMessage =
    message ||
    (lang === 'am'
      ? 'ይህ እርምጃ ወደ ኋላ ሊመለስ አይችልም። መረጃው ከመረጃ ቋቱ በቋሚነት ይወገዳል።'
      : 'This action cannot be undone. This record will be permanently deleted from the database.');

  const defaultConfirmLabel =
    confirmLabel || (lang === 'am' ? 'አዎ፣ ሰርዝ' : 'Yes, Delete');

  const defaultCancelLabel =
    cancelLabel || (lang === 'am' ? 'ይቅር / ተመለስ' : 'Cancel');

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/60 backdrop-blur-xs animate-in fade-in duration-150"
      onClick={() => {
        if (!isBusy) onClose();
      }}
      role="dialog"
      aria-modal="true"
    >
      <div
        className="w-full max-w-md bg-white dark:bg-slate-900 rounded-3xl border border-slate-200/90 dark:border-slate-800 shadow-2xl p-6 sm:p-7 relative animate-in zoom-in-95 duration-150"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Close Button */}
        <button
          type="button"
          onClick={onClose}
          disabled={isBusy}
          className="absolute right-5 top-5 p-1.5 rounded-xl text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer disabled:opacity-40"
          aria-label="Close dialog"
        >
          <X size={18} />
        </button>

        {/* Danger Icon & Heading */}
        <div className="flex flex-col items-center text-center">
          <div className="w-14 h-14 rounded-2xl bg-rose-50 dark:bg-rose-950/50 border border-rose-200/80 dark:border-rose-900/60 text-rose-600 dark:text-rose-400 flex items-center justify-center mb-4 shadow-sm relative">
            <Trash2 size={26} />
            <span className="absolute -top-1 -right-1 w-4 h-4 rounded-full bg-rose-500 text-white flex items-center justify-center shadow-xs">
              <AlertTriangle size={10} />
            </span>
          </div>

          <h3 className="text-base sm:text-lg font-extrabold text-slate-900 dark:text-white leading-tight">
            {defaultTitle}
          </h3>

          {itemName && (
            <div className="mt-2 inline-flex items-center px-3 py-1 bg-slate-100 dark:bg-slate-800 rounded-xl border border-slate-200/60 dark:border-slate-700 max-w-full">
              <span className="text-xs font-mono font-bold text-slate-800 dark:text-slate-200 truncate">
                "{itemName}"
              </span>
            </div>
          )}

          <p className="mt-3 text-xs sm:text-sm text-slate-500 dark:text-slate-400 leading-relaxed max-w-sm">
            {defaultMessage}
          </p>
        </div>

        {/* Action Buttons */}
        <div className="mt-6 pt-4 border-t border-slate-100 dark:border-slate-800 grid grid-cols-2 gap-3">
          <button
            type="button"
            onClick={onClose}
            disabled={isBusy}
            className="w-full py-2.5 px-4 rounded-xl border border-slate-200 dark:border-slate-700 hover:bg-slate-100 dark:hover:bg-slate-800 text-slate-700 dark:text-slate-300 font-bold text-xs sm:text-sm transition-colors cursor-pointer disabled:opacity-50"
          >
            {defaultCancelLabel}
          </button>

          <button
            type="button"
            onClick={handleConfirmClick}
            disabled={isBusy}
            className="w-full py-2.5 px-4 rounded-xl bg-rose-600 hover:bg-rose-700 active:bg-rose-800 text-white font-bold text-xs sm:text-sm shadow-md shadow-rose-600/20 transition-all flex items-center justify-center gap-1.5 cursor-pointer disabled:opacity-50"
          >
            {isBusy ? (
              <>
                <Loader2 size={15} className="animate-spin" />
                <span>{lang === 'am' ? 'በመሰረዝ ላይ...' : 'Deleting...'}</span>
              </>
            ) : (
              <>
                <Trash2 size={14} />
                <span>{defaultConfirmLabel}</span>
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};
