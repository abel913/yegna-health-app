import React, { useState, useEffect } from 'react';
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
  X,
  Sun,
  Moon,
  ChevronLeft,
  ChevronRight,
} from 'lucide-react';
import { AdminUser } from '../../types/index.js';
import { useTheme } from '../../context/ThemeContext.js';
import { SystemHealthIndicator } from '../common/SystemHealthIndicator.js';

interface AdminLayoutProps {
  currentTab: string;
  onTabChange: (tab: string) => void;
  user: AdminUser;
  onLogout: () => void;
  lang: 'en' | 'am';
  onToggleLang: () => void;
  onQuickAction?: () => void;
  onOpenCommandPalette?: () => void;
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
  onOpenCommandPalette,
  children,
}) => {
  const [collapsed, setCollapsed] = useState(false);
  const [mobileDrawerOpen, setMobileDrawerOpen] = useState(false);
  const { toggleTheme, isDark } = useTheme();

  // Navigation Items
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

  // Lock body scroll when mobile drawer is open
  useEffect(() => {
    if (mobileDrawerOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => {
      document.body.style.overflow = '';
    };
  }, [mobileDrawerOpen]);

  // Handle Esc key to close mobile drawer
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && mobileDrawerOpen) {
        setMobileDrawerOpen(false);
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [mobileDrawerOpen]);

  // Handle mobile navigation selection
  const handleSelectTab = (tabId: string) => {
    onTabChange(tabId);
    setMobileDrawerOpen(false);
  };

  return (
    <div className="flex h-screen bg-slate-50 dark:bg-slate-950 overflow-hidden font-['Plus_Jakarta_Sans',sans-serif] text-slate-800 dark:text-slate-100 transition-colors duration-200">
      {/* ========================================================= */}
      {/* 1. MOBILE / TABLET OFF-CANVAS OVERLAY & SLIDE-OUT DRAWER  */}
      {/* ========================================================= */}
      {mobileDrawerOpen && (
        <div
          className="fixed inset-0 z-40 bg-slate-950/60 backdrop-blur-xs lg:hidden transition-opacity duration-300 animate-in fade-in"
          onClick={() => setMobileDrawerOpen(false)}
          aria-hidden="true"
        />
      )}

      <aside
        role="dialog"
        aria-modal="true"
        aria-label="Mobile Navigation Drawer"
        className={`fixed top-0 bottom-0 left-0 z-50 w-72 max-w-[85vw] bg-white dark:bg-slate-900 border-r border-slate-200 dark:border-slate-800 shadow-2xl flex flex-col justify-between transition-transform duration-300 ease-in-out lg:hidden ${
          mobileDrawerOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="flex flex-col h-full justify-between">
          <div>
            {/* Mobile Drawer Header */}
            <div className="h-16 flex items-center justify-between px-4 border-b border-slate-100 dark:border-slate-800">
              <div
                className="flex items-center gap-3 cursor-pointer"
                onClick={() => handleSelectTab('dashboard')}
              >
                <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-cyan-500 via-blue-500 to-pink-500 p-0.5 shadow-md shadow-cyan-500/20 flex-shrink-0 flex items-center justify-center">
                  <div className="w-full h-full bg-white dark:bg-slate-900 rounded-[10px] flex items-center justify-center">
                    <span className="text-xl">🩺</span>
                  </div>
                </div>
                <div>
                  <h1 className="font-bold text-slate-900 dark:text-white text-base leading-tight tracking-tight">
                    Yegna Health
                  </h1>
                  <span className="text-[11px] font-semibold text-brand-600 dark:text-cyan-400 uppercase tracking-wider">
                    Admin Portal
                  </span>
                </div>
              </div>

              <button
                type="button"
                onClick={() => setMobileDrawerOpen(false)}
                className="p-1.5 rounded-xl text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer"
                aria-label="Close navigation menu"
              >
                <X size={20} />
              </button>
            </div>

            {/* Mobile Navigation Links */}
            <nav className="p-3 space-y-1 overflow-y-auto max-h-[calc(100vh-230px)]">
              {navItems.map((item) => {
                const Icon = item.icon;
                const isActive = currentTab === item.id;
                return (
                  <button
                    key={item.id}
                    onClick={() => handleSelectTab(item.id)}
                    className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold transition-all cursor-pointer ${
                      isActive
                        ? 'bg-brand-50 dark:bg-brand-950/60 text-brand-700 dark:text-cyan-300 shadow-xs font-bold border border-brand-200/50 dark:border-cyan-800/40'
                        : 'text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800/70 hover:text-slate-900 dark:hover:text-white'
                    }`}
                  >
                    <Icon
                      size={20}
                      className={isActive ? 'text-brand-600 dark:text-cyan-400' : 'text-slate-400 dark:text-slate-500'}
                    />
                    <span className="truncate">{item.label}</span>
                  </button>
                );
              })}
            </nav>
          </div>

          {/* Mobile Drawer Footer Controls */}
          <div className="p-3 border-t border-slate-100 dark:border-slate-800 bg-slate-50/70 dark:bg-slate-900/80 space-y-2">
            {/* Theme & Language Quick Switchers Row */}
            <div className="grid grid-cols-2 gap-2">
              <button
                type="button"
                onClick={toggleTheme}
                className="flex items-center justify-center gap-1.5 py-2 px-2.5 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-xs font-bold text-slate-700 dark:text-slate-200 hover:bg-slate-50 dark:hover:bg-slate-750 transition-colors cursor-pointer shadow-2xs"
              >
                {isDark ? (
                  <>
                    <Sun size={14} className="text-amber-400" />
                    <span>Light</span>
                  </>
                ) : (
                  <>
                    <Moon size={14} className="text-slate-600" />
                    <span>Dark</span>
                  </>
                )}
              </button>

              <button
                type="button"
                onClick={onToggleLang}
                className="flex items-center justify-center gap-1.5 py-2 px-2.5 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-xs font-bold text-slate-700 dark:text-slate-200 hover:bg-slate-50 dark:hover:bg-slate-750 transition-colors cursor-pointer shadow-2xs"
              >
                <Globe size={14} className="text-slate-500 dark:text-slate-400" />
                <span>{lang === 'am' ? 'English' : 'አማርኛ'}</span>
              </button>
            </div>

            {/* Mobile In-Drawer Live Telemetry Bar */}
            <div className="flex items-center justify-between px-2.5 py-1.5 rounded-xl bg-slate-100/80 dark:bg-slate-800/60 border border-slate-200/50 dark:border-slate-700/50 text-[11px] font-bold text-slate-600 dark:text-slate-300">
              <span className="flex items-center gap-1.5">
                <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
                <span>{lang === 'am' ? 'የሲስተም ጤና' : 'API & Telemetry'}</span>
              </span>
              <span className="text-[10px] text-emerald-600 dark:text-emerald-400 font-mono">
                Online • SQLite Synced
              </span>
            </div>

            {/* User Profile & Sign Out Card */}
            <div className="flex items-center justify-between p-2 rounded-xl bg-white dark:bg-slate-800/60 border border-slate-200/60 dark:border-slate-700/60">
              <div className="flex items-center gap-2.5 min-w-0">
                <div className="w-8 h-8 rounded-full bg-slate-900 dark:bg-brand-600 text-white font-bold flex items-center justify-center text-xs flex-shrink-0 shadow-sm">
                  {user.displayName.slice(0, 2).toUpperCase()}
                </div>
                <div className="min-w-0">
                  <p className="text-xs font-bold text-slate-900 dark:text-white truncate">{user.displayName}</p>
                  <p className="text-[10px] text-slate-400 dark:text-slate-500 font-medium truncate">{user.role}</p>
                </div>
              </div>

              <button
                onClick={onLogout}
                title="Sign Out"
                className="p-1.5 text-slate-400 hover:text-rose-600 dark:hover:text-rose-400 rounded-lg hover:bg-rose-50 dark:hover:bg-rose-950/40 transition-colors cursor-pointer"
              >
                <LogOut size={16} />
              </button>
            </div>
          </div>
        </div>
      </aside>

      {/* ========================================================= */}
      {/* 2. DESKTOP COLLAPSIBLE SIDEBAR                            */}
      {/* ========================================================= */}
      <aside
        className={`hidden lg:flex bg-white dark:bg-slate-900 border-r border-slate-200 dark:border-slate-800 transition-all duration-300 flex-col justify-between z-20 ${
          collapsed ? 'w-20' : 'w-64'
        }`}
      >
        <div>
          {/* Logo & Brand */}
          <div className="h-16 flex items-center justify-between px-4 border-b border-slate-100 dark:border-slate-800">
            <div
              className="flex items-center gap-3 overflow-hidden cursor-pointer"
              onClick={() => onTabChange('dashboard')}
            >
              <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-cyan-500 via-blue-500 to-pink-500 p-0.5 shadow-md shadow-cyan-500/20 flex-shrink-0 flex items-center justify-center">
                <div className="w-full h-full bg-white dark:bg-slate-900 rounded-[10px] flex items-center justify-center">
                  <span className="text-xl">🩺</span>
                </div>
              </div>
              {!collapsed && (
                <div>
                  <h1 className="font-bold text-slate-900 dark:text-white text-base leading-tight tracking-tight">
                    Yegna Health
                  </h1>
                  <span className="text-[11px] font-semibold text-brand-600 dark:text-cyan-400 uppercase tracking-wider">
                    Admin Portal
                  </span>
                </div>
              )}
            </div>
            <button
              onClick={() => setCollapsed(!collapsed)}
              title={collapsed ? 'Expand sidebar' : 'Collapse sidebar'}
              className="p-1.5 rounded-lg text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer"
            >
              {collapsed ? <ChevronRight size={18} /> : <ChevronLeft size={18} />}
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
                  className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold transition-all cursor-pointer ${
                    isActive
                      ? 'bg-brand-50 dark:bg-brand-950/60 text-brand-700 dark:text-cyan-300 shadow-xs font-bold border border-brand-200/50 dark:border-cyan-800/40'
                      : 'text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800/70 hover:text-slate-900 dark:hover:text-white'
                  }`}
                >
                  <Icon
                    size={20}
                    className={isActive ? 'text-brand-600 dark:text-cyan-400' : 'text-slate-400 dark:text-slate-500'}
                  />
                  {!collapsed && <span className="truncate">{item.label}</span>}
                </button>
              );
            })}
          </nav>
        </div>

        {/* Desktop Admin Footer & Logout */}
        <div className="p-3 border-t border-slate-100 dark:border-slate-800 bg-slate-50/50 dark:bg-slate-900/50">
          <div className="flex items-center gap-3 p-2 rounded-xl">
            <div className="w-9 h-9 rounded-full bg-slate-900 dark:bg-brand-600 text-white font-bold flex items-center justify-center text-xs flex-shrink-0 shadow-sm">
              {user.displayName.slice(0, 2).toUpperCase()}
            </div>
            {!collapsed && (
              <div className="min-w-0 flex-1">
                <p className="text-xs font-bold text-slate-900 dark:text-white truncate">{user.displayName}</p>
                <p className="text-[11px] text-slate-500 dark:text-slate-400 font-medium truncate">{user.role}</p>
              </div>
            )}
            <button
              onClick={onLogout}
              title="Sign Out"
              className="p-1.5 text-slate-400 hover:text-rose-600 dark:hover:text-rose-400 rounded-lg hover:bg-rose-50 dark:hover:bg-rose-950/40 transition-colors cursor-pointer"
            >
              <LogOut size={16} />
            </button>
          </div>
        </div>
      </aside>

      {/* ========================================================= */}
      {/* 3. MAIN VIEWPORT & HEADER BAR                             */}
      {/* ========================================================= */}
      <div className="flex-1 flex flex-col h-screen overflow-hidden">
        {/* Top Header Bar */}
        <header className="h-16 bg-white dark:bg-slate-900 border-b border-slate-200 dark:border-slate-800 px-3 sm:px-6 flex items-center justify-between z-10 transition-colors duration-200">
          {/* Left: Mobile Drawer Trigger + Search Input */}
          <div className="flex items-center gap-2 sm:gap-3 min-w-0">
            {/* Mobile Hamburger Drawer Trigger */}
            <button
              type="button"
              onClick={() => setMobileDrawerOpen(true)}
              className="lg:hidden p-2 rounded-xl text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer"
              aria-label="Open Navigation Drawer"
            >
              <Menu size={20} />
            </button>

            {/* Mobile Brand Icon (on tiny screens) */}
            <div
              className="sm:hidden w-8 h-8 rounded-lg bg-gradient-to-tr from-cyan-500 via-blue-500 to-pink-500 p-0.5 shadow-2xs flex-shrink-0 flex items-center justify-center cursor-pointer"
              onClick={() => onTabChange('dashboard')}
            >
              <div className="w-full h-full bg-white dark:bg-slate-900 rounded-[6px] flex items-center justify-center text-sm">
                🩺
              </div>
            </div>

            {/* Global Search Bar / Command Palette Trigger */}
            <button
              type="button"
              onClick={onOpenCommandPalette}
              className="flex items-center justify-between flex-1 min-w-[130px] max-w-[190px] sm:max-w-xs md:w-80 px-2.5 sm:px-3.5 py-1.5 sm:py-2 bg-slate-100 dark:bg-slate-800/80 hover:bg-slate-200/70 dark:hover:bg-slate-700/80 border border-slate-200/80 dark:border-slate-700 rounded-xl text-xs font-medium text-slate-500 dark:text-slate-400 transition-all cursor-pointer group shadow-2xs text-left"
            >
              <div className="flex items-center gap-2 truncate">
                <Search
                  size={14}
                  className="text-slate-400 dark:text-slate-500 group-hover:text-brand-600 dark:group-hover:text-cyan-400 transition-colors flex-shrink-0"
                />
                <span className="text-slate-500 dark:text-slate-400 group-hover:text-slate-800 dark:group-hover:text-slate-200 transition-colors truncate">
                  {lang === 'am' ? 'ፈልግ...' : 'Search (⌘K)...'}
                </span>
              </div>
              <kbd className="hidden md:inline-flex items-center gap-0.5 px-1.5 py-0.5 rounded-md bg-white dark:bg-slate-700 border border-slate-200 dark:border-slate-600 text-[10px] font-bold text-slate-500 dark:text-slate-300 shadow-2xs flex-shrink-0">
                <span className="text-[11px]">⌘</span>K
              </kbd>
            </button>
          </div>

          {/* Right: Telemetry, Privacy Shield, Theme Toggle, Language Toggle & Quick Action */}
          <div className="flex items-center gap-1.5 sm:gap-2.5">
            {/* Live Infrastructure Telemetry Health Indicator */}
            <SystemHealthIndicator lang={lang} />

            {/* Zero-Knowledge Privacy Shield Pill (Desktop/Tablet) */}
            <div className="hidden xl:flex items-center gap-2 px-3 py-1.5 bg-emerald-50 dark:bg-emerald-950/40 border border-emerald-200/80 dark:border-emerald-800 rounded-full text-emerald-800 dark:text-emerald-300 text-xs font-semibold shadow-xs">
              <ShieldCheck size={16} className="text-emerald-600 dark:text-emerald-400" />
              <span>{lang === 'am' ? 'የተማሪዎች ሚስጥራዊነት የተጠበቀ ነው' : 'Zero-Knowledge Student Privacy Active'}</span>
            </div>

            {/* Dark / Light Mode Switcher */}
            <button
              type="button"
              onClick={toggleTheme}
              title={
                isDark
                  ? lang === 'am'
                    ? 'ወደ ብሩህ ገጽታ ቀይር (Light Mode)'
                    : 'Switch to Light Mode'
                  : lang === 'am'
                  ? 'ወደ ጥቁር ገጽታ ቀይር (Dark Mode)'
                  : 'Switch to Dark Mode'
              }
              className="flex items-center justify-center w-8 h-8 rounded-xl border border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-700 dark:text-slate-200 transition-colors cursor-pointer shadow-2xs"
            >
              {isDark ? (
                <Sun size={15} className="text-amber-400 animate-in spin-in-180 duration-200" />
              ) : (
                <Moon size={15} className="text-slate-600 animate-in spin-in-180 duration-200" />
              )}
            </button>

            {/* Language Switcher */}
            <button
              onClick={onToggleLang}
              className="flex items-center gap-1.5 px-2.5 sm:px-3 py-1.5 rounded-xl border border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800 text-xs font-bold text-slate-700 dark:text-slate-200 transition-colors cursor-pointer"
            >
              <Globe size={14} className="text-slate-500 dark:text-slate-400" />
              <span className="hidden sm:inline">{lang === 'am' ? 'አማርኛ (AM)' : 'English (EN)'}</span>
              <span className="sm:hidden">{lang === 'am' ? 'AM' : 'EN'}</span>
            </button>

            {/* Quick Action Button */}
            {onQuickAction && (
              <button
                onClick={onQuickAction}
                className="flex items-center gap-1.5 px-2.5 sm:px-3.5 py-1.5 bg-brand-600 hover:bg-brand-700 text-white text-xs font-bold rounded-xl shadow-sm shadow-brand-600/20 transition-colors cursor-pointer"
              >
                <Plus size={16} />
                <span className="hidden sm:inline">{lang === 'am' ? 'አዲስ ክሊኒክ' : 'Add Facility'}</span>
              </button>
            )}
          </div>
        </header>

        {/* Scrollable Page Body with Responsive Padding */}
        <main className="flex-1 overflow-y-auto p-4 sm:p-6 md:p-8 bg-slate-50 dark:bg-slate-950 transition-colors duration-200">
          <div className="max-w-7xl mx-auto">{children}</div>
        </main>
      </div>
    </div>
  );
};
