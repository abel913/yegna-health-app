import React, { createContext, useContext, useState, useCallback } from 'react';
import { CheckCircle2, AlertCircle, Info, AlertTriangle, X } from 'lucide-react';

export type ToastType = 'success' | 'error' | 'info' | 'warning';

export interface ToastMessage {
  id: string;
  type: ToastType;
  title?: string;
  message: string;
  duration?: number;
}

interface ToastContextType {
  toast: {
    success: (message: string, title?: string) => void;
    error: (message: string, title?: string) => void;
    info: (message: string, title?: string) => void;
    warning: (message: string, title?: string) => void;
  };
}

const ToastContext = createContext<ToastContextType | undefined>(undefined);

export const ToastProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [toasts, setToasts] = useState<ToastMessage[]>([]);

  const removeToast = useCallback((id: string) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  }, []);

  const addToast = useCallback(
    (type: ToastType, message: string, title?: string, duration = 3800) => {
      const id = `${Date.now()}_${Math.random().toString(36).substring(2, 9)}`;
      const newToast: ToastMessage = { id, type, title, message, duration };

      setToasts((prev) => [...prev, newToast]);

      if (duration > 0) {
        setTimeout(() => {
          removeToast(id);
        }, duration);
      }
    },
    [removeToast]
  );

  const toast = {
    success: (message: string, title?: string) => addToast('success', message, title),
    error: (message: string, title?: string) => addToast('error', message, title),
    info: (message: string, title?: string) => addToast('info', message, title),
    warning: (message: string, title?: string) => addToast('warning', message, title),
  };

  return (
    <ToastContext.Provider value={{ toast }}>
      {children}
      {/* Floating Toast Notification Container */}
      <div className="fixed top-5 right-5 z-[9999] flex flex-col gap-2.5 max-w-sm w-full pointer-events-none px-4 sm:px-0">
        {toasts.map((t) => (
          <div
            key={t.id}
            className={`pointer-events-auto rounded-2xl p-4 shadow-xl border flex items-start gap-3 transition-all transform animate-in slide-in-from-top-3 fade-in duration-200 ${
              t.type === 'success'
                ? 'bg-slate-900/95 text-emerald-100 border-emerald-500/40 backdrop-blur-md shadow-emerald-950/20'
                : t.type === 'error'
                ? 'bg-slate-900/95 text-rose-100 border-rose-500/40 backdrop-blur-md shadow-rose-950/20'
                : t.type === 'warning'
                ? 'bg-slate-900/95 text-amber-100 border-amber-500/40 backdrop-blur-md shadow-amber-950/20'
                : 'bg-slate-900/95 text-slate-100 border-slate-700 backdrop-blur-md shadow-slate-950/20'
            }`}
          >
            <div className="flex-shrink-0 mt-0.5">
              {t.type === 'success' && <CheckCircle2 size={18} className="text-emerald-400" />}
              {t.type === 'error' && <AlertCircle size={18} className="text-rose-400" />}
              {t.type === 'warning' && <AlertTriangle size={18} className="text-amber-400" />}
              {t.type === 'info' && <Info size={18} className="text-cyan-400" />}
            </div>

            <div className="flex-1 text-xs leading-relaxed">
              {t.title && <h5 className="font-bold text-white text-xs mb-0.5">{t.title}</h5>}
              <p className="text-white/90">{t.message}</p>
            </div>

            <button
              onClick={() => removeToast(t.id)}
              className="flex-shrink-0 p-1 text-white/50 hover:text-white rounded-lg hover:bg-white/10 transition-colors cursor-pointer"
            >
              <X size={14} />
            </button>
          </div>
        ))}
      </div>
    </ToastContext.Provider>
  );
};

export const useToast = (): ToastContextType => {
  const context = useContext(ToastContext);
  if (!context) {
    throw new Error('useToast must be used within a ToastProvider');
  }
  return context;
};
