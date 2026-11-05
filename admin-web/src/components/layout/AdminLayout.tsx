import React, { useState } from 'react';
import {
  LayoutDashboard,
  Hospital,
  Users2,
  BookOpen,
  HelpCircle,
  GraduationCap,
  ShieldAlert,
  History,
  LogOut,
  ShieldCheck,
  Search,
  Plus,
  Globe,
  Menu,
} from 'lucide-react';
import { AdminUser } from '../../types/index.js';

interface AdminLayoutProps {
  currentTab: string;
  onTabChange: (tab: string) => void;
  user: AdminUser;
  onLogout: () => void;
  lang: 'en' | 'am';
  onToggleLang: () => void;
  onQuickAction?: () => void;
  children: React.ReactNode;
}

export const AdminLayout: React.FC<AdminLayoutProps> = ({
  currentTab,
  onTabChange,
  user,
  onLogout,
  lang,
  onToggleLang,
  onQuickAction,
  children,
}) => {
  const [collapsed, setCollapsed] = useState(false);

  const navItems = [
    { id: 'dashboard', label: lang === 'am' ? 'ዳሽቦርድ' : 'Dashboard', icon: LayoutDashboard },
    { id: 'facilities', label: lang === 'am' ? 'የጤና ተቋማት' : 'Health Clinics', icon: Hospital },
    { id: 'mentors', label: lang === 'am' ? 'አማካሪዎች' : 'Peer Mentors', icon: Users2 },
    { id: 'modules', label: lang === 'am' ? 'የትምህርት ሞጁሎች' : 'Learning CMS', icon: BookOpen },
    { id: 'quizzes', label: lang === 'am' ? 'ፈተናዎች' : 'Quizzes & Tests', icon: HelpCircle },
    { id: 'clubs', label: lang === 'am' ? 'የተማሪዎች ክለቦች' : 'Student Clubs', icon: GraduationCap },
    { id: 'users', label: lang === 'am' ? 'ተጠቃሚዎች' : 'User Safety', icon: ShieldAlert },
    { id: 'audit', label: lang === 'am' ? 'የቁጥጥር መዝገብ' : 'Audit Logs', icon: History },
  ];

  return (
    <div className="flex h-screen bg-slate-50 overflow-hidden font-['Plus_Jakarta_Sans',sans-serif]">
      {/* 1. LEFT SIDEBAR */}
      <aside
        className={`bg-white border-r border-slate-200 transition-all duration-300 flex flex-col justify-between z-20 ${
          collapsed ? 'w-20' : 'w-64'
        }`}
      >
        <div>
          {/* Logo & Brand */}
          <div className="h-16 flex items-center justify-between px-4 border-b border-slate-100">
            <div className="flex items-center gap-3 overflow-hidden cursor-pointer" onClick={() => onTabChange('dashboard')}>
              <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-cyan-500 via-blue-500 to-pink-500 p-0.5 shadow-md shadow-cyan-500/20 flex-shrink-0 flex items-center justify-center">
                <div className="w-full h-full bg-white rounded-[10px] flex items-center justify-center">
                  <span className="text-xl">🩺</span>
                </div>
              </div>
              {!collapsed && (
                <div>
                  <h1 className="font-bold text-slate-900 text-base leading-tight tracking-tight">Yegna Health</h1>
                  <span className="text-[11px] font-semibold text-brand-600 uppercase tracking-wider">Admin Portal</span>
                </div>
              )}
            </div>
            <button
              onClick={() => setCollapsed(!collapsed)}
              className="p-1.5 rounded-lg text-slate-400 hover:text-slate-600 hover:bg-slate-100 transition-colors"
            >
              <Menu size={18} />
            </button>
          </div>

          {/* Navigation Links */}
          <nav className="p-3 space-y-1">
            {navItems.map((item) => {
              const Icon = item.icon;
              const isActive = currentTab === item.id;
              return (
                <button
                  key={item.id}
                  onClick={() => onTabChange(item.id)}
                  title={collapsed ? item.label : undefined}
                  className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold transition-all ${
                    isActive
                      ? 'bg-brand-50 text-brand-700 shadow-sm shadow-brand-500/10 font-bold'
                      : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'
                  }`}
                >
                  <Icon size={20} className={isActive ? 'text-brand-600' : 'text-slate-400'} />
                  {!collapsed && <span className="truncate">{item.label}</span>}
                </button>
              );
            })}
          </nav>
        </div>

        {/* Admin Footer & Logout */}
        <div className="p-3 border-t border-slate-100 bg-slate-50/50">
          <div className="flex items-center gap-3 p-2 rounded-xl">
            <div className="w-9 h-9 rounded-full bg-slate-900 text-white font-bold flex items-center justify-center text-xs flex-shrink-0 shadow-sm">
              {user.displayName.slice(0, 2).toUpperCase()}
            </div>
            {!collapsed && (
              <div className="min-w-0 flex-1">
                <p className="text-xs font-bold text-slate-900 truncate">{user.displayName}</p>
                <p className="text-[11px] text-slate-500 font-medium truncate">{user.role}</p>
              </div>
            )}
            <button
              onClick={onLogout}
              title="Sign Out"
              className="p-1.5 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-rose-50 transition-colors"
            >
              <LogOut size={16} />
            </button>
          </div>
        </div>
      </aside>

      {/* 2. MAIN VIEWPORT */}
      <div className="flex-1 flex flex-col h-screen overflow-hidden">
        {/* Top Header Bar */}
        <header className="h-16 bg-white border-b border-slate-200 px-6 flex items-center justify-between z-10">
          {/* Global Search Bar */}
          <div className="relative w-80">
            <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
            <input
              type="text"
              placeholder={lang === 'am' ? 'ፈልግ... (Ctrl+K)' : 'Search facilities, mentors, articles... (Ctrl+K)'}
              className="w-full pl-9 pr-4 py-2 bg-slate-100 hover:bg-slate-100/80 focus:bg-white text-xs font-medium rounded-xl border border-transparent focus:border-brand-500 focus:outline-none transition-all placeholder:text-slate-400"
            />
          </div>

          {/* Privacy Badge, Language Toggle & Actions */}
          <div className="flex items-center gap-3">
            {/* Student Privacy Shield Pill */}
            <div className="hidden md:flex items-center gap-2 px-3 py-1.5 bg-emerald-50 border border-emerald-200/80 rounded-full text-emerald-800 text-xs font-semibold shadow-xs">
              <ShieldCheck size={16} className="text-emerald-600" />
              <span>{lang === 'am' ? 'የተማሪዎች ሚስጥራዊነት የተጠበቀ ነው' : 'Zero-Knowledge Student Privacy Active'}</span>
            </div>

            {/* Language Switcher */}
            <button
              onClick={onToggleLang}
              className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl border border-slate-200 hover:bg-slate-50 text-xs font-bold text-slate-700 transition-colors"
            >
              <Globe size={14} className="text-slate-500" />
              <span>{lang === 'am' ? 'አማርኛ (AM)' : 'English (EN)'}</span>
            </button>

            {/* Quick Action Button */}
            {onQuickAction && (
              <button
                onClick={onQuickAction}
                className="flex items-center gap-1.5 px-3.5 py-1.5 bg-brand-600 hover:bg-brand-700 text-white text-xs font-bold rounded-xl shadow-sm shadow-brand-600/20 transition-colors"
              >
                <Plus size={16} />
                <span>{lang === 'am' ? 'አዲስ ክሊኒክ መዝግብ' : 'Add Facility'}</span>
              </button>
            )}
          </div>
        </header>

        {/* Scrollable Page Body */}
        <main className="flex-1 overflow-y-auto p-6 md:p-8">
          <div className="max-w-7xl mx-auto">{children}</div>
        </main>
      </div>
    </div>
  );
};
