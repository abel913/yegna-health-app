import React, { useState, useMemo, useEffect } from 'react';
import {
  Search,
  ChevronLeft,
  ChevronRight,
  ChevronDown,
  X,
  Key,
  Trash2,
  AlertTriangle,
  Check,
  Sparkles,
  MailCheck,
  Plus,
  Edit3,
  Copy,
  ShieldCheck,
  CheckSquare,
  Square,
  LayoutGrid,
  List as ListIcon,
  Table as TableIcon,
  Download,
  Users as UsersIcon,
  GraduationCap,
  HeartHandshake,
  ShieldAlert,
  AtSign,
  Shield,
  Activity,
  Calendar,
  KeyRound,
} from 'lucide-react';
import { ManagedUser } from '../types/index.js';
import { exportToCsv } from '../utils/csvExport.js';
import { EmptyState } from '../components/common/EmptyState.js';

interface UsersPageProps {
  users: ManagedUser[];
  lang: 'en' | 'am';
  onCreateUser?: (data: {
    email: string;
    displayName: string;
    password?: string;
    role?: string;
    isEmailVerified?: boolean;
  }) => Promise<void>;
  onUpdateRole: (id: string, role: string) => Promise<void>;
  onToggleSuspension: (id: string) => Promise<void>;
  onResetPassword?: (id: string, newPassword: string) => Promise<void>;
  onDeleteUser?: (id: string) => Promise<void>;
  onVerifyEmail?: (id: string) => Promise<void>;
}

// Generate pastel background colors based on user name/email hash
const AVATAR_COLORS = [
  'bg-emerald-100 text-emerald-700 dark:bg-emerald-950/60 dark:text-emerald-300',
  'bg-indigo-100 text-indigo-700 dark:bg-indigo-950/60 dark:text-indigo-300',
  'bg-amber-100 text-amber-700 dark:bg-amber-950/60 dark:text-amber-300',
  'bg-rose-100 text-rose-700 dark:bg-rose-950/60 dark:text-rose-300',
  'bg-cyan-100 text-cyan-700 dark:bg-cyan-950/60 dark:text-cyan-300',
  'bg-purple-100 text-purple-700 dark:bg-purple-950/60 dark:text-purple-300',
  'bg-blue-100 text-blue-700 dark:bg-blue-950/60 dark:text-blue-300',
];

function getAvatarColor(str: string): string {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = (hash << 5) - hash + str.charCodeAt(i);
    hash |= 0;
  }
  return AVATAR_COLORS[Math.abs(hash) % AVATAR_COLORS.length];
}

function formatDate(isoString?: string): string {
  if (!isoString) return 'Just now';
  try {
    const d = new Date(isoString);
    return d.toLocaleDateString('en-GB', {
      day: '2-digit',
      month: 'short',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      hour12: true,
    });
  } catch {
    return isoString;
  }
}

export const UsersPage: React.FC<UsersPageProps> = ({
  users,
  lang,
  onCreateUser,
  onUpdateRole,
  onToggleSuspension,
  onResetPassword,
  onDeleteUser,
  onVerifyEmail,
}) => {
  // View mode switcher: Table | Board | List
  const [viewMode, setViewMode] = useState<'table' | 'board' | 'list'>('table');

  // Search and filter state
  const [search, setSearch] = useState('');
  const [roleFilter, setRoleFilter] = useState('ALL');
  const [statusFilter, setStatusFilter] = useState<'ALL' | 'ACTIVE' | 'SUSPENDED'>('ALL');
  const [emailVerifiedFilter, setEmailVerifiedFilter] = useState<'ALL' | 'VERIFIED' | 'PENDING'>('ALL');

  // Filter dropdown toggles
  const [activeDropdown, setActiveDropdown] = useState<string | null>(null);

  // Pagination state
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(15);

  // Selection state
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());

  // Toast notification state (in top right like screenshot)
  const [toastMessage, setToastMessage] = useState<{
    title: string;
    description: string;
    id?: string;
  } | null>(null);

  // Modals state
  const [isAddUserModalOpen, setIsAddUserModalOpen] = useState(false);
  const [newUserData, setNewUserData] = useState({
    displayName: '',
    email: '',
    role: 'STUDENT',
    password: '',
    isEmailVerified: true,
  });
  const [isSubmittingNewUser, setIsSubmittingNewUser] = useState(false);

  const [editingUser, setEditingUser] = useState<ManagedUser | null>(null);

  const [resettingUser, setResettingUser] = useState<ManagedUser | null>(null);
  const [newPassword, setNewPassword] = useState('');
  const [isSubmittingPassword, setIsSubmittingPassword] = useState(false);

  const [deletingUser, setDeletingUser] = useState<ManagedUser | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);

  // Quick keyboard shortcut '/' to focus search
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === '/' && document.activeElement?.tagName !== 'INPUT') {
        e.preventDefault();
        document.getElementById('user-table-search-input')?.focus();
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

  // Filter logic
  const filteredUsers = useMemo(() => {
    return users.filter((u) => {
      const q = search.toLowerCase();
      const matchesSearch =
        u.email.toLowerCase().includes(q) ||
        (u.displayName && u.displayName.toLowerCase().includes(q));

      const matchesRole =
        roleFilter === 'ALL' ||
        u.role === roleFilter ||
        (roleFilter === 'ADMINS' && (u.role === 'ADMIN' || u.role === 'SUPER_ADMIN'));

      const matchesStatus =
        statusFilter === 'ALL' ||
        (statusFilter === 'ACTIVE' && !u.isSuspended) ||
        (statusFilter === 'SUSPENDED' && u.isSuspended);

      const matchesVerification =
        emailVerifiedFilter === 'ALL' ||
        (emailVerifiedFilter === 'VERIFIED' && u.isEmailVerified) ||
        (emailVerifiedFilter === 'PENDING' && !u.isEmailVerified);

      return matchesSearch && matchesRole && matchesStatus && matchesVerification;
    });
  }, [users, search, roleFilter, statusFilter, emailVerifiedFilter]);

  // Pagination logic
  const totalPages = Math.ceil(filteredUsers.length / pageSize) || 1;
  const paginatedUsers = useMemo(() => {
    const start = (currentPage - 1) * pageSize;
    return filteredUsers.slice(start, start + pageSize);
  }, [filteredUsers, currentPage, pageSize]);

  // Selection handlers
  const isAllSelected =
    paginatedUsers.length > 0 && paginatedUsers.every((u) => selectedIds.has(u.id));

  const toggleSelectAll = () => {
    if (isAllSelected) {
      setSelectedIds(new Set());
    } else {
      const newSet = new Set(selectedIds);
      paginatedUsers.forEach((u) => newSet.add(u.id));
      setSelectedIds(newSet);
    }
  };

  const toggleSelectOne = (id: string) => {
    const newSet = new Set(selectedIds);
    if (newSet.has(id)) {
      newSet.delete(id);
    } else {
      newSet.add(id);
    }
    setSelectedIds(newSet);
  };

  // CSV Export
  const handleExportCsv = () => {
    exportToCsv(
      'Yegna_Users_Directory',
      [
        { header: 'ID', accessor: (u) => u.id },
        { header: 'Full Name', accessor: (u) => u.displayName || 'Anonymous Student' },
        { header: 'Email Address', accessor: (u) => u.email },
        { header: 'Role', accessor: (u) => u.role },
        { header: 'Status', accessor: (u) => (u.isSuspended ? 'Inactive / Suspended' : 'Active') },
        { header: 'Email Verified', accessor: (u) => (u.isEmailVerified ? 'Yes' : 'Pending') },
        { header: 'Joined Clubs', accessor: (u) => u.joinedClubCount || 0 },
        {
          header: 'Joined Date',
          accessor: (u) => formatDate(u.createdAt),
        },
      ],
      filteredUsers
    );
    showToast('Export Completed', `Successfully exported ${filteredUsers.length} user records to CSV.`);
  };

  const showToast = (title: string, description: string) => {
    setToastMessage({ title, description });
    setTimeout(() => {
      setToastMessage((prev) => (prev?.title === title ? null : prev));
    }, 4500);
  };

  // Copy email to clipboard
  const handleCopyEmail = (email: string) => {
    navigator.clipboard.writeText(email);
    showToast('Email Copied', `"${email}" has been copied to your clipboard.`);
  };

  // Password generator
  const generateRandomPassword = () => {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789!@#$%';
    let pass = '';
    for (let i = 0; i < 10; i++) {
      pass += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return pass;
  };

  // Handle Add User Submit
  const handleAddUserSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!onCreateUser) return;
    setIsSubmittingNewUser(true);
    try {
      await onCreateUser(newUserData);
      showToast(
        `"${newUserData.displayName || newUserData.email}" created`,
        'User account created successfully.'
      );
      setIsAddUserModalOpen(false);
      setNewUserData({
        displayName: '',
        email: '',
        role: 'STUDENT',
        password: '',
        isEmailVerified: true,
      });
    } catch {
      // Handled in parent toast
    } finally {
      setIsSubmittingNewUser(false);
    }
  };

  // Confirm Reset Password
  const handleConfirmResetPassword = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!resettingUser || !onResetPassword || newPassword.length < 6) return;
    setIsSubmittingPassword(true);
    try {
      await onResetPassword(resettingUser.id, newPassword);
      showToast(
        `"${resettingUser.displayName || resettingUser.email}" password updated`,
        'New credentials have been securely hashed and saved.'
      );
      setResettingUser(null);
      setNewPassword('');
    } finally {
      setIsSubmittingPassword(false);
    }
  };

  // Confirm Delete User
  const handleConfirmDelete = async () => {
    if (!deletingUser || !onDeleteUser) return;
    setIsDeleting(true);
    try {
      await onDeleteUser(deletingUser.id);
      showToast(
        `"${deletingUser.displayName || deletingUser.email}" removed`,
        'User account has been permanently deleted.'
      );
      setDeletingUser(null);
    } finally {
      setIsDeleting(false);
    }
  };

  const hasActiveFilters =
    roleFilter !== 'ALL' || statusFilter !== 'ALL' || emailVerifiedFilter !== 'ALL' || search !== '';

  const handleResetAllFilters = () => {
    setSearch('');
    setRoleFilter('ALL');
    setStatusFilter('ALL');
    setEmailVerifiedFilter('ALL');
    setCurrentPage(1);
  };

  return (
    <div className="space-y-4">
      {/* ========================================================= */}
      {/* 1. FLOATING TOAST (Matches Reference Screenshot Top Right) */}
      {/* ========================================================= */}
      {toastMessage && (
        <div className="fixed top-20 right-6 z-50 max-w-sm w-full bg-slate-900 text-white rounded-xl p-3.5 shadow-xl border border-slate-800 flex items-start justify-between gap-3 animate-in fade-in slide-in-from-top-2 duration-200">
          <div className="flex items-start gap-2.5">
            <div className="w-5 h-5 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center shrink-0 mt-0.5">
              <Check size={12} strokeWidth={3} />
            </div>
            <div>
              <p className="text-xs font-semibold text-white">{toastMessage.title}</p>
              <p className="text-[11px] text-slate-400 mt-0.5">{toastMessage.description}</p>
            </div>
          </div>
          <button
            onClick={() => setToastMessage(null)}
            className="text-slate-400 hover:text-white transition-colors"
          >
            <X size={14} />
          </button>
        </div>
      )}

      {/* ========================================================= */}
      {/* 2. BREADCRUMBS & PAGE HEADER                              */}
      {/* ========================================================= */}
      <div className="space-y-1">
        <div className="flex items-center gap-2 text-xs text-slate-400 dark:text-slate-500 font-medium">
          <span className="hover:text-slate-600 dark:hover:text-slate-400 cursor-pointer">
            {lang === 'am' ? 'የኛ ፕላትፎርም' : 'Yegna Platform'}
          </span>
          <span>/</span>
          <span className="flex items-center gap-1.5 text-slate-700 dark:text-slate-300 font-semibold">
            <UsersIcon size={13} className="text-slate-500" />
            {lang === 'am' ? 'የተጠቃሚዎች አስተዳደር' : 'User management'}
          </span>
        </div>

        <div className="flex items-center gap-2.5 pt-1">
          <h1 className="text-2xl font-bold tracking-tight text-slate-900 dark:text-white">
            {lang === 'am' ? 'የተጠቃሚዎች አስተዳደር' : 'User management'}
          </h1>
          <span className="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-semibold bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 border border-slate-200/80 dark:border-slate-700">
            {users.length}
          </span>
        </div>

        <p className="text-xs text-slate-500 dark:text-slate-400">
          {lang === 'am'
            ? 'የቡድን አባላትን፣ አማካሪዎችን፣ ተማሪዎችን እና የመለያ ፈቃዶችን እዚህ ያስተዳድሩ።'
            : 'Manage your team members and their account permissions here.'}
        </p>
      </div>

      {/* ========================================================= */}
      {/* 3. TOOLBAR: VIEW TABS, SEARCH & ACTION BUTTONS            */}
      {/* ========================================================= */}
      <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-3 pt-2">
        {/* Left: View Tabs (Table | Board | List) */}
        <div className="inline-flex items-center p-1 bg-slate-100/90 dark:bg-slate-800/80 rounded-xl border border-slate-200/80 dark:border-slate-700 self-start">
          <button
            type="button"
            onClick={() => setViewMode('table')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all cursor-pointer ${
              viewMode === 'table'
                ? 'bg-white dark:bg-slate-900 text-slate-900 dark:text-white shadow-2xs'
                : 'text-slate-500 hover:text-slate-800 dark:text-slate-400 dark:hover:text-slate-200'
            }`}
          >
            <TableIcon size={14} />
            <span>Table</span>
          </button>
          <button
            type="button"
            onClick={() => setViewMode('board')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all cursor-pointer ${
              viewMode === 'board'
                ? 'bg-white dark:bg-slate-900 text-slate-900 dark:text-white shadow-2xs'
                : 'text-slate-500 hover:text-slate-800 dark:text-slate-400 dark:hover:text-slate-200'
            }`}
          >
            <LayoutGrid size={14} />
            <span>Board</span>
          </button>
          <button
            type="button"
            onClick={() => setViewMode('list')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all cursor-pointer ${
              viewMode === 'list'
                ? 'bg-white dark:bg-slate-900 text-slate-900 dark:text-white shadow-2xs'
                : 'text-slate-500 hover:text-slate-800 dark:text-slate-400 dark:hover:text-slate-200'
            }`}
          >
            <ListIcon size={14} />
            <span>List</span>
          </button>
        </div>

        {/* Right: Search, Export & Add User Buttons */}
        <div className="flex flex-wrap items-center gap-2">
          {/* Quick Search with "/" shortcut */}
          <div className="relative">
            <Search
              size={13}
              className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none"
            />
            <input
              id="user-table-search-input"
              type="text"
              placeholder={lang === 'am' ? 'ፈልግ...' : 'Search'}
              value={search}
              onChange={(e) => {
                setSearch(e.target.value);
                setCurrentPage(1);
              }}
              className="pl-8 pr-7 py-1.5 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl text-xs text-slate-900 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-1 focus:ring-slate-400 dark:focus:ring-slate-600 transition-all w-36 sm:w-48 shadow-2xs"
            />
            {!search ? (
              <kbd className="absolute right-2.5 top-1/2 -translate-y-1/2 text-[10px] text-slate-400 font-mono bg-slate-100 dark:bg-slate-800 px-1 py-0.2 rounded border border-slate-200 dark:border-slate-700 pointer-events-none">
                /
              </kbd>
            ) : (
              <button
                onClick={() => setSearch('')}
                className="absolute right-2 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200"
              >
                <X size={12} />
              </button>
            )}
          </div>

          {/* Export CSV Button */}
          <button
            type="button"
            onClick={handleExportCsv}
            className="flex items-center gap-1.5 px-3 py-1.5 bg-white dark:bg-slate-900 hover:bg-slate-50 dark:hover:bg-slate-800 border border-slate-200 dark:border-slate-800 rounded-xl text-xs font-semibold text-slate-700 dark:text-slate-200 transition-all cursor-pointer shadow-2xs"
          >
            <Download size={13} className="text-slate-500" />
            <span>Export</span>
          </button>

          {/* Add User Primary Button */}
          <button
            type="button"
            onClick={() => setIsAddUserModalOpen(true)}
            className="flex items-center gap-1.5 px-3.5 py-1.5 bg-slate-900 hover:bg-slate-800 dark:bg-brand-600 dark:hover:bg-brand-700 text-white rounded-xl text-xs font-semibold transition-all cursor-pointer shadow-2xs"
          >
            <Plus size={14} />
            <span>{lang === 'am' ? 'አዲስ ተጠቃሚ' : 'Add User'}</span>
            <ChevronDown size={12} className="opacity-70 ml-0.5" />
          </button>
        </div>
      </div>

      {/* ========================================================= */}
      {/* 4. FILTER PILLS STRIP (Under toolbar like screenshot)      */}
      {/* ========================================================= */}
      <div className="flex flex-wrap items-center gap-2 pt-1 pb-1">
        {/* Role Filter Pill */}
        <div className="relative">
          <button
            type="button"
            onClick={() => setActiveDropdown(activeDropdown === 'role' ? null : 'role')}
            className={`flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-medium border transition-colors cursor-pointer ${
              roleFilter !== 'ALL'
                ? 'bg-slate-900 text-white border-slate-900 dark:bg-slate-100 dark:text-slate-900'
                : 'bg-white dark:bg-slate-900 text-slate-700 dark:text-slate-300 border-slate-200 dark:border-slate-800 hover:bg-slate-50'
            }`}
          >
            <span>Role: {roleFilter === 'ALL' ? 'All' : roleFilter}</span>
            <ChevronDown size={12} className="opacity-60" />
          </button>

          {activeDropdown === 'role' && (
            <div className="absolute left-0 mt-1.5 z-30 w-48 bg-white dark:bg-slate-900 rounded-xl shadow-lg border border-slate-200 dark:border-slate-800 py-1 text-xs animate-in fade-in duration-150">
              {[
                { val: 'ALL', label: 'All Roles' },
                { val: 'STUDENT', label: 'Student Only' },
                { val: 'MENTOR', label: 'Peer Mentor' },
                { val: 'CONTENT_AUTHOR', label: 'Content Author' },
                { val: 'ADMIN', label: 'Health Admin' },
                { val: 'SUPER_ADMIN', label: 'Super Admin' },
              ].map((opt) => (
                <button
                  key={opt.val}
                  type="button"
                  onClick={() => {
                    setRoleFilter(opt.val);
                    setActiveDropdown(null);
                    setCurrentPage(1);
                  }}
                  className={`w-full text-left px-3 py-1.5 flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-800 ${
                    roleFilter === opt.val ? 'font-bold text-slate-900 dark:text-white' : 'text-slate-600 dark:text-slate-400'
                  }`}
                >
                  <span>{opt.label}</span>
                  {roleFilter === opt.val && <Check size={13} className="text-emerald-500" />}
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Status Filter Pill */}
        <div className="relative">
          <button
            type="button"
            onClick={() => setActiveDropdown(activeDropdown === 'status' ? null : 'status')}
            className={`flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-medium border transition-colors cursor-pointer ${
              statusFilter !== 'ALL'
                ? 'bg-slate-900 text-white border-slate-900 dark:bg-slate-100 dark:text-slate-900'
                : 'bg-white dark:bg-slate-900 text-slate-700 dark:text-slate-300 border-slate-200 dark:border-slate-800 hover:bg-slate-50'
            }`}
          >
            <span>Status: {statusFilter === 'ALL' ? 'All' : statusFilter}</span>
            <ChevronDown size={12} className="opacity-60" />
          </button>

          {activeDropdown === 'status' && (
            <div className="absolute left-0 mt-1.5 z-30 w-44 bg-white dark:bg-slate-900 rounded-xl shadow-lg border border-slate-200 dark:border-slate-800 py-1 text-xs animate-in fade-in duration-150">
              {[
                { val: 'ALL', label: 'All Statuses' },
                { val: 'ACTIVE', label: 'Active Only' },
                { val: 'SUSPENDED', label: 'Suspended Only' },
              ].map((opt) => (
                <button
                  key={opt.val}
                  type="button"
                  onClick={() => {
                    setStatusFilter(opt.val as any);
                    setActiveDropdown(null);
                    setCurrentPage(1);
                  }}
                  className={`w-full text-left px-3 py-1.5 flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-800 ${
                    statusFilter === opt.val ? 'font-bold text-slate-900 dark:text-white' : 'text-slate-600 dark:text-slate-400'
                  }`}
                >
                  <span>{opt.label}</span>
                  {statusFilter === opt.val && <Check size={13} className="text-emerald-500" />}
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Email Verified Filter Pill */}
        <div className="relative">
          <button
            type="button"
            onClick={() => setActiveDropdown(activeDropdown === 'verified' ? null : 'verified')}
            className={`flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-medium border transition-colors cursor-pointer ${
              emailVerifiedFilter !== 'ALL'
                ? 'bg-slate-900 text-white border-slate-900 dark:bg-slate-100 dark:text-slate-900'
                : 'bg-white dark:bg-slate-900 text-slate-700 dark:text-slate-300 border-slate-200 dark:border-slate-800 hover:bg-slate-50'
            }`}
          >
            <span>2F / Email: {emailVerifiedFilter === 'ALL' ? 'All' : emailVerifiedFilter}</span>
            <ChevronDown size={12} className="opacity-60" />
          </button>

          {activeDropdown === 'verified' && (
            <div className="absolute left-0 mt-1.5 z-30 w-44 bg-white dark:bg-slate-900 rounded-xl shadow-lg border border-slate-200 dark:border-slate-800 py-1 text-xs animate-in fade-in duration-150">
              {[
                { val: 'ALL', label: 'All Users' },
                { val: 'VERIFIED', label: 'Verified Only' },
                { val: 'PENDING', label: 'Pending Email' },
              ].map((opt) => (
                <button
                  key={opt.val}
                  type="button"
                  onClick={() => {
                    setEmailVerifiedFilter(opt.val as any);
                    setActiveDropdown(null);
                    setCurrentPage(1);
                  }}
                  className={`w-full text-left px-3 py-1.5 flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-800 ${
                    emailVerifiedFilter === opt.val ? 'font-bold text-slate-900 dark:text-white' : 'text-slate-600 dark:text-slate-400'
                  }`}
                >
                  <span>{opt.label}</span>
                  {emailVerifiedFilter === opt.val && <Check size={13} className="text-emerald-500" />}
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Clear Filters Reset Pill */}
        {hasActiveFilters && (
          <button
            type="button"
            onClick={handleResetAllFilters}
            className="flex items-center gap-1 px-2.5 py-1 rounded-lg text-xs font-semibold text-rose-600 dark:text-rose-400 hover:bg-rose-50 dark:hover:bg-rose-950/40 transition-colors cursor-pointer"
          >
            <X size={12} />
            <span>Reset filters</span>
          </button>
        )}
      </div>

      {/* ========================================================= */}
      {/* 5. MAIN CONTENT DISPLAY (Table / Board / List)            */}
      {/* ========================================================= */}

      {/* A. TABLE VIEW */}
      {viewMode === 'table' && (
        <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-2xs overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-slate-200 dark:border-slate-800 bg-slate-50/70 dark:bg-slate-950/40 text-[11px] font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
                  <th className="py-3 px-4 w-10">
                    <button
                      type="button"
                      onClick={toggleSelectAll}
                      className="text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 cursor-pointer"
                    >
                      {isAllSelected ? (
                        <CheckSquare size={16} className="text-brand-600" />
                      ) : (
                        <Square size={16} />
                      )}
                    </button>
                  </th>
                  <th className="py-3 px-4">Full name</th>
                  <th className="py-3 px-4">
                    <span className="inline-flex items-center gap-1.5">
                      <AtSign size={12} className="text-slate-400" />
                      <span>Email address</span>
                    </span>
                  </th>
                  <th className="py-3 px-4">
                    <span className="inline-flex items-center gap-1.5">
                      <Shield size={12} className="text-slate-400" />
                      <span>Role</span>
                    </span>
                  </th>
                  <th className="py-3 px-4">
                    <span className="inline-flex items-center gap-1.5">
                      <Activity size={12} className="text-slate-400" />
                      <span>Status</span>
                    </span>
                  </th>
                  <th className="py-3 px-4">
                    <span className="inline-flex items-center gap-1.5">
                      <Calendar size={12} className="text-slate-400" />
                      <span>Joined date</span>
                    </span>
                  </th>
                  <th className="py-3 px-4">
                    <span className="inline-flex items-center gap-1.5">
                      <KeyRound size={12} className="text-slate-400" />
                      <span>2F Auth</span>
                    </span>
                  </th>
                  <th className="py-3 px-4 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-800/80 text-xs">
                {paginatedUsers.map((u) => {
                  const isSelected = selectedIds.has(u.id);
                  const isSuper = u.role === 'SUPER_ADMIN' || u.email === 'admin@yegnahealth.org';
                  const initials = u.displayName
                    ? u.displayName.slice(0, 2).toUpperCase()
                    : u.email.slice(0, 2).toUpperCase();
                  const avatarColorClass = getAvatarColor(u.email);

                  return (
                    <tr
                      key={u.id}
                      className={`hover:bg-slate-50/80 dark:hover:bg-slate-800/40 transition-colors ${
                        isSelected ? 'bg-sky-50/40 dark:bg-sky-950/20' : ''
                      } ${u.isSuspended ? 'bg-rose-50/10 dark:bg-rose-950/10' : ''}`}
                    >
                      {/* Checkbox */}
                      <td className="py-3 px-4">
                        <button
                          type="button"
                          onClick={() => toggleSelectOne(u.id)}
                          className="text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 cursor-pointer"
                        >
                          {isSelected ? (
                            <CheckSquare size={16} className="text-brand-600" />
                          ) : (
                            <Square size={16} />
                          )}
                        </button>
                      </td>

                      {/* Full Name & Avatar */}
                      <td className="py-3 px-4">
                        <div className="flex items-center gap-2.5">
                          <div
                            className={`w-7 h-7 rounded-full flex items-center justify-center font-bold text-[10px] shrink-0 ${avatarColorClass}`}
                          >
                            {initials}
                          </div>
                          <div className="min-w-0">
                            <span className="font-semibold text-slate-900 dark:text-white truncate block">
                              {u.displayName || 'Anonymous Student'}
                            </span>
                          </div>
                        </div>
                      </td>

                      {/* Email Address with Click to Copy */}
                      <td className="py-3 px-4">
                        <div
                          onClick={() => handleCopyEmail(u.email)}
                          title="Click to copy email address"
                          className="group inline-flex items-center gap-1.5 text-slate-500 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white transition-colors cursor-pointer"
                        >
                          <span className="font-mono text-[11px] truncate max-w-[190px]">
                            {u.email}
                          </span>
                          <Copy
                            size={11}
                            className="opacity-0 group-hover:opacity-100 transition-opacity text-slate-400"
                          />
                        </div>
                      </td>

                      {/* Role */}
                      <td className="py-3 px-4">
                        <span className="text-slate-700 dark:text-slate-300 font-medium">
                          {u.role === 'SUPER_ADMIN'
                            ? 'Super Admin'
                            : u.role === 'ADMIN'
                            ? 'Health Admin'
                            : u.role === 'MENTOR'
                            ? 'Peer Mentor'
                            : u.role === 'CONTENT_AUTHOR'
                            ? 'Content Author'
                            : 'Student'}
                        </span>
                      </td>

                      {/* Status Dot (Bullet dot matching screenshot) */}
                      <td className="py-3 px-4">
                        {u.isSuspended ? (
                          <div className="inline-flex items-center gap-1.5 text-xs font-medium text-slate-600 dark:text-slate-400">
                            <span className="w-1.5 h-1.5 rounded-full bg-rose-500" />
                            <span>Suspended</span>
                          </div>
                        ) : (
                          <div className="inline-flex items-center gap-1.5 text-xs font-medium text-slate-600 dark:text-slate-400">
                            <span className="w-1.5 h-1.5 rounded-full bg-emerald-500" />
                            <span>Active</span>
                          </div>
                        )}
                      </td>

                      {/* Joined Date */}
                      <td className="py-3 px-4 text-slate-500 dark:text-slate-400">
                        {formatDate(u.createdAt)}
                      </td>

                      {/* 2F Auth / Email Verified Badge (Amber pill like screenshot) */}
                      <td className="py-3 px-4">
                        {u.isEmailVerified ? (
                          <span className="inline-flex items-center px-2 py-0.5 rounded text-[11px] font-semibold bg-amber-50 dark:bg-amber-950/40 text-amber-800 dark:text-amber-300 border border-amber-200/80 dark:border-amber-800/80">
                            Enabled
                          </span>
                        ) : (
                          <span className="inline-flex items-center px-2 py-0.5 rounded text-[11px] font-semibold bg-slate-100 dark:bg-slate-800 text-slate-500 dark:text-slate-400">
                            Pending
                          </span>
                        )}
                      </td>

                      {/* Actions (Ghost outline buttons matching screenshot) */}
                      <td className="py-3 px-4 text-right">
                        <div className="inline-flex items-center gap-1.5 justify-end">
                          <button
                            type="button"
                            onClick={() => setEditingUser(u)}
                            className="inline-flex items-center gap-1 px-2.5 py-1 rounded-lg border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 hover:bg-slate-50 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs font-medium transition-colors cursor-pointer shadow-2xs"
                          >
                            <Edit3 size={12} className="text-slate-400" />
                            <span>Edit</span>
                          </button>

                          <button
                            type="button"
                            disabled={isSuper}
                            onClick={() => setDeletingUser(u)}
                            className={`inline-flex items-center gap-1 px-2.5 py-1 rounded-lg border transition-colors cursor-pointer shadow-2xs text-xs font-medium ${
                              isSuper
                                ? 'opacity-30 cursor-not-allowed border-slate-200 text-slate-400'
                                : 'border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 hover:bg-rose-50 dark:hover:bg-rose-950/40 hover:text-rose-600 text-slate-700 dark:text-slate-200'
                            }`}
                          >
                            <Trash2 size={12} className="text-slate-400" />
                            <span>Delete</span>
                          </button>
                        </div>
                      </td>
                    </tr>
                  );
                })}

                {filteredUsers.length === 0 && (
                  <EmptyState
                    colSpan={8}
                    icon={UsersIcon}
                    title={lang === 'am' ? 'ምንም ተጠቃሚ አልተገኘም' : 'No users found'}
                    description={
                      lang === 'am'
                        ? 'የተመረጠውን ፍለጋ ወይም የሚና ማጣሪያ በማስተካከል እንደገና ይሞክሩ።'
                        : 'No team members or students match your selected filters. Try adjusting your search query or reset filters.'
                    }
                    clearLabel={hasActiveFilters ? 'Reset filters' : undefined}
                    onClear={hasActiveFilters ? handleResetAllFilters : undefined}
                  />
                )}
              </tbody>
            </table>
          </div>

          {/* ========================================================= */}
          {/* 6. BOTTOM MODERN PAGINATION BAR (Matching Screenshot)     */}
          {/* ========================================================= */}
          {filteredUsers.length > 0 && (
            <div className="px-4 py-3 border-t border-slate-200 dark:border-slate-800 bg-slate-50/50 dark:bg-slate-900/50 flex flex-col sm:flex-row sm:items-center justify-between gap-3 text-xs text-slate-500 dark:text-slate-400">
              {/* Rows Per Page Selector & Counter */}
              <div className="flex items-center gap-3">
                <div className="flex items-center gap-1.5">
                  <span>Rows per page</span>
                  <select
                    value={pageSize}
                    onChange={(e) => {
                      setPageSize(Number(e.target.value));
                      setCurrentPage(1);
                    }}
                    className="bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg px-2 py-1 text-xs font-semibold text-slate-700 dark:text-slate-200 focus:outline-none cursor-pointer"
                  >
                    <option value={10}>10</option>
                    <option value={15}>15</option>
                    <option value={25}>25</option>
                    <option value={50}>50</option>
                  </select>
                </div>

                <span>
                  {Math.min((currentPage - 1) * pageSize + 1, filteredUsers.length)}-
                  {Math.min(currentPage * pageSize, filteredUsers.length)} of {filteredUsers.length} rows
                </span>
              </div>

              {/* Numbered Pagination Buttons */}
              <div className="flex items-center gap-1 self-center sm:self-auto">
                <button
                  type="button"
                  onClick={() => setCurrentPage(1)}
                  disabled={currentPage === 1}
                  className="px-2 py-1 rounded-md hover:bg-slate-200 dark:hover:bg-slate-800 disabled:opacity-30 disabled:cursor-not-allowed transition-colors text-xs"
                >
                  «
                </button>
                <button
                  type="button"
                  onClick={() => setCurrentPage((p) => Math.max(p - 1, 1))}
                  disabled={currentPage === 1}
                  className="p-1 rounded-md hover:bg-slate-200 dark:hover:bg-slate-800 disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
                >
                  <ChevronLeft size={14} />
                </button>

                {/* Page numbers */}
                {Array.from({ length: Math.min(totalPages, 5) }, (_, i) => {
                  const pNum = i + 1;
                  const isActive = currentPage === pNum;
                  return (
                    <button
                      key={pNum}
                      type="button"
                      onClick={() => setCurrentPage(pNum)}
                      className={`w-7 h-7 rounded-lg text-xs font-semibold flex items-center justify-center transition-all cursor-pointer ${
                        isActive
                          ? 'bg-slate-900 text-white dark:bg-white dark:text-slate-900 shadow-2xs'
                          : 'text-slate-600 dark:text-slate-400 hover:bg-slate-200 dark:hover:bg-slate-800'
                      }`}
                    >
                      {pNum}
                    </button>
                  );
                })}

                {totalPages > 5 && (
                  <>
                    <span className="px-1 text-slate-400">...</span>
                    <button
                      type="button"
                      onClick={() => setCurrentPage(totalPages)}
                      className={`w-7 h-7 rounded-lg text-xs font-semibold flex items-center justify-center transition-all cursor-pointer ${
                        currentPage === totalPages
                          ? 'bg-slate-900 text-white dark:bg-white dark:text-slate-900 shadow-2xs'
                          : 'text-slate-600 dark:text-slate-400 hover:bg-slate-200 dark:hover:bg-slate-800'
                      }`}
                    >
                      {totalPages}
                    </button>
                  </>
                )}

                <button
                  type="button"
                  onClick={() => setCurrentPage((p) => Math.min(p + 1, totalPages))}
                  disabled={currentPage === totalPages}
                  className="p-1 rounded-md hover:bg-slate-200 dark:hover:bg-slate-800 disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
                >
                  <ChevronRight size={14} />
                </button>
                <button
                  type="button"
                  onClick={() => setCurrentPage(totalPages)}
                  disabled={currentPage === totalPages}
                  className="px-2 py-1 rounded-md hover:bg-slate-200 dark:hover:bg-slate-800 disabled:opacity-30 disabled:cursor-not-allowed transition-colors text-xs"
                >
                  »
                </button>
              </div>
            </div>
          )}
        </div>
      )}

      {/* B. BOARD / KANBAN VIEW */}
      {viewMode === 'board' && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          {[
            { key: 'STUDENT', title: 'Students', icon: GraduationCap, color: 'border-sky-300 dark:border-sky-800' },
            { key: 'MENTOR', title: 'Peer Mentors', icon: HeartHandshake, color: 'border-indigo-300 dark:border-indigo-800' },
            { key: 'CONTENT_AUTHOR', title: 'Content Authors', icon: Edit3, color: 'border-amber-300 dark:border-amber-800' },
            { key: 'ADMIN', title: 'Admins & Governance', icon: ShieldAlert, color: 'border-purple-300 dark:border-purple-800' },
          ].map((col) => {
            const colUsers = filteredUsers.filter((u) => {
              if (col.key === 'ADMIN') return u.role === 'ADMIN' || u.role === 'SUPER_ADMIN';
              return u.role === col.key;
            });
            const Icon = col.icon;

            return (
              <div
                key={col.key}
                className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-4 space-y-3 flex flex-col"
              >
                <div className="flex items-center justify-between pb-2 border-b border-slate-100 dark:border-slate-800">
                  <div className="flex items-center gap-2">
                    <Icon size={16} className="text-slate-500" />
                    <h3 className="font-bold text-xs text-slate-900 dark:text-white uppercase tracking-wider">
                      {col.title}
                    </h3>
                  </div>
                  <span className="text-xs font-semibold px-2 py-0.5 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400">
                    {colUsers.length}
                  </span>
                </div>

                <div className="space-y-2 flex-1 overflow-y-auto max-h-[600px] pr-1">
                  {colUsers.map((u) => (
                    <div
                      key={u.id}
                      className="p-3 rounded-xl bg-slate-50 dark:bg-slate-800/60 border border-slate-200/80 dark:border-slate-700/80 hover:shadow-xs transition-shadow space-y-2"
                    >
                      <div className="flex items-center justify-between gap-2">
                        <div className="flex items-center gap-2 min-w-0">
                          <div
                            className={`w-6 h-6 rounded-full flex items-center justify-center font-bold text-[9px] shrink-0 ${getAvatarColor(
                              u.email
                            )}`}
                          >
                            {u.displayName ? u.displayName.slice(0, 2).toUpperCase() : u.email.slice(0, 2).toUpperCase()}
                          </div>
                          <span className="font-semibold text-xs text-slate-900 dark:text-white truncate">
                            {u.displayName || 'Anonymous Student'}
                          </span>
                        </div>
                        <span
                          className={`w-2 h-2 rounded-full ${u.isSuspended ? 'bg-rose-500' : 'bg-emerald-500'}`}
                          title={u.isSuspended ? 'Suspended' : 'Active'}
                        />
                      </div>

                      <p className="text-[11px] font-mono text-slate-500 dark:text-slate-400 truncate">
                        {u.email}
                      </p>

                      <div className="flex items-center justify-between pt-1 text-[10px] text-slate-400 border-t border-slate-200/40 dark:border-slate-700/40">
                        <span>{u.joinedClubCount || 0} clubs</span>
                        <div className="flex items-center gap-1">
                          <button
                            type="button"
                            onClick={() => setEditingUser(u)}
                            className="p-1 text-slate-400 hover:text-slate-800 dark:hover:text-slate-200 cursor-pointer"
                          >
                            <Edit3 size={12} />
                          </button>
                          <button
                            type="button"
                            onClick={() => setDeletingUser(u)}
                            className="p-1 text-slate-400 hover:text-rose-600 cursor-pointer"
                          >
                            <Trash2 size={12} />
                          </button>
                        </div>
                      </div>
                    </div>
                  ))}

                  {colUsers.length === 0 && (
                    <div className="text-center py-8 text-xs text-slate-400">
                      No users in this role
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* C. LIST VIEW */}
      {viewMode === 'list' && (
        <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 divide-y divide-slate-100 dark:divide-slate-800 overflow-hidden shadow-2xs">
          {paginatedUsers.map((u) => (
            <div
              key={u.id}
              className="p-3.5 flex items-center justify-between gap-4 hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors"
            >
              <div className="flex items-center gap-3 min-w-0">
                <div
                  className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs shrink-0 ${getAvatarColor(
                    u.email
                  )}`}
                >
                  {u.displayName ? u.displayName.slice(0, 2).toUpperCase() : u.email.slice(0, 2).toUpperCase()}
                </div>
                <div className="min-w-0">
                  <div className="flex items-center gap-2">
                    <span className="font-semibold text-xs text-slate-900 dark:text-white truncate">
                      {u.displayName || 'Anonymous Student'}
                    </span>
                    <span className="text-[10px] px-1.5 py-0.2 rounded bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 font-medium">
                      {u.role}
                    </span>
                  </div>
                  <span className="text-xs text-slate-400 font-mono truncate block">{u.email}</span>
                </div>
              </div>

              <div className="flex items-center gap-3 shrink-0">
                <div className="hidden sm:flex items-center gap-1.5 text-xs text-slate-500">
                  <span className={`w-1.5 h-1.5 rounded-full ${u.isSuspended ? 'bg-rose-500' : 'bg-emerald-500'}`} />
                  <span>{u.isSuspended ? 'Suspended' : 'Active'}</span>
                </div>

                <button
                  type="button"
                  onClick={() => setEditingUser(u)}
                  className="px-2.5 py-1 text-xs font-semibold rounded-lg border border-slate-200 dark:border-slate-700 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors cursor-pointer"
                >
                  Edit
                </button>
              </div>
            </div>
          ))}

          {filteredUsers.length === 0 && (
            <div className="p-8 text-center text-xs text-slate-400">No users match your criteria</div>
          )}
        </div>
      )}

      {/* ========================================================= */}
      {/* 7. ZERO-KNOWLEDGE PRIVACY FOOTER NOTE                     */}
      {/* ========================================================= */}
      <div className="p-3 bg-slate-100/70 dark:bg-slate-900/40 rounded-xl border border-slate-200/60 dark:border-slate-800/60 flex items-center gap-2 text-xs text-slate-500 dark:text-slate-400">
        <ShieldCheck size={16} className="text-emerald-500 shrink-0" />
        <span>
          <strong>Zero-Knowledge Privacy:</strong> Individual student health assessment answers, AI counseling conversations, and quiz submissions are encrypted locally on device and are never queryable from administrative tables.
        </span>
      </div>

      {/* ========================================================= */}
      {/* 8. ADD USER MODAL                                         */}
      {/* ========================================================= */}
      {isAddUserModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-950/60 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-md w-full border border-slate-200 dark:border-slate-800 shadow-2xl overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <div className="p-5 border-b border-slate-100 dark:border-slate-800 flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <div className="w-9 h-9 rounded-xl bg-slate-900 text-white dark:bg-white dark:text-slate-900 flex items-center justify-center font-bold">
                  <Plus size={18} />
                </div>
                <div>
                  <h3 className="font-bold text-slate-900 dark:text-white text-sm">
                    {lang === 'am' ? 'አዲስ ተጠቃሚ ፍጠር' : 'Add New User'}
                  </h3>
                  <p className="text-xs text-slate-400">Register team member or administrative account</p>
                </div>
              </div>
              <button
                type="button"
                onClick={() => setIsAddUserModalOpen(false)}
                className="text-slate-400 hover:text-slate-600 dark:hover:text-slate-200"
              >
                <X size={18} />
              </button>
            </div>

            <form onSubmit={handleAddUserSubmit} className="p-5 space-y-3.5">
              <div>
                <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">
                  Full Name / Display Name
                </label>
                <input
                  type="text"
                  required
                  value={newUserData.displayName}
                  onChange={(e) => setNewUserData({ ...newUserData, displayName: e.target.value })}
                  placeholder="e.g. Dr. Selamawit Tadesse"
                  className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs dark:text-white focus:outline-none focus:ring-1 focus:ring-slate-400"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">
                  Email Address
                </label>
                <input
                  type="email"
                  required
                  value={newUserData.email}
                  onChange={(e) => setNewUserData({ ...newUserData, email: e.target.value })}
                  placeholder="e.g. selamawit@yegnahealth.org"
                  className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs dark:text-white focus:outline-none focus:ring-1 focus:ring-slate-400"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">
                  Platform Role
                </label>
                <select
                  value={newUserData.role}
                  onChange={(e) => setNewUserData({ ...newUserData, role: e.target.value })}
                  className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs dark:text-white focus:outline-none cursor-pointer"
                >
                  <option value="STUDENT">Student (ተማሪ)</option>
                  <option value="MENTOR">Peer Mentor (አማካሪ)</option>
                  <option value="CONTENT_AUTHOR">Content Author</option>
                  <option value="ADMIN">Health Admin (አስተዳዳሪ)</option>
                </select>
              </div>

              <div>
                <div className="flex items-center justify-between mb-1">
                  <label className="text-xs font-semibold text-slate-700 dark:text-slate-300">
                    Temporary Password
                  </label>
                  <button
                    type="button"
                    onClick={() =>
                      setNewUserData({ ...newUserData, password: generateRandomPassword() })
                    }
                    className="text-[11px] font-semibold text-brand-600 dark:text-cyan-400 hover:underline flex items-center gap-1 cursor-pointer"
                  >
                    <Sparkles size={11} />
                    Auto-generate
                  </button>
                </div>
                <input
                  type="text"
                  minLength={6}
                  value={newUserData.password}
                  onChange={(e) => setNewUserData({ ...newUserData, password: e.target.value })}
                  placeholder="Leave empty for auto-generated password"
                  className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs font-mono dark:text-white focus:outline-none focus:ring-1 focus:ring-slate-400"
                />
              </div>

              <div className="flex items-center gap-2 pt-1">
                <input
                  type="checkbox"
                  id="modal-verified-checkbox"
                  checked={newUserData.isEmailVerified}
                  onChange={(e) =>
                    setNewUserData({ ...newUserData, isEmailVerified: e.target.checked })
                  }
                  className="rounded border-slate-300 text-brand-600 focus:ring-brand-500 cursor-pointer"
                />
                <label
                  htmlFor="modal-verified-checkbox"
                  className="text-xs text-slate-600 dark:text-slate-300 cursor-pointer"
                >
                  Pre-verify email address (Allow immediate login)
                </label>
              </div>

              <div className="flex items-center justify-end gap-2.5 pt-3 border-t border-slate-100 dark:border-slate-800">
                <button
                  type="button"
                  onClick={() => setIsAddUserModalOpen(false)}
                  className="px-3.5 py-2 text-xs font-semibold text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition-colors cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={isSubmittingNewUser}
                  className="px-4 py-2 text-xs font-semibold text-white bg-slate-900 hover:bg-slate-800 dark:bg-brand-600 dark:hover:bg-brand-700 rounded-xl transition-colors cursor-pointer flex items-center gap-1.5 shadow-2xs"
                >
                  {isSubmittingNewUser ? 'Creating...' : 'Create Account'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* 9. EDIT USER / ROLE MODAL                                 */}
      {/* ========================================================= */}
      {editingUser && (
        <div className="fixed inset-0 z-50 bg-slate-950/60 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-md w-full border border-slate-200 dark:border-slate-800 shadow-2xl overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <div className="p-5 border-b border-slate-100 dark:border-slate-800 flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <div
                  className={`w-9 h-9 rounded-full flex items-center justify-center font-bold text-xs ${getAvatarColor(
                    editingUser.email
                  )}`}
                >
                  {editingUser.displayName
                    ? editingUser.displayName.slice(0, 2).toUpperCase()
                    : editingUser.email.slice(0, 2).toUpperCase()}
                </div>
                <div className="min-w-0">
                  <h3 className="font-bold text-slate-900 dark:text-white text-sm truncate">
                    {editingUser.displayName || 'Anonymous Student'}
                  </h3>
                  <p className="text-xs text-slate-400 truncate">{editingUser.email}</p>
                </div>
              </div>
              <button
                type="button"
                onClick={() => setEditingUser(null)}
                className="text-slate-400 hover:text-slate-600 dark:hover:text-slate-200"
              >
                <X size={18} />
              </button>
            </div>

            <div className="p-5 space-y-4">
              {/* Role Change */}
              <div>
                <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1.5">
                  Platform Role
                </label>
                <select
                  value={editingUser.role}
                  disabled={editingUser.role === 'SUPER_ADMIN'}
                  onChange={async (e) => {
                    await onUpdateRole(editingUser.id, e.target.value);
                    setEditingUser({ ...editingUser, role: e.target.value });
                    showToast('Role Updated', `User role changed to ${e.target.value}.`);
                  }}
                  className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs dark:text-white focus:outline-none cursor-pointer"
                >
                  <option value="STUDENT">Student</option>
                  <option value="MENTOR">Peer Mentor</option>
                  <option value="CONTENT_AUTHOR">Content Author</option>
                  <option value="ADMIN">Health Admin</option>
                  {editingUser.role === 'SUPER_ADMIN' && (
                    <option value="SUPER_ADMIN">Super Admin</option>
                  )}
                </select>
              </div>

              {/* Quick Actions Row in Edit Modal */}
              <div className="space-y-2 pt-2 border-t border-slate-100 dark:border-slate-800">
                <span className="text-xs font-semibold text-slate-400 uppercase tracking-wider block">
                  Quick Actions
                </span>

                <div className="grid grid-cols-2 gap-2">
                  {/* Verify Email Action */}
                  <button
                    type="button"
                    disabled={editingUser.isEmailVerified || !onVerifyEmail}
                    onClick={async () => {
                      if (onVerifyEmail) {
                        await onVerifyEmail(editingUser.id);
                        setEditingUser({ ...editingUser, isEmailVerified: true });
                        showToast('Email Verified', 'User email address verified.');
                      }
                    }}
                    className={`p-2.5 rounded-xl border text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors cursor-pointer ${
                      editingUser.isEmailVerified
                        ? 'bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 border-emerald-200 dark:border-emerald-800 cursor-default'
                        : 'bg-white dark:bg-slate-800 text-slate-700 dark:text-slate-300 border-slate-200 dark:border-slate-700 hover:bg-slate-50'
                    }`}
                  >
                    <MailCheck size={14} />
                    <span>{editingUser.isEmailVerified ? 'Verified' : 'Verify Email'}</span>
                  </button>

                  {/* Suspend / Reinstate Action */}
                  <button
                    type="button"
                    disabled={editingUser.role === 'SUPER_ADMIN'}
                    onClick={async () => {
                      await onToggleSuspension(editingUser.id);
                      setEditingUser({ ...editingUser, isSuspended: !editingUser.isSuspended });
                      showToast(
                        editingUser.isSuspended ? 'Account Reinstated' : 'Account Suspended',
                        'User account status toggled.'
                      );
                    }}
                    className={`p-2.5 rounded-xl border text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors cursor-pointer ${
                      editingUser.isSuspended
                        ? 'bg-emerald-50 text-emerald-700 border-emerald-200 hover:bg-emerald-100'
                        : 'bg-rose-50 text-rose-700 border-rose-200 hover:bg-rose-100'
                    }`}
                  >
                    <span>{editingUser.isSuspended ? 'Reinstate User' : 'Suspend User'}</span>
                  </button>
                </div>

                {/* Reset Password Button in Edit Modal */}
                {onResetPassword && (
                  <button
                    type="button"
                    onClick={() => {
                      setResettingUser(editingUser);
                      setEditingUser(null);
                    }}
                    className="w-full mt-2 py-2 px-3 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 hover:bg-slate-100 text-slate-700 dark:text-slate-200 text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors cursor-pointer"
                  >
                    <Key size={13} />
                    <span>Reset User Password</span>
                  </button>
                )}
              </div>

              <div className="flex justify-end pt-3 border-t border-slate-100 dark:border-slate-800">
                <button
                  type="button"
                  onClick={() => setEditingUser(null)}
                  className="px-4 py-2 bg-slate-900 text-white dark:bg-slate-100 dark:text-slate-900 rounded-xl text-xs font-semibold cursor-pointer"
                >
                  Done
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* 10. RESET PASSWORD MODAL                                  */}
      {/* ========================================================= */}
      {resettingUser && (
        <div className="fixed inset-0 z-50 bg-slate-950/60 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-md w-full border border-slate-200 dark:border-slate-800 shadow-2xl overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <div className="p-5 border-b border-slate-100 dark:border-slate-800 flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <div className="w-9 h-9 rounded-xl bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 flex items-center justify-center font-bold">
                  <Key size={16} />
                </div>
                <div>
                  <h3 className="font-bold text-slate-900 dark:text-white text-sm">Reset Password</h3>
                  <p className="text-xs text-slate-400 truncate max-w-xs">{resettingUser.email}</p>
                </div>
              </div>
              <button
                type="button"
                onClick={() => setResettingUser(null)}
                className="text-slate-400 hover:text-slate-600 dark:hover:text-slate-200"
              >
                <X size={18} />
              </button>
            </div>

            <form onSubmit={handleConfirmResetPassword} className="p-5 space-y-4">
              <div>
                <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">
                  New Password (min 6 characters)
                </label>
                <div className="relative">
                  <input
                    type="text"
                    required
                    minLength={6}
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    placeholder="Enter or generate temporary password..."
                    className="w-full pl-3 pr-28 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs font-mono dark:text-white focus:outline-none focus:ring-1 focus:ring-slate-400"
                  />
                  <button
                    type="button"
                    onClick={() => setNewPassword(generateRandomPassword())}
                    className="absolute right-2 top-1/2 -translate-y-1/2 px-2 py-0.5 text-[10px] font-semibold text-slate-700 dark:text-slate-300 bg-slate-200/80 dark:bg-slate-700 hover:bg-slate-300 rounded-md transition-colors flex items-center gap-1 cursor-pointer"
                  >
                    <Sparkles size={10} />
                    Generate
                  </button>
                </div>
              </div>

              <div className="flex items-center justify-end gap-2.5 pt-2 border-t border-slate-100 dark:border-slate-800">
                <button
                  type="button"
                  onClick={() => setResettingUser(null)}
                  className="px-3.5 py-2 text-xs font-semibold text-slate-600 dark:text-slate-400 hover:bg-slate-100 rounded-xl transition-colors cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={newPassword.length < 6 || isSubmittingPassword}
                  className="px-4 py-2 text-xs font-semibold text-white bg-slate-900 hover:bg-slate-800 dark:bg-brand-600 rounded-xl transition-colors cursor-pointer flex items-center gap-1.5 shadow-2xs"
                >
                  <Check size={13} />
                  <span>{isSubmittingPassword ? 'Updating...' : 'Update Password'}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* 11. DELETE USER CONFIRMATION MODAL                        */}
      {/* ========================================================= */}
      {deletingUser && (
        <div className="fixed inset-0 z-50 bg-slate-950/60 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white dark:bg-slate-900 rounded-2xl max-w-sm w-full border border-slate-200 dark:border-slate-800 shadow-2xl overflow-hidden animate-in fade-in zoom-in-95 duration-200 p-5 space-y-3.5 text-center">
            <div className="w-11 h-11 rounded-2xl bg-rose-100 dark:bg-rose-950/60 text-rose-600 dark:text-rose-400 flex items-center justify-center mx-auto">
              <AlertTriangle size={22} />
            </div>

            <div>
              <h3 className="font-bold text-slate-900 dark:text-white text-base">Delete User Account?</h3>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
                Are you sure you want to permanently delete{' '}
                <span className="font-semibold text-slate-800 dark:text-slate-200">
                  {deletingUser.email}
                </span>
                ? This action cannot be undone.
              </p>
            </div>

            <div className="flex items-center justify-center gap-2 pt-2">
              <button
                type="button"
                onClick={() => setDeletingUser(null)}
                className="px-3.5 py-2 text-xs font-semibold text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition-colors cursor-pointer"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleConfirmDelete}
                disabled={isDeleting}
                className="px-4 py-2 text-xs font-semibold text-white bg-rose-600 hover:bg-rose-700 rounded-xl transition-colors cursor-pointer flex items-center gap-1.5 shadow-2xs"
              >
                <Trash2 size={13} />
                <span>{isDeleting ? 'Deleting...' : 'Delete Account'}</span>
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
