import React, { useState } from 'react';
import { Lock, Mail, ArrowRight, ShieldCheck } from 'lucide-react';
import { AdminUser } from '../types/index.js';

interface LoginPageProps {
  onLoginSuccess: (user: AdminUser) => void;
  lang: 'en' | 'am';
}

export const LoginPage: React.FC<LoginPageProps> = ({ onLoginSuccess, lang: _lang }) => {
  const [email, setEmail] = useState('admin@yegnahealth.org');
  const [password, setPassword] = useState('admin1234');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError(null);

    try {
      const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      });

      const data = await res.json();
      if (!res.ok) {
        throw new Error(data.error || 'Login failed');
      }

      const role = data.user.role.toUpperCase();
      if (role !== 'ADMIN' && role !== 'SUPER_ADMIN') {
        throw new Error('Access denied: This portal is strictly for platform administrators.');
      }

      localStorage.setItem('yegna_admin_token', data.token);
      localStorage.setItem('yegna_admin_user', JSON.stringify(data.user));
      onLoginSuccess(data.user);
    } catch (err: any) {
      setError(err.message || 'Authentication failed');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-900 flex items-center justify-center p-4 relative overflow-hidden font-['Plus_Jakarta_Sans',sans-serif]">
      {/* Background Glow */}
      <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-cyan-500/10 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-purple-500/10 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-md w-full bg-white rounded-3xl p-8 shadow-2xl relative z-10 border border-slate-100">
        {/* Brand */}
        <div className="flex flex-col items-center text-center mb-6">
          <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-cyan-500 via-blue-500 to-pink-500 p-0.5 shadow-lg shadow-cyan-500/25 mb-3 flex items-center justify-center">
            <div className="w-full h-full bg-white rounded-[14px] flex items-center justify-center text-2xl">
              🩺
            </div>
          </div>
          <h1 className="text-2xl font-extrabold text-slate-900 tracking-tight">Yegna Health</h1>
          <p className="text-xs font-semibold text-brand-600 uppercase tracking-widest mt-0.5">
            Desktop Web Admin Portal
          </p>
          <div className="mt-3 inline-flex items-center gap-1.5 px-3 py-1 bg-emerald-50 rounded-full text-emerald-800 text-[11px] font-bold border border-emerald-200">
            <ShieldCheck size={14} className="text-emerald-600" />
            <span>Zero-Knowledge Student Privacy Vault</span>
          </div>
        </div>

        {error && (
          <div className="mb-4 p-3 rounded-xl bg-rose-50 border border-rose-200 text-rose-700 text-xs font-bold">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4 text-xs md:text-sm">
          <div>
            <label className="block font-bold text-slate-700 mb-1">Admin Email</label>
            <div className="relative">
              <Mail size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full pl-10 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:border-brand-500 focus:outline-none transition-all font-medium"
                placeholder="admin@yegnahealth.org"
              />
            </div>
          </div>

          <div>
            <label className="block font-bold text-slate-700 mb-1">Password</label>
            <div className="relative">
              <Lock size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
              <input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full pl-10 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:border-brand-500 focus:outline-none transition-all font-medium"
                placeholder="••••••••"
              />
            </div>
          </div>

          <button
            type="submit"
            disabled={isLoading}
            className="w-full py-3 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl shadow-lg shadow-brand-600/25 flex items-center justify-center gap-2 transition-all disabled:opacity-60"
          >
            <span>{isLoading ? 'Signing In...' : 'Sign In to Admin Portal'}</span>
            <ArrowRight size={16} />
          </button>
        </form>

        <div className="mt-6 pt-4 border-t border-slate-100 text-center">
          <p className="text-[11px] text-slate-400 font-medium">
            Pre-seeded Executive Account: <span className="text-slate-700 font-bold">admin@yegnahealth.org</span>
          </p>
        </div>
      </div>
    </div>
  );
};
