import React, { useState } from 'react';
import {
  Lock,
  Mail,
  ArrowRight,
  ShieldCheck,
  Eye,
  EyeOff,
  Sun,
  Moon,
  Globe,
  Sparkles,
  Loader2,
  AlertCircle,
  Check,
} from 'lucide-react';
import { AdminUser } from '../types/index.js';
import { BrandLogo } from '../components/common/BrandLogo.js';
import { useTheme } from '../context/ThemeContext.js';

interface LoginPageProps {
  onLoginSuccess: (user: AdminUser) => void;
  lang: 'en' | 'am';
  onToggleLang?: () => void;
}

export const LoginPage: React.FC<LoginPageProps> = ({
  onLoginSuccess,
  lang,
  onToggleLang,
}) => {
  const { theme, toggleTheme } = useTheme();
  const [email, setEmail] = useState('admin@yegnahealth.org');
  const [password, setPassword] = useState('admin1234');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [copiedDemo, setCopiedDemo] = useState(false);

  const handleFillDemo = () => {
    setEmail('admin@yegnahealth.org');
    setPassword('admin1234');
    setError(null);
    setCopiedDemo(true);
    setTimeout(() => setCopiedDemo(false), 2500);
  };

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
        throw new Error(data.error || (lang === 'am' ? 'የመግቢያ መረጃው ትክክል አይደለም' : 'Login failed'));
      }

      const role = data.user.role.toUpperCase();
      if (role !== 'ADMIN' && role !== 'SUPER_ADMIN') {
        throw new Error(
          lang === 'am'
            ? 'ፍቃድ ተከልክሏል፡ ይህ ፖርታል ለዋና አስተዳዳሪዎች ብቻ የተፈቀደ ነው።'
            : 'Access denied: This portal is strictly for platform administrators.'
        );
      }

      localStorage.setItem('yegna_admin_token', data.token);
      localStorage.setItem('yegna_admin_user', JSON.stringify(data.user));
      onLoginSuccess(data.user);
    } catch (err: any) {
      setError(err.message || (lang === 'am' ? 'ማረጋገጥ አልተሳካም' : 'Authentication failed'));
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-900 flex items-center justify-center p-4 relative overflow-hidden font-['Plus_Jakarta_Sans',sans-serif]">
      {/* Background Decorative Glow */}
      <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-cyan-500/10 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-purple-500/10 rounded-full blur-3xl pointer-events-none" />

      {/* Top Floating Controls: Language & Theme Toggle */}
      <div className="absolute top-5 right-5 z-20 flex items-center gap-2">
        {onToggleLang && (
          <button
            type="button"
            onClick={onToggleLang}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-slate-800/80 hover:bg-slate-800 text-slate-200 text-xs font-bold border border-slate-700/80 backdrop-blur-md transition-all cursor-pointer shadow-md"
            title={lang === 'am' ? 'Switch to English' : 'ወደ አማርኛ ቀይር'}
          >
            <Globe size={14} className="text-cyan-400" />
            <span>{lang === 'am' ? 'English' : 'አማርኛ'}</span>
          </button>
        )}

        <button
          type="button"
          onClick={toggleTheme}
          className="p-2 rounded-xl bg-slate-800/80 hover:bg-slate-800 text-slate-200 border border-slate-700/80 backdrop-blur-md transition-all cursor-pointer shadow-md"
          title={theme === 'dark' ? 'Switch to Light Mode' : 'Switch to Dark Mode'}
        >
          {theme === 'dark' ? (
            <Sun size={15} className="text-amber-400" />
          ) : (
            <Moon size={15} className="text-cyan-400" />
          )}
        </button>
      </div>

      <div className="max-w-md w-full bg-white dark:bg-slate-900 rounded-3xl p-6 sm:p-8 shadow-2xl relative z-10 border border-slate-100 dark:border-slate-800 animate-in fade-in zoom-in-95 duration-200">
        {/* Brand Header */}
        <div className="flex flex-col items-center text-center mb-6">
          <BrandLogo size="xl" className="mb-3" />
          <h1 className="text-2xl font-extrabold text-slate-900 dark:text-white tracking-tight">
            {lang === 'am' ? 'የኛ ጤና' : 'Yegna Health'}
          </h1>
          <p className="text-xs font-bold text-brand-600 dark:text-cyan-400 uppercase tracking-widest mt-0.5">
            {lang === 'am' ? 'የድር አስተዳደር ፖርታል' : 'Desktop Web Admin Portal'}
          </p>
          <div className="mt-3 inline-flex items-center gap-1.5 px-3 py-1 bg-emerald-50 dark:bg-emerald-950/40 rounded-full text-emerald-800 dark:text-emerald-300 text-[11px] font-bold border border-emerald-200 dark:border-emerald-800">
            <ShieldCheck size={14} className="text-emerald-600 dark:text-emerald-400 flex-shrink-0" />
            <span>
              {lang === 'am'
                ? 'የተማሪዎች ሚስጥራዊ የጤና መረጃ ጥበቃ (Zero-Knowledge)'
                : 'Zero-Knowledge Student Privacy Vault'}
            </span>
          </div>
        </div>

        {/* 1-Click Quick Demo Fill Pill */}
        <div className="mb-4">
          <button
            type="button"
            onClick={handleFillDemo}
            className="w-full flex items-center justify-center gap-1.5 py-1.5 px-3 rounded-xl bg-slate-50 dark:bg-slate-800/80 hover:bg-slate-100 dark:hover:bg-slate-800 text-slate-700 dark:text-slate-300 border border-slate-200/80 dark:border-slate-700 text-xs font-bold transition-all cursor-pointer shadow-2xs"
          >
            {copiedDemo ? (
              <>
                <Check size={13} className="text-emerald-500" />
                <span className="text-emerald-600 dark:text-emerald-400">
                  {lang === 'am' ? 'የአስተዳዳሪ መረጃ ተሞልቷል!' : 'Demo Credentials Filled!'}
                </span>
              </>
            ) : (
              <>
                <Sparkles size={13} className="text-brand-600 dark:text-cyan-400" />
                <span>
                  {lang === 'am' ? 'የአስተዳዳሪ መረጃ በ1-ጠቅታ ሙላ (Quick Demo)' : 'Quick Fill Demo Credentials'}
                </span>
              </>
            )}
          </button>
        </div>

        {/* Error Alert */}
        {error && (
          <div className="mb-4 p-3 rounded-xl bg-rose-50 dark:bg-rose-950/40 border border-rose-200 dark:border-rose-800 text-rose-700 dark:text-rose-300 text-xs font-bold flex items-start gap-2 animate-in fade-in duration-150">
            <AlertCircle size={15} className="text-rose-600 dark:text-rose-400 flex-shrink-0 mt-0.5" />
            <span>{error}</span>
          </div>
        )}

        {/* Login Form */}
        <form onSubmit={handleSubmit} className="space-y-4 text-xs md:text-sm">
          <div>
            <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
              {lang === 'am' ? 'የአስተዳዳሪ ኢሜይል' : 'Admin Email Address'}
            </label>
            <div className="relative">
              <Mail
                size={16}
                className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 dark:text-slate-500 pointer-events-none"
              />
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full pl-10 pr-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl focus:bg-white dark:focus:bg-slate-800/80 focus:border-brand-500 dark:focus:border-cyan-400 focus:outline-hidden transition-all font-medium text-slate-800 dark:text-slate-100 placeholder-slate-400 dark:placeholder-slate-500"
                placeholder="admin@yegnahealth.org"
              />
            </div>
          </div>

          <div>
            <div className="flex items-center justify-between mb-1">
              <label className="block font-bold text-slate-700 dark:text-slate-300">
                {lang === 'am' ? 'የይለፍ ቃል' : 'Account Password'}
              </label>
              <button
                type="button"
                onClick={() => setShowPassword((prev) => !prev)}
                className="text-[11px] font-bold text-brand-600 dark:text-cyan-400 hover:underline flex items-center gap-1 cursor-pointer"
              >
                {showPassword ? (
                  <>
                    <EyeOff size={12} />
                    <span>{lang === 'am' ? 'ደብቅ' : 'Hide'}</span>
                  </>
                ) : (
                  <>
                    <Eye size={12} />
                    <span>{lang === 'am' ? 'አሳይ' : 'Show'}</span>
                  </>
                )}
              </button>
            </div>
            <div className="relative">
              <Lock
                size={16}
                className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 dark:text-slate-500 pointer-events-none"
              />
              <input
                type={showPassword ? 'text' : 'password'}
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full pl-10 pr-10 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl focus:bg-white dark:focus:bg-slate-800/80 focus:border-brand-500 dark:focus:border-cyan-400 focus:outline-hidden transition-all font-medium text-slate-800 dark:text-slate-100 placeholder-slate-400 dark:placeholder-slate-500"
                placeholder="••••••••"
              />
              <button
                type="button"
                onClick={() => setShowPassword((prev) => !prev)}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 cursor-pointer"
                title={showPassword ? (lang === 'am' ? 'የይለፍ ቃል ደብቅ' : 'Hide password') : (lang === 'am' ? 'የይለፍ ቃል አሳይ' : 'Show password')}
              >
                {showPassword ? <EyeOff size={15} /> : <Eye size={15} />}
              </button>
            </div>
          </div>

          <button
            type="submit"
            disabled={isLoading}
            className="w-full py-3 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl shadow-lg shadow-brand-600/25 flex items-center justify-center gap-2 transition-all disabled:opacity-60 cursor-pointer text-xs md:text-sm"
          >
            {isLoading ? (
              <>
                <Loader2 size={16} className="animate-spin" />
                <span>{lang === 'am' ? 'በማረጋገጥ ላይ...' : 'Signing In...'}</span>
              </>
            ) : (
              <>
                <span>{lang === 'am' ? 'ወደ አስተዳደር ፖርታል ግባ' : 'Sign In to Admin Portal'}</span>
                <ArrowRight size={16} />
              </>
            )}
          </button>
        </form>

        {/* Footer Note */}
        <div className="mt-6 pt-4 border-t border-slate-100 dark:border-slate-800 text-center space-y-1">
          <p className="text-[11px] text-slate-400 dark:text-slate-500 font-medium">
            {lang === 'am' ? 'የተዘጋጀ የአስተዳዳሪ መለያ፡' : 'Pre-seeded Executive Account:'}{' '}
            <span className="text-slate-700 dark:text-slate-300 font-bold">admin@yegnahealth.org</span>
          </p>
          <p className="text-[10px] text-slate-400 dark:text-slate-600">
            {lang === 'am'
              ? '256-ቢት የደህንነት ጥበቃ • የባለብዙ ሚና አስተዳደር'
              : '256-bit AES Vault • Multi-Role Access Control'}
          </p>
        </div>
      </div>
    </div>
  );
};
